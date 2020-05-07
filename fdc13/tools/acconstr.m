function [x,u] = acconstr(vtrim,ctrim,rolltype,turntype,gammatype)
%----------------------------------------------------------------
% The FDC toolbox - ACCONSTR.
% ===========================
% ACCONSTR is a Matlab subroutine which is called by ACCOST and
% ACTRIM in order to compute the pitch and roll angles and the
% angular velocities along the aircraft's body-axes, using con-
% straints for coordinated turns and for the rate of climb.
% See ref.[1] for more info about the trim algorithm.
%
% ACTRIM is the main aircraft-trim program; ACCOST is a subrou-
% tine which computes a scalar cost function. ACCOST calls the
% flight-path constraints subroutine ACCONSTR, because it needs
% the definitions of the state and input variables to determine
% the time-derivatives of the states.
%
% The rate-of-climb constraint and the coordinated turn con-
% straint (see ref.[1]) are used to obtain the pitch and roll
% angles. These variables are substituded in the kinematic rela-
% tions to obtain the angular velocities p, q, and r. The other
% elements from the state and input vectors x and u are read from
% the vectors ctrim and vtrim (except for the coordinates xe
% and ye, which are simply equalled to zero). The updated state
% and input variables are returned as outputs from ACCONSTR.
%
% The routine ACTRIM can be applied for all aircraft models which
% use the same definitions of the input and output vectors as the
% system BEAVER:
%
% x = [V alpha beta p q r psi theta phi xe ye H]',
% u = [deltae deltaa deltar deltaf n pz,
%                                   ,uw vw ww uwdot vwdot wwdot]'
%
% where: V      = airspeed [m/s]
%        alpha  = angle of attack [rad]
%        beta   = sideslip angle [rad]
%        p      = roll rate [rad/s]
%        q      = pitch rate [rad/s]
%        r      = yaw rate [rad/s]
%        psi    = yaw angle [rad]
%        theta  = pitch angle [rad]
%        phi    = roll angle [rad]
%        xe     = X-coordinate in Earth-fixed reference frame [m]
%        ye     = Y-coordinate in Earth-fixed reference frame [m]
%        H      = altitude above sea-level [m]
%
% and:   deltae = elevator deflection [rad]
%        deltaa = ailerons deflection [rad]
%        deltar = rudder deflection [rad]
%        deltaf = flap setting [rad]
%        n      = engine speed [RPM]
%        pz     = manifold pressure ["Hg]
%        uw     = wind & turbulence speed along Xb-axis [m/s]
%        vw     = wind & turbulence speed along Yb-axis [m/s]
%        ww     = wind & turbulence speed along Zb-axis [m/s]
%        uwdot  = d(ut)/dt [m/s^2]
%        vwdot  = d(vt)/dt [m/s^2]
%        wwdot  = d(vt)/dt [m/s^2]
%
% Although the wind and turbulence velocities and their time-
% derivatives are not involved in the trim process, these varia-
% bles cannot be ignored, because they are part of the input-
% vector to the nonlinear aircraft model. The trim program
% ACTRIM sets these variables to zero during trimming.
%
% ACCONSTR can be applied for other aircraft, as long as the de-
% finitions of the 'trim-constants vector' ctrim and the 'trim-
% variables vector' vtrim remain the same. This will always be
% true if the state and input vectors have the same definitions
% as for the system BEAVER. If ACTRIM needs to be applied to air-
% craftmodels with different state and input variables, the pro-
% gram ACTRIM.M and its subroutines need to be edited. However,
% the basic principles of the algorithm still apply!
%
% References.
% ===========
% [1]   Stevens, B.L., Lewis, F.L: 'Aircraft Control and Simula-
%       tion'. John Wiley & Sons Inc., 1992.
%
% Type HELP ACTRIM for more info. See also ACCOST.
%----------------------------------------------------------------

% Definition of variables.
% ------------------------
% if gammatype == 'f', i.e. if flight-path angle is specified by the user,
% manifold pressure adjusted numerically:
%
%   vtrim = [alpha beta deltae deltaa deltar pz]'
%
% else (gammatype == 'm', manifold pressure specified by the user, flight-
% path angle adjusted numerically):
%
%   vtrim = [alpha beta deltae deltaa deltar gamma]'
%
% vtrim contains variables which are optimized by the minimization routine
% FMINS, which is called from the main program ACTRIM.m.
%
% if gammatype == 'f', i.e. if flight-path angle is specified by the user,
% manifold pressure adjusted numerically:
%
%   ctrim = [V H psi gamma G psidot thetadot phidot deltaf n phi]'
%
% else (gammatype == 'm', manifold pressure specified by the user, flight-
% path angle adjusted numerically):
%
%   ctrim = [V H psi pz G psidot thetadot phidot deltaf n phi]'
%
% ctrim contains variables which are kept constant during the minimization
% process. The roll-angle phi in this vector is kept constant only when
% evaluating uncoordinated ('skidding') steady-state turns; if the turns
% are coordinated, the coordinated turn constraint will be used to obtain
% the roll-angle phi.
%
% rolltype is a string variable which specifies along which axis a steady
% roll condition has to be computed. If rolltype = 's', the stability axes
% will be used; if rolltype = 'b', a body-axes roll is considered. For
% steady wings-level flight, steady pull-ups or push-overs, or steady
% turns, the variable rolltype is set to the default setting 's', even
% though it is not used in the optimization process.
%
% turntype is a string variable which specifies if coordinated or uncoor-
% dinated turns are to be considered. If turntype = 'c', the coordinated
% turn constraint will be used; if turntype = 'u', it won't (in that case,
% the roll angle phi can be specified by the user, see the source code of
% ACTRIM.m, hence, phi will be read from the vector ctrim).
%
% gammatype is a string variable which specifies if the flight-path angle
% gamma or the manifold pressure pz is user-specified. If gammatype = 'f',
% the flightpath angle is specified by the user and pz is adjusted nu-
% merically; if gammatype = 'm', the manifold pressure is specified by
% the user, and gamma is adjusted manually.
% ---------------------------------------------------------------------------

