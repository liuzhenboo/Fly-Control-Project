% The FDC toolbox. Trim routine ACTRIM.
% =====================================
% ACTRIM is a Matlab program, which computes steady-state trimmed
% flight conditions for nonlinear aircraft models in SIMULINK,
% which must have the same structure as the system BEAVER from
% the toolbox FDC 1.3. This trim routine is based upon an algo-
% rithm from ref.[1].
%
% The routine can be applied to all aircraft models which use
% the same definitions of the input and state vectors as the
% system BEAVER, being:
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
% It is necessary to edit ACTRIM if another definition of the in-
% put or state vector is used. To facilitate this, many comment
% lines have been included in the source file ACTRIM.M.
%
% Subroutines: ACCONSTR.M, evaluates flightpath constraints
%              ACCOST.M, evaluates cost function
%              COMMENT.M, evaluates... (well, you better try it yourself)
%              DATADIR.M, determines the default directory where FDC
%                  stores its datafiles
%              LOADER.M is called to load parameter matrices and vectors
%                  for the nonlinear aircraft model (type HELP LOADER for
%                  more info).
%
% Results from ACTRIM.
% ====================
% ACTRIM stores its results in the following variables:
%
%    xinco   : state vector in trimmed condition (see the defini-
%              tion, used in system BEAVER, given above),
%    uaero0  : inputvector to aerodynamic model, which is defined
%              by:  uaero = [deltae deltaa deltar deltaf]' in the
%              system BEAVER,
%    uprop0  : inputvector to engine model, which is defined by:
%              uprop = [n pz]' in the system BEAVER,
%    xdot0   : time-derivative of state vector in trimmed-flight
%              condition (Vdot, alphadot, betadot, pdot, qdot,
%              and rdot should be zero in a perfect steady-state
%              trim),
%    trimdef : text matrix, which contains the exact definition
%              of the trimmed flight condition.
%
% Note: in the system BEAVER, the total inputvector equals:
%
%     u = [ua' ut' uwind']',
%     where: uwind = [uw vw ww uwdot vwdot wwdot]'.
%
%
% Steady-state value of output vector
% ===================================
% ACTRIM does not return the initial value of the OUTPUTVECTOR
% from the system that is trimmed, because the definition of y
% is not standardized in the FDC package. If you do need the
% outputs for the trimmed-flight condition, run ACTRIM first,
% and type:
%
%     y0 = sfun(0, xinco, [uaero0; uprop0; 0;0;0;0;0;0], 3)
%
% where 'sfun' is the name of the system, e.g. sfun = beaver. The
% six zeros correspond with the wind velocities and their time-
% derivatives, which for trimming purposes are set zero (ACTRIM
% needs to be edited if you need trimmed-flight conditions for
% non-zero wind velocities!); the vector [uaero0;uprop0;0;0;0;0;0;0]
% is the total inputvector to the Simulink system sfun which con-
% tains the nonlinear aircraft model.
%
% Type HELP SFUNC for more info about this function-call.
%
% References
% ==========
% [1]   Stevens, B.L., Lewis, F.L: 'Aircraft Control and Simula-
%       tion'. John Wiley & Sons Inc., 1992.


% List of variables for ACTRIM
% ============================
% alpha       angle of attack [rad]
% answ        general: string variable used for storing user answers to yes/no
%             questions
% answ1       same as answ for nested questions
% beta        sideslip angle [rad]
% datadir     not a variable but a Matlab function, determines the default
%             data-directory for the FDC toolbox
% defdir      default directory where the FDC toolbox stores and searches for
%             datafiles
% deltaa      ailerons deflection [rad]
% deltae      elevator angle [rad]
% delttaf     flap angle [rad]
% deltar      rudder angle [rad]
% dirname     string variable with name of data-directory, entered by the user
% filename    string variable with name of datafile, entered by the user
% H           altitude [m]
% ii          counter
% jj          counter
% line#       string vectors, used to fill the text matrix 'trimdef' with infor-
%             mation about the linearized model
% loadcmmnd   string variable in which the load-command is defined (used if the
%             user wants to load an operating point from file, where the names
%             of the file, file-extension, and data-directory are obtained from
%             the variables filename and dirname)
% n           engine speed [RPM]
% ok          in general: flag used for while-loops in which the user must enter
%             certain parameters, etc.; while-loop is not quitted until this
%             variable has got the value 1 (for instance if the user has acknow-
%             ledged that the user-input is correct)
% ok1,ok2,... other flags, used for nested while-loops
% opt         variable used in user-menu's, which determines which menu option
%             has been selected by the user (exact meaning explained in source
%             text)
% p           roll-rate [rad/s]
% phi         roll-angle [rad]
% proceed     flag which is set to 0 if the user wants to quit the manual
%             operating-point definition; used to 'break' the corresponding
%             while-loop
% psi         yaw-angle [rad]
% pz          manifold pressure ["Hg]
% q           pitch-rate [rad/s]
% r           yaw-rate [rad/s]
% savecmmnd   string variable which specifies which results to save in which
%             file
% skip        flag which is set to 1 if user wants to quit the program; in
%             that case some parts of the program are skipped
% sysname     string variable, contains the name of the system to be
%             linearized
% t           time (t = clock, type HELP CLOCK for more info)
% t1          hours, extracted from t
% t2          minutes, extracted from t
% t3          seconds, extracted from t
% theta       pitch-angle [rad]
% trimdef     text matrix with information about the trimmed-flight operating
%             point (exists only if the user retrieves the operating point
%             from a file, created by ACTRIM, or if ACTRIM itself is called
%             during the operating point definition for the linearization
%             routine)
% turntype    variable for selecting coordinated or uncoordinated turns
%             (turntype == 'c' or turntype == 'v', respectively)
% uaero0      vector with initial values of aerodynamic control inputs,
%             defines operating point for the linearization routine
% udef        vector with numbers of the input variables which the user wants
%             to extract from the total of six control inputs and six wind &
%             turbulence inputs from the linearized model
% uinco       initial input vector, consists of uaero0, uprop0, and a zero-
%             value wind & turbulence vector
% uprop0      vector with initial values of engine control inputs, defines
%             operating point for the linearization routine
% V           airspeed [m/s]
% xdef        vector with numbers of the state variables which the user wants
%             to extract from the total of twelve state variables from the
%             linearized model
% xe          X-coordinate [m]
% xfix        gain variable which is used to specify states that should be
%             artificially fixed to their initial values (xfix is either equal
%             to 1 or equal to a vector of length twelve with elements that
%             equal 0 or 1, see the help-file XFIX.HLP or type HELP FIXSTATE
%             at the Matlab command line)
% xinco       initial value of the state vector, defines operating point for
%             linearization routine
% ye          Y-coordinate [m]
%-----------------------------------------------------------------------------

% Initialization commands
% -----------------------
format short e;
options = [];
turntype = 'c';

% Display header; welcome to ACTRIM!
% ----------------------------------
clc
disp('The FDC toolbox - ACTRIM');
disp('========================');
disp(' ');
disp('This program searches determines a steady-state trimmed-flight condition');
disp('for a non-linear aircraft model in Simulink.');
disp(' ');
disp(' ');

% Parameters for aircraft model:
%
% AM, EM, GM1, and GM2: matrices, containing parameters for the aircraft
%                       model. See also the source-code of MODBUILD.M
%                       (contained in the directory AIRCRAFT)
%
% The other model parameters will either be explained when they are used,
% or are self-explaining (at least if you know something about aircraft
% stability and control).
%
% Check if AM, EM, GM1, and GM2 have been defined in the Matlab workspace.
% If not, run LOADER to load them from file.
% -------------------------------------------------------------------------
if exist('AM')==0 | exist('EM')==0 | exist('GM1')==0 | exist('GM2')==0
   h = warndlg('First, the model parameters need to be retrieved from file (e.g. AIRCRAFT.DAT). Click ''OK'' to continue.');
   uiwait(h);
   loader
end

% Set xinco (= initial value of the state vector). Note: the value of xinco
% which is defined here doesn't really matter, because this variable won't
% be used during the trim process. The variable xinco must be defined in the
% Matlab Workspace, however, because Simulink needs it in order to define
% the system internally. The variable xinco is called by the Integrator
% block in the heart of the aircraft model (level 3: 'Aircraft Equations of
% Motion').
%
% In the aircraft model, some variables are made dimensionless by dividing
% by the dynamic pressure, 1/2*rho*V^2. In order to avoid 'Division By Zero'
% errors, the first element of xinco (=V) has been equalled to 45 [m/s],
% which is the mean velocity of the region in which the aerodynamic model
% of the 'Beaver' is valid. It could have been set to any value unequal to
% zero, however.
% -------------------------------------------------------------------------
xinco = [45 0 0 0 0 0 0 0 0 0 0 0]';

% The system BEAVER uses a gain block for arbitrarily setting time-
% derivatives of the state variables to zero. This may be useful for
% some purposes, for instance to eliminate longitudinal-lateral cross-
% coupling, or to fix the airspeed to its initial value if an altitude
% controller is to be evaluated, but no autothrottle is available yet.
% The gain value is xfix, which is set to 1 if all states may vary, i.e.,
% if the complete six degree-of-freedom model is used without restrictions.
% When states have to be fixed, the routine FIXSTATE.M can be called
% (type HELP FIXSTATE for more info).
%
% Here, all state variables are allowed to vary, so xfix will be set to
% one. Replace this line by:
%
%   fixstate;
%
% if you want to set some time-derivatives to zero, even when trimming
% the aircraft model.
% -------------------------------------------------------------------------
xfix = 1;
%%%% fixstate;

% The name of the aircraft model to be evaluated will be stored in the
% stringvariable sysname. The aircraft model must use the same definitions
% of the state and input vectors as the system BEAVER in order to function
% properly. Edit this program if your model uses other definitions!
% ------------------------------------------------------------------------
disp('Give name of system with aircraft model (8 characters max.)');
disp('default = beaver');
sysname = input('> ','s');
if isempty(sysname)
   sysname = 'beaver';
end

% Display menu in which the user can choose between a number of trimmed-
% flight conditions and quitting.
% ----------------------------------------------------------------------
clc
opt = menu('Select type of steady-state flight:',...
      'Steady wings-level flight','Steady turning flight',...
      'Steady pull-up','Steady roll','Quit');

skip  = 0; % Do not skip iteration block, unless option 'quit' is used
           % (then skip will be set to 1).

% Define flight condition, depending upon trim option chosen
% ----------------------------------------------------------
if opt == 1                                       % STEADY WINGS-LEVEL FLIGHT
                                                  % -------------------------
   clc
   disp('Steady wings-level flight.');
   disp('==========================');

   V = input('Give desired airspeed [m/s], default = 45: ');
   if isempty(V)
      V = 45;
   end

   H = input('Give (initial) altitude [m], default = 0: ');
   if isempty(H)
      H = 0;
   end

   psi  = input('Give heading [deg], default = 0: ')*pi/180;
   if isempty(psi)
      psi = 0;
   end

   gammatype = input('Use specified manifold pressure or flight-path angle ([m]/f)? ','s');
   if isempty(gammatype)
      gammatype = 'm';
   end
   if gammatype == 'f'
      gamma = input('Give flightpath angle [deg], default = 0: ')*pi/180;
      if isempty(gamma)
         gamma = 0;
      end
   end

   phidot   = 0;
   psidot   = 0;
   thetadot = 0;

   rolltype = 's';   % No rolling, so default setting, which is stability-
                     % axes roll, will be used.

elseif opt == 2                                       % STEADY TURNING FLIGHT
                                                      % ---------------------
   clc
   disp('Steady turning flight.');
   disp('======================');

   turntype = input('Do you want a coordinated or uncoordinated turn ([c]/u)? ','s');
   if isempty(turntype)
      turntype = 'c';
   end

   V = input('Give desired airspeed [m/s], default = 45: ');
   if isempty(V)
      V = 45;
   end

   H = input('Give initial altitude [m], default = 0: ');
   if isempty(H)
      H = 0;
   end

   psi = input('Give initial heading [deg], default = 0: ')*pi/180;
   if isempty(psi)
      psi = 0;
   end

   gammatype = input('Use specified manifold pressure or flight-path angle ([m]/f)? ','s');
   if isempty(gammatype)
      gammatype = 'm';
   end
   if gammatype == 'f'
      gamma = input('Give flightpath angle [deg], default = 0: ');
      if isempty(gamma)
         gamma = 0;
      end
   end

   phidot = 0;
   thetadot = 0;

   answ = input('Do you want to specify the turnrate (1) or turnradius (2)? ');
   if answ == 1
      psidot = input('Give desired rate of turn [deg/s], default = 0: ')*pi/180;
      if isempty(psidot)
         psidot = 0;
      end
   elseif answ == 2
      R = input('Give desired turn radius (>0) [m], default = straight & level: ');
      if isempty(R) ~= 1
         psidot = V/R;
      else
         psidot = 0;
      end
   end
   clear answ

   rolltype = 's';   % No rolling, so default setting, which is stability-
                     % axes roll, will be used.

elseif opt == 3                                              % STEADY PULL-UP
                                                             % --------------
   clc
   disp('Steady pull-up.');
   disp('===============');

   V = input('Give desired airspeed [m/s], default = 45: ');
   if isempty(V)
      V = 45;
   end

   H = input('Give initial altitude [m], default = 0: ');
   if isempty(H)
      H = 0;
   end

   psi = input('Give initial heading [deg], default = 0: ')*pi/180;
   if isempty(psi)
      psi = 0;
   end

   gammatype = 'f' % Use specified flightpath angle and numerically
                   % adjust manifold pressure
   gamma = input('Give initial flightpath angle [deg], default = 0: ')*pi/180;
   if isempty(gamma)
      gamma = 0;
   end

   phidot = 0;
   psidot = 0;

   thetadot = input('Give pull-up rate [deg/s], default = 0: ')*pi/180;
   if isempty(thetadot)
      thetadot = 0;
   end

   rolltype = 's';   % No rolling, so default setting, which is stability-
                     % axes roll, will be used.

elseif opt == 4                                                 % STEADY ROLL
                                                                % -----------
   clc
   disp('Steady roll.');
   disp('============');

   V = input('Give desired airspeed [m/s], default = 45: ');
   if isempty(V)
      V = 45;
   end

   H = input('Give initial altitude [m], default = 0: ');
   if isempty(H)
      H = 0;
   end

   psi = input('Give initial heading [deg], default = 0: ')*pi/180;
   if isempty(psi)
      psi = 0;
   end

   gammatype = input('Use specified manifold pressure or flight-path angle ([m]/f)? ','s');
   if isempty(gammatype)
      gammatype = 'm';
   end
   if gammatype == 'f'
      gamma = input('Give flightpath angle [deg], default = 0: ');
      if isempty(gamma)
         gamma = 0;
      end
   end

   thetadot = 0;
   psidot = 0;

   phidot = input('Give desired roll-rate [deg/s], default = 0: ')*pi/180;
   if isempty(phidot)
      phidot = 0;
   end

   ok = 0;
   while ok~= 1
      if phidot ~= 0
         rolltype = input('Roll in stability or body axes reference frame (b/s)? ','s');
      end
      if rolltype == 'b' | rolltype == 's'
         ok = 1;
      end
   end
   clear ok

else
   % Set helpvariable skip = 1, to ensure that the aircraft configuration
   % does not have to be entered if the user chooses option 5 = QUIT.
   % --------------------------------------------------------------------
   skip = 1;
end

%%%%

if skip ~= 1         % DEFINE CONFIGURATION OF THE AIRPLANE, IF NOT QUITTING
                     % -----------------------------------------------------

   % For the 'Beaver' model, the flap angle and engine speed define the
   % configuration of the aircraft (engine speed is selected by the pilot
   % and maintained by the regulator of the propeller). Other aircraft
   % may have other definitions, like gear in/out, slats, settings of trim
   % surfaces, multiple engines, etc., so change the following lines if
   % required!
   % ---------------------------------------------------------------------
   deltaf = input('Give flap angle [deg], default = 0: ')*pi/180;
   if isempty(deltaf)
      deltaf = 0;
   end

   n = input('Give engine speed [RPM], default = 1800: ');
   if isempty(n)
      n = 1800;
   end

   % For the 'Beaver' aircraft, the engine power is determined by the engine
   % speed, which has been set above, and the manifold pressure, which will
   % be involved in the trim process if the flightpath angle gamma is user-
   % specified, or kept constant if pz is user-specified (defined in string-
   % variable gammatype). If the manifold pressure is to be adjusted by the
   % numerical trim algorithm, it is important to specify a meaningful esti-
   % mation of the manifold pressure, because otherwise the trim process may
   % not converge, or may give unrealistic results if the optimization pro-
   % cess converges to a LOCAL minimum.
   % -----------------------------------------------------------------------
   if gammatype == 'f'
      pz = input('Give estimate of manifold pressure pz ["Hg], default = 20: ');
   else  % gammatype == 'm'
      pz = input('Give manifold pressure pz ["Hg], default = 20: ');
   end
   if isempty(pz)
      pz = 20;
   end

%   % Hdot is the rate-of-climb, which is a function of the flightpath angle
%   % (change the program if you want to specify Hdot itself in stead of
%   % the flightpath angle gamma).
%   % ----------------------------------------------------------------------
%   Hdot = V*sin(gamma);

   % G is the centripetal acceleration, used for the coordinated turn
   % constraint.
   % ----------------------------------------------------------------
   G = psidot*V/9.80665;

   % If steady, uncoordinated, turning condition must be determined, the
   % roll angle can be specified freely; equilibrium will be obtained for
   % a trimmed-flight sideslip angle, which in this case usually will be
   % quite large.
   % --------------------------------------------------------------------
   phi = [];
   if opt == 2 & turntype == 'u';  % Steady turn, uncoordinated.
      phi = input('Give desired roll angle phi [deg], default = 0: ')*pi/180;
   end

   if isempty(phi)
      phi = 0;
   end

   % All variables which specify the flight condition will be put in the
   % vector ctrim (constants for trim process). The variables which are
   % varied by the minimization routine FMINS will be put into the vector
   % vtrim (variables for trim process). These vectors will have to be
   % redefined for aircraft which use other state or input vectors.
   %
   % The variable phi in ctrim is used for uncoordinated turns only; if a
   % coordinated turn is required, the coordinated turn constraint determines
   % the values of phi and beta. Type HELP ACCONSTR for more info.
   %
   % Definition:
   %
   % if gammatype =='f' (flight-path angle user-specified and manifold
   % pressure numerically adjusted):
   %    vtrim = [alpha beta deltae deltaa deltar pz]'
   % else
   %    vtrim = [alpha beta deltae deltaa deltar gamma]'
   %
   % Note: vtrim contains the first estimation of the non-constant states
   % and inputs. The final values will be determined iteratively.
   % -----------------------------------------------------------------------
   if gammatype == 'f' % gamma in ctrim, pz in vtrim
      ctrim = [V H psi gamma G psidot thetadot phidot deltaf n phi]';
      vtrim = [0 0 0 0 0 pz]';
   else % gamma in vtrim, pz in ctrim
      ctrim = [V H psi pz G psidot thetadot phidot deltaf n phi]';
      vtrim = [0 0 0 0 0 0]';  % <-- initial guess for gamma = 0!
   end

   % Options for the minimization routine FMINS. Type HELP FMINS or
   % HELP FOPTIONS for more info. Note: opts contains the desired values
   % of the options, the actual values will be returned in the vector
   % options when calling the FMINS routine later on.
   % -------------------------------------------------------------------
   options     = foptions([]);  % Use default options for FMINS...
   options(2)  = 1e-10;         % ... except for the error tolerance, which
   options(3)  = 1e-10;         %     is set to a smaller value.

   % The Simulink system BEAVER or an equivalent aircraft model is called by
   % the function call xdot = feval('beaver',t,x,u,'outputs'), followed by
   % xdot = feval('beaver',t,x,u,'derivs') to obtain the time-derivatives of
   % the state vector x. Here t = 0 (system is time-independent). The
   % function call is created here, and stored in the variable modfun.
   % Note: the aircraft model itself will be compiled before applying these
   % function calls!
   % -----------------------------------------------------------------------
   modfun   = ['xdot = feval(''',sysname,''',0,x,u,''outputs'');'];
   modfun   = [modfun 'xdot = feval(''',sysname,''',0,x,u,''derivs'');'];

   % Iteration loop in which the steady-state flight condition is searched.
   % If the variable iterate is set to 0, the iteration will be stopped.
   % If no stable solution has been found before reaching the maximum num-
   % ber of iterations, a warning message will be displayed and the user
   % will be asked if the routine should continue with the iterations, or
   % stop. Usually a stable solution will be found before reaching the
   % maximum number of iterations.
   % ----------------------------------------------------------------------

   iterate = 1;
   while iterate
      clc;
      disp('Searching for stable solution. Wait a moment...');
      disp(' ');
      disp(' ');
      pause(0.5)
      comment
      home
      pause(0.5)

      % First pre-compile the aircraft model.
      % -------------------------------------
      feval(sysname,[],[],[],'compile');

      % Call minimization routine FMINS. A scalar cost function is contained
      % in the M-file ACCOST, which also calls the constraints for coordinated
      % turns and rate-of-climb of the aircraft. FMINS returns the trim values
      % of alpha, beta, deltae, deltaa, deltar, and pz in the vector vtrimmed.
      % ----------------------------------------------------------------------
      [vtrimmed,options] = fmins('accost',vtrim,options,[],...
                                 ctrim,rolltype,turntype,gammatype,modfun);

      if options(10) == options(14) % reached maximum number of iterations
                                    % before finding stable solution

         disp('Warning: solution hasn''t converged.');
         answ=input('Perform more iterations (y/n)? ','s');
         if answ == 'y'
            iterate  = 1;           % continue the minimization process
            vtrim = vtrimmed;
         else
            iterate = 0;            % no solution found, but stop iteration
         end
         disp(' ');
      else
         iterate = 0;               % solution found, stop iteration
      end
   end
   clear iterate

   clc;
   disp('Iteration stopped.');
   disp(' ');
   disp('<<< Press a key to get results >>>');
   pause

   % Call subroutine ACCONSTR, which contains the flight-path constraints
   % once more to obtain the final values of the inputvector and states.
   % --------------------------------------------------------------------
   [x,u] = acconstr(vtrimmed,ctrim,rolltype,turntype,gammatype);

   % Call a/c model once more, to obtain the time-derivatives of the states
   % in trimmed-flight condition. By examining xdot, the user can decide if
   % the trimmed-flight condition is accurate enough. If not, either the
   % error tolerance of the minimization routine needs to be tightened, or
   % the cost function in ACCOST.M needs to be changed.
   % -----------------------------------------------------------------------
   eval(modfun);

   % Release compiled aircraft model now that all results are known
   % --------------------------------------------------------------
   feval(sysname,[],[],[],'term');

   % Get rid of variables from optimization process which are not needed
   % anymore.
   % -------------------------------------------------------------------
   clear ctrim vtrim vtrimmed options modfun

   % Display the final results. x, u, and xdot contain the inputvector,
   % state vector, and time-derivative of the state vector, respectively.
   % --------------------------------------------------------------------
   clc
   disp('State vector (trimmed): ');
   x
   disp(' ');
   disp(' ');
   disp('<<< Press a key >>>');
   pause

   clc
   disp('Input vector (trimmed): ');
   u
   disp(' ');
   disp(' ');
   disp('<<< Press a key >>>');
   pause

   clc
   disp('Time derivative of state vector (trimmed): ');
   xdot
   disp(' ');
   disp(' ');
   disp('<<< Press a key >>>');
   pause

   % The integrator block in the aircraft model uses the Matlab variable
   % xinco to store the initial value of x. The models from the library
   % EXAMPLES use the variables uaero0 and uprop0 to store the initial values
   % of the inputs to the aerodynamic and engine models, respectively.
   % Usually, trimmed-flight conditions are used as initial conditions.
   % Therefore, the trimmed-flight conditions will be stored in these'
   % variables, to ensure compatibility with the Simulink systems. The
   % trimmed-flight value of xdot = dx/dt will be stored in the variable
   % xdot0, which indicates that this value of xdot is obtained for the
   % INITIAL flight condition, defined by xinco, uaero0, and uprop0.
   %-------------------------------------------------------------------
   xinco  = x;          % Initial value of state vector
   xdot0  = xdot;       % Initial value of time-derivative of state vector
   uaero0 = u(1:4);     % Initial value of input vector for aerodynamic model
   uprop0 = u(5:6);     % Initial value of input vector for engine
                        %                            forces and moments model

   clear x xdot u

   % Now, a string-matrix will be created, which contains a description of
   % the trimmed-flight condition. Note: the function NUM2STR2 is just a
   % sligtly changed version of NUM2STR. Type HELP NUM2STR2 at the Matlab
   % command line for more info.
   % ---------------------------------------------------------------------
   line1  = ['Trimmed-flight condition for S-function ' sysname ':'];
   line1a = '';

   if opt == 1
      line2 = ['Steady-state wings-level flight'];
   elseif opt == 2
      line2 = ['Steady-state turning flight'];
   elseif opt == 3
      line2 = ['Steady pull-up'];
   elseif opt == 4
      if rolltype == 'b'  % Body-axis roll
         line2 = ['Steady roll along the body-axis'];
      else  % Stability-axis roll (default)
         line2 = ['Steady roll along the stability-axis'];
      end
   end

   line3  = '';
   line4  = ['User-specified definition of aircraft and flight condition:'];
   line5  = '';
   line6  = ['Flap angle:       deltaf    =  ' num2str2(deltaf,10) ' [deg]  '];
   line7  = ['Engine speed:     n         =  ' num2str2(n,10)      ' [RPM]  '];
   line8  = ['Airspeed:         V         =  ' num2str2(V,10)      ' [m/s]  '];
   line9  = ['Altitude:         H         =  ' num2str2(H,10)      ' [m]    '];
   line10 = ['Yaw-angle:        psi       =  ' num2str2(psi,10)    ' [deg]  '];

   if gammatype == 'f'
      line11 = ['Flightpath angle: gamma     =  ' num2str2(gamma,10)  ' [deg]  '];
   else
      line11 = ['Manifold pressure: pz       =  ' num2str2(pz,10)     ' ["Hg]  '];
   end
   line12 = ['Yaw-rate:         psi dot   =  ' num2str2(psidot,10)   ' [deg/s]'];
   line13 = ['Pitch-rate:       theta dot =  ' num2str2(thetadot,10) ' [deg/s]'];
   line14 = ['Roll-rate:        phi dot   =  ' num2str2(phidot,10)   ' [deg/s]'];

   if opt == 2 & turntype == 'u' % uncoordinated turn
      line15 = ['Uncoordinated turn,'];
      line16 = ['Roll-angle:       phi       =  ' num2str2(phi,10) ' [deg]'];
   elseif opt == 2 & turntype == 'c' % coordinated turn
      line15 = ['Coordinated turn'];
      line16 = '';
   else % no turning flight
      line15 = '';
      line16 = '';
   end

   % Some general remarks, need to be changed manually by the user!
   % --------------------------------------------------------------
   line17 = 'Definitions of state and input vectors as in system BEAVER:';
   line18 = 'x = [V alpha beta p q r psi theta phi xe ye H]''';
   line19 = 'u = [deltae deltaa deltar deltaf n pz uw vw ww uwdot vwdot wwdot]''';
   line20 = '';

   % Add info about the variables in the Matlab Workspace.
   % -----------------------------------------------------
   line21 = 'Variables: xdot=initial state, uaero0=initial inputs to aeromodel';
   line22 = 'uprop0=initial input to engine forces/moments model, xdot0=dx/dt(0)';
   line23 = '';

   % Add time and date to text matrix.
   % ---------------------------------
   t  = clock;
   t1 = num2str(t(4));
   t2 = num2str(t(5));
   t3 = num2str(t(6));

   line24 = ['date: ', date, '   time: ', t1, ':', t2, ':', t3];

   clear t t1 t2 t3

   % Now all explanatory lines will be enhanced to 80 characters,
   % in order to fit them into one string matrix.
   % ------------------------------------------------------------
   line1  = [line1  blanks(79-length(line1 ))];
   line1a = [line1a blanks(79-length(line1a))]; % Well, nothing is perfect...
   line2  = [line2  blanks(79-length(line2 ))];
   line3  = [line3  blanks(79-length(line3 ))];
   line4  = [line4  blanks(79-length(line4 ))];
   line5  = [line5  blanks(79-length(line5 ))];
   line6  = [line6  blanks(79-length(line6 ))];
   line7  = [line7  blanks(79-length(line7 ))];
   line8  = [line8  blanks(79-length(line8 ))];
   line9  = [line9  blanks(79-length(line9 ))];
   line10 = [line10 blanks(79-length(line10))];
   line11 = [line11 blanks(79-length(line11))];
   line12 = [line12 blanks(79-length(line12))];
   line13 = [line13 blanks(79-length(line13))];
   line14 = [line14 blanks(79-length(line14))];
   line15 = [line15 blanks(79-length(line15))];
   line16 = [line16 blanks(79-length(line16))];
   line17 = [line17 blanks(79-length(line17))];
   line18 = [line18 blanks(79-length(line18))];
   line19 = [line19 blanks(79-length(line19))];
   line20 = [line20 blanks(79-length(line20))];
   line21 = [line21 blanks(79-length(line21))];
   line22 = [line22 blanks(79-length(line22))];
   line23 = [line23 blanks(79-length(line23))];
   line24 = [line24 blanks(79-length(line24))];

   % The explanatory lines are collected in the matrix trimdef.
   % -------------------------------------------------------------
   trimdef = [line1;  line1a; line2;  line3;  line4;  line5;  line6;
              line7;  line8;  line9;  line10; line11; line12; line13;
              line14; line15; line16; line17; line18; line19; line20;
              line21; line22; line23; line24];

   clear line1  line1a line2  line3  line4  line5  line6  line7  line8  line9
   clear line10 line11 line12 line13 line14 line15 line16 line17 line18 line19
   clear line20 line21 line22 line23 line24

   % Get rid of definitions of flight condition which now have
   % become obsolete.
   % ---------------------------------------------------------
   clear opt V H psi gamma phidot psidot thetadot rolltype turntype gammatype
   clear deltaf n pz Hdot G phi sysname

   % Results can now be saved to a file, which will be filled with the
   % trim condition xinco, uaero0, uprop0, xdot0, and the explanation matrix
   % trimdef.
   %
   % Note: files with steady-state trimmed flight condition have
   % extension .TRI!
   % -----------------------------------------------------------------
   clc
   answ = input('Save trimmed condition to file (y/n)? ','s');
   if answ == 'y'

      % Determine destination-directory
      % -------------------------------
      defdir = datadir;             % Default FDC data-directory,
                                    %   see the function DATADIR.M

      % Go to default directory if that directory exists (if not, start
      % save-routine from the current directory).
      % ---------------------------------------------------------------
      currentdir = chdir;
      eval(['chdir ',defdir,';'],['chdir ',currentdir,';']);

      % Obtain filename and path.
      % -------------------------
      [filename,dirname] = uiputfile('*.tri','Save trimmed flight condition');

      % Build string variable which specifies what to save in which file.
      % -----------------------------------------------------------------
      savecmmnd=['save ',dirname,filename,' xinco uaero0 uprop0 xdot0 trimdef'];

      % Execute save command, and display file and directory.
      % -----------------------------------------------------
      clc;
      disp(['Results saved to the file: ',dirname,filename]);
      eval(savecmmnd);

      disp(' ');
      disp('<<< Press a key >>>');
      pause
   end
   clear answ dirname filename savecmmnd defdir currentdir

   % Display user-information.
   % -------------------------
   clc
   disp('The results have been stored in the following variables:');
   disp(' ');
   disp('xinco = [V alpha beta p q r psi theta phi xe ye H]'' = state vector');
   disp('xdot0 = dx/dt(0)');
   disp('uaero0= [deltae deltaa deltar deltaf]'' = initial input vector for');
   disp('                                          aerodynamic model');
   disp('uprop0= [n pz]'' = initial input vector for engine model');
   disp(' ');
   disp('The text-matrix ''trimdef'' contains more info about the trimmed');
   disp('flightcondition.');
   disp(' ');

end                % END OF TRIM-LOOP (SKIPPED IF OPTION 5 = QUIT IS SELECTED)
clear skip

disp(' ');
disp('Ready.');
disp(' ');


%------------------------------------------------------------------------------
% The FDC toolbox. Copyright Marc Rauw, 1994-2000.
% Last revision of this program: June 12, 2000 (SR2 fix).
%
% History of this file since September 8, 1997:
% =============================================
% September 8, 1997
%   - replaced cd commands with chdir to enhance compatibility
% October 5, 1997
%   - editorial changes
%   - added initialization of some variables for Matlab 5 compatibility
%   - changed code for defining gammatype and turntype in order to prevent
%     Matlab 5 warnings
% October 21, 1997
%   - added aircraft model compilation code for Matlab 5 compatibility
%   - deleted confusing messages about model-initialization by Simulink
%   - changed call to aircraft model for Matlab 5 compatibility
%   - added code to release compiled aircraft model after finishing the
%     iterations
%   - added warning dialog in case model parameters are to be retrieved from
%     a file by calling the function LOADER
% February 7, 1998
%   - changed options definition (previously, variable opts was defined, but
%     not used in practice)
% June 12, 2000
%   - exchanged 'options' and '[ ]' input arguments in FMINS call (bugfix)
%   - corrected line 646 (vtrim = vtrimmed i.s.o. vtrimmed = vtrim)
%   - corrected gamma definition in line 323 (included pi/180 multiplication)