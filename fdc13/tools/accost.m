function J = accost(vtrim,ctrim,rolltype,turntype,gammatype,modfun);
%----------------------------------------------------------------
% The FDC toolbox - ACCOST
% ========================
%
% ACCOST is a Matlab subroutine which is called by the minimali-
% zation routine FMINS, which in turn is called from within the
% aircraft trim routine ACTRIM. It computes a scalar cost func-
% tion, which is a quadratic function of the time-derivatives of
% the true airspeed, angle of attack, sideslip angle, and the
% angular velocities p, q, and r along the body-axes of the air-
% craft. These time-derivatives are determined in ACCOST by
% calling the S-function which contains the aircraft model with
% the line that is stored in the string variable modfun (see
% the source-code of ACTRIM.M).
%
% The time-derivatives can only be determined if the state and
% inputvectors are known. These vectors are built up from user-
% specified constants, variables which are changed by the opti-
% malization routine FMINS, and variables which follow from
% flightpath constraints. The subroutine ACCONSTR is called to
% build the (current) state and input vectors. See ref.[1] for
% more details on the trim algorithm.
%
% ACTRIM functions properly only if the aircraft model uses the
% same definitions of the state and input vectors as the system
% BEAVER:
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
% ACCOST can be applied for other aircraft, as long as the de-
% finitions of the 'trim-constants vector' ctrim and the 'trim-
% variables vector' vtrim remain the same. This will always be
% true if the state and input vectors have the same definitions
% as the state and input vectors of the system BEAVER. If ACTRIM
% has to be applied to aircraftmodels with other state and input
% variables, the program ACTRIM.M and its subroutines need to be
% edited. However, the basic principles of the trim algorithm
% still apply!
%
% Cost function.
% ==============
% The cost function has the following form:
%
%    J = c1*Vdot^2 + c2*alpha_dot^2 + c3*beta_dot^2 +
%        + c4*pdot^2 + c5*qdot^2 + c6*rdot^2
%
% Here c1 = 1, c2 = c3 = 2, and c4 = c5 = c6 = 5. For the 'Bea-
% ver' aircraft, these values have given satisfying results
% (which are very similar to the results from ref.[2]). If it is
% necessary to change these weighting factors, the last line of
% ACCOST.M needs to be edited. If you examine models of other air-
% craft, it is recommended to experiment with different weighting
% functions!
%
% References.
% ===========
% [1]   Stevens, B.L., Lewis, F.L.: 'Aircraft Control and Simula-
%       tion'. John Wiley & Sons Inc., 1992.
% [2]   Tjee, R.T.H., Mulder, J.A.: Stability and Control Deriva-
%       tives of the De Havilland DHC-2 "Beaver" aircraft. Report
%       LR-556, Delft University of Technology, 1988.
%
% Type HELP ACTRIM for more info. See also ACCONSTR.
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


% First, the current state and input vectors will be determined. Some
% states and inputs are constant; these will be read from the vector
% ctrim in the subroutine ACCONSTR. The pitch angle, roll angle, and the
% angular velocities are determined from flightpath constraints on the
% rate of climb and coordinated turns, and from kinematic relations, which
% are also contained in ACCONSTR. The remaining variables are adjusted by
% the minimization routine FMINS, and stored in the (current) state and
% input vectors by ACCONSTR. So first, the subroutine ACCONSTR is called.
% ------------------------------------------------------------------------
[x,u] = acconstr(vtrim,ctrim,rolltype,turntype,gammatype);

% Compute the time derivative of the state vector x.
% xdot = dx/dt; x = [V alpha beta p q r psi theta phi xe ye H]'
% (definition, used in 'Beaver' model!).
% -------------------------------------------------------------
eval(modfun);

% Scalar cost function.
% ---------------------
J = xdot(1)^2 + 2*(xdot(2)^2+xdot(3)^2) + 5*(xdot(4)^2+xdot(5)^2+xdot(6)^2);


%-------------------------------------------------
% The FDC toolbox. Copyright Marc Rauw, 1994-2000.
% Last revision of this program: December 1995.