% Helpvariables.
% --------------
sinalpha = sin(vtrim(1));
cosalpha = cos(vtrim(1));
tanalpha = tan(vtrim(1));
sinbeta  = sin(vtrim(2));
cosbeta  = cos(vtrim(2));

if gammatype == 'f'
  singamma = sin(ctrim(4));
else
  singamma = sin(vtrim(6));
end

% Compute the roll-angle phi from the coordinated turn constraint, or
% read it from the vector ctrim if an uncoordinated turn is considered.
% ---------------------------------------------------------------------
if turntype == 'c';
   % Coordinated turn constraint on phi
   % ----------------------------------
   a   = 1 - ctrim(5) * sinalpha/cosalpha * sinbeta;
   b   = singamma/cosbeta;
   c   = 1 + (ctrim(5)*cosbeta)^2;
   num = cosbeta*((a-b^2)+b*tanalpha*sqrt(c*(1-b^2)+ctrim(5)^2*sinbeta^2));
   den = cosalpha*(a^2-b^2*(1+c*tanalpha^2));
   phi = atan(ctrim(5)*num/den);
else
   phi = ctrim(11);
end

% Additional helpvariables.
% -------------------------
sinphi = sin(phi);
cosphi = cos(phi);

% Rate-of-Climb constraint on theta.
% ----------------------------------
a        = cosalpha*cosbeta;
b        = sinphi*sinbeta + cosphi*sinalpha*cosbeta;
num      = a*b + singamma*sqrt(a^2 - singamma^2 +b^2);
den      = a^2 - singamma^2;
theta    = atan(num/den);

% And still more helpvariables.
% -----------------------------
sintheta = sin(theta);
costheta = cos(theta);

if rolltype == 'b'       % Body-axes roll
   sinalpha = 0;
   cosalpha = 1;
end

% Calculate the angular velocities by substituting the pitch and roll
% angles in the kinematic relations.
% -------------------------------------------------------------------
p =  ctrim(8)*cosalpha - sintheta*ctrim(6);
q =  cosphi*ctrim(7) + sinphi*costheta*ctrim(6);
r = -sinphi*ctrim(7) + cosphi*costheta*ctrim(6) + sinalpha*ctrim(8);

% Now build the new state and input vectors x and u, which are
% returned by ACCONSTR.
% ------------------------------------------------------------
x = [ctrim(1) vtrim(1) vtrim(2) p q r ctrim(3) theta phi 0 0 ctrim(2)]';

if gammatype == 'f' % get pz from vtrim
   u = [vtrim(3) vtrim(4) vtrim(5) ctrim(9) ctrim(10) vtrim(6) 0 0 0 0 0 0]';
else  % get pz from ctrim
   u = [vtrim(3) vtrim(4) vtrim(5) ctrim(9) ctrim(10) ctrim(4) 0 0 0 0 0 0]';
end

%-------------------------------------------------
% The FDC toolbox. Copyright Marc Rauw, 1994-2000.
% Last revision of this program: January 16, 1996.

