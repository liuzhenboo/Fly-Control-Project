% The FDC toolbox. Linearization routine ACLIN.
% =============================================
% ACLIN is a Matlab program, which can be used to linearize air-
% craft models in SIMULINK. These models must have the same in-
% put/output structure as the system BEAVER from the FDC toolbox
% In ACLIN, it is possible to simplify the resulting linear state-
% space model, e.g. to neglect longitudinal/lateral cross-coupling.
%
% ACLIN can be applied to all aircraft models which use the same
% definitions of the input and state vectors as the system BEAVER:
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
% ACLIN uses the Simulink function LINMOD, with default lineari-
% zation options. For the 'Beaver' model, this yields satisfying
% results. However, if you customize the aircraft model, it is
% advisable to experiment somewhat with these options (type HELP
% LINMOD for more info). If you want to change the linearization
% options or apply this program to aircraft models with other
% definitions of the state and input vectors, ACLIN needs to be
% edited. Many comment lines have been added to facilitate this.
%
% It is important to realize that 99% of the program code of ACLIN
% consists of a user-interface to define the operating point, and
% select the states and inputs for the linearized model. The ac-
% tual linearization algorithm is contained in the Simulink uti-
% lity LINMOD! If you want to experiment with different lineari-
% zation algorithms, you should write your own program, based
% upon LINMOD.M, and replace the call of LINMOD within the program
% ACLIN by a call to your own linearization program.
%
% See also ACTRIM for more info about the determination of steady-
% state trimmed-flight conditions (which may be used as operating
% point definitions for ACLIN).


% List of variables for ACLIN
% ===========================
% Aac         system matrix of linearized aircraft model
% Aac_s       system matrix of 'simplified' linearized model
% allinputs   flag variable which is set to 1 if the user wants to use all
%             twelve input variables for the linearized models, or 0 if the
%             user wants to extract a limited number of inputs from the
%             linearized model
% allstates   flag variable which is set to 1 if the user wants to use all
%             twelve state variables for the linearized models, or 0 if the
%             user wants to extract a limited number of state variables from
%             the linearized model
% alpha       angle of attack [rad]
% answ        general: string variable used for storing user answers to
%             yes/no questions
% answ1       same as answ for nested questions
% Bac         system matrix of linearized aircraft model
% Bac_s       system matrix of 'simplified' linearized model
% beta        sideslip angle [rad]
% Cac         system matrix of linearized aircraft model
% Cac_s       system matrix of 'simplified' linearized model
% Dac         system matrix of linearized aircraft model
% Dac_s       system matrix of 'simplified' linearized model
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
% lindef      text matrix with information about the linearized model (examine
%             this matrix to find out the definitions of state-vector, input-
%             vector, simplified state and input vectors, operating point
%             definition, etc.)
% line#       string vectors, used to fill the text matrix 'lindef' with
%             information about the linearized model
% loadcmmnd   string variable in which the load-command is defined (used if
%             the user wants to load an operating point from file, where the
%             names of the file, file-extension, and data-directory are ob-
%             tained from the variables filename, and dirname)
% n           engine speed [RPM]
% ok          in general: flag used for while-loops in which the user must
%             enter certain parameters, etc.; while-loop is not quitted until
%             this variable has got the value 1 (for instance if the user has
%             acknowledged that the user-input is correct)
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
% setdir      not a variable but a Matlab function that is called for letting
%             the user specify a directory name
% skip        flag which is set to 1 if user wants to quit the program; in
%             that case some parts of the program are skipped
% sysname     string variable, contains the name of the system to be linea-
%             rized
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

format short e

skip = 0;         % Help variable which is set to 1 if user selects
                  % QUIT from main menu. If skip = 1, the last part of
                  % ACLIN, where the actual linearization takes place,
                  % is skipped.

% Welcome...
% ----------
clc
disp('FDC 1.2 - ACLIN');
disp(' ');
disp('Linearize nonlinear aircraft model in SIMULINK.');
disp('===============================================');
disp(' ');

% Enter name of the aircraft model.
% ---------------------------------
disp('Enter name of the aircraft model in Simulink (default: BEAVER)');
sysname = input('> ','s');
if isempty(sysname)
   sysname = 'beaver';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define or load operating point.
% ===============================

ok = 0;
while ok ~= 1  % While-loop for correctly entering or loading operating
               % point. Normally, loop will be quitted directly, but if
               % definitions are not OK, operating point definition will
               % start all over again. If ok == 1, while-loop will be
               % left, and ACLIN will proceed with model parameter defi-
               % nition and linearization itself.
               % -------------------------------------------------------
   clc
   opt = menu('Choose one of the following options:',...
         'Load operating point from file',...
         'Manually define operating point',...
         'Use operating point defined in workspace',...
         'Run ACTRIM to determine trimmed flight condition',...
         'Quit');

   if opt == 1                                       % LOAD OPERATING POINT
                                                     % --------------------

         % Define default data-directory by calling the subroutine DATADIR.M
         % (which is also used by other FDC subroutines).
         % -----------------------------------------------------------------
         defdir     = datadir;

         % If default directory exists, temporarily switch to that directory.
         % ------------------------------------------------------------------
         currentdir = chdir;
         eval(['chdir ',defdir,';'],['chdir ',currentdir,';']);

         % Obtain filename and path.
         % -------------------------
         [filename,dirname] = uigetfile('*.tri',...
                                        'Load operating point from file');

         loadcmmnd=['load ',dirname,filename, ' -mat'];
         eval([loadcmmnd,'; ok = 1;'],'disp(''File not found!'')');

         % Back to previous directory
         % --------------------------
         eval(['chdir ',currentdir,';']);

   elseif opt == 2                        % MANUALLY DEFINE OPERATING POINT
                                          % -------------------------------
      clc
      disp('Manually define operating point.');
      disp('--------------------------------');

      % While-loop for correctly entering the state vector.
      % ---------------------------------------------------
      ok1 = 0;        % If ok1 == 1, the while-loop for entering xinco
                      % will be quitted; proceed with definition of uaero0.

      proceed = 1;    % If proceed == 0, the while-loop for entering xinco
                      % will be quitted, and manual definition will stop.

      while ok1 ~= 1 & proceed == 1
         disp(' ');
         disp('State vector: [V alpha beta p q r psi theta phi xe ye H]''');
         disp(' ');

         % While-loop to make sure that V has a value unequal to zero. User
         % must select a reasonable V himself, but at least this check makes
         % sure that no 'Division by zero errors' will occur in the Simulink
         % system of the nonlinear aircraft model.
         % -----------------------------------------------------------------
         ok2 = 0;
         while ok2 ~= 1
            V = input('airspeed [m/s]          : ');
            if V == 0
               disp(' ');
               disp('V must have a value > 0!');
            else
               ok2 = 1;
            end
         end
         clear ok2

         alpha  = input('angle of attack [rad]   : ');
         beta   = input('sideslip angle [rad]    : ');
         p      = input('roll-rate [rad/s]       : ');
         q      = input('pitch-rate [rad/s]      : ');
         r      = input('yaw-rate [rad/s]        : ');
         psi    = input('yaw-angle [rad]         : ');
         theta  = input('pitch-angle [rad]       : ');
         phi    = input('roll-angle [rad]        : ');
         xe     = input('x-coordinate [m]        : ');
         ye     = input('y-coordinate [m]        : ');
         H      = input('altitude [m]            : ');

         xinco  = [V alpha beta p q r psi theta phi xe ye H]';

         % Ask if state vector is correct. If not, re-enter, or go back
         % to main menu. If the length of the state vector is too short,
         % because the user has pressed <ENTER> without giving a number
         % for one or more of the states, the state-vector must be
         % re-entered by the user too.
         % ---------------------------------------------------------------
         disp(' ');

         if length(xinco) == 12    % xinco has right number of elements
            clc
            disp('Current definition of state vector:');
            xinco

            answ = input('Is this correct (y/n)? ','s');
            if answ == 'y'
               ok1 = 1;            % leave loop for entering xinco
            else
               disp(' ');
               answ1 = input('Proceed with manual definition (y/n)? ','s');
               if answ1 == 'n'
                  proceed = 0;     % do not proceed with manual definition
               end
            end
            clear answ answ1

         else                      % length of xinco is NOT right
            clc
            disp('State vector is too short! You probably have pressed');
            disp('<ENTER> without entering a value for one or more states.');
            disp(' ');

            answ1 = input('Proceed with manual definition (y/n)? ','s');
            if answ1 == 'n'
               proceed = 0;     % do not proceed with manual definition
            else
               disp(' ');
               disp('Please re-enter state vector.');
            end
            clear answ1

            disp(' ');
            disp('<<< Press a key >>>');
            pause
            clc
         end
      end

      % While-loop for correctly entering the aerodynamic inputs.
      % ---------------------------------------------------------
      ok1 = 0;        % If ok1 == 1, the while-loop for entering uaero0
                      % will be quitted; proceed with definition of uprop0,
                      % unless user has chosen to quit manual definition
                      % of user point (then proceed == 0).

      while ok1 ~= 1 & proceed == 1

         clc
         disp('Aerodynamic inputs: [deltae deltaa deltar deltaf]''');
         disp(' ');
         deltae = input('elevator angle [rad]     : ');
         deltaa = input('ailerons deflection [rad]: ');
         deltar = input('rudder angle [rad]       : ');
         deltaf = input('flap angle [rad]         : ');

         uaero0 = [deltae deltaa deltar deltaf]';

         % Ask if aerodynamic inputvector is correct. If not, re-enter. If
         % the length of the aerodynamic inputvector is too short because
         % the user has pressed <ENTER> without giving a number for one or
         % more inputs, this inputvector must be re-entered by the user.
         % ---------------------------------------------------------------
         disp(' ');

         if length(uaero0) == 4  % uaero0 has right number of elements
            clc
            disp('Current definition of inputvector to aerodynamic model:');
            uaero0

            answ = input('Is this correct (y/n)? ','s');
            if answ == 'y'
               ok1 = 1;           % leave while-loop to define uaero0
            else
               disp(' ');
               answ1 = input('Proceed with manual definition (y/n)? ','s');
               if answ1 == 'n'
                  proceed = 0;     % do not proceed with manual definition
               end
            end
            clear answ answ1

         else                      % length of uaero0 is NOT right
            clc
            disp('Inputvector is too short! You probably have pressed');
            disp('<ENTER> without entering a value for one or more inputs.');
            disp(' ');

            answ1 = input('Proceed with manual definition (y/n)? ','s');
            if answ1 == 'n'
               proceed = 0;     % do not proceed with manual definition
            else
               disp(' ');
               disp('Please re-enter state vector.');
            end
            clear answ1

            disp(' ');
            disp('<<< Press a key >>>');
            pause
         end
      end

      % While-loop for correctly entering the engine inputvector.
      % ---------------------------------------------------------
      ok1 = 0;        % If ok1 == 1, the while-loop for entering uprop0
                      % will be quitted, and definitions of xinco, uaero0, and
                      % uprop0 entered so far will be used in linearization,
                      % unless the user already has specified that the
                      % manual operating point definition must be stopped,
                      % in which case proceed == 0.

      while ok1 ~= 1 & proceed == 1

         clc
         disp('Engine inputs: [n pz]''');
         disp(' ');
         n      = input('engine speed [RPM]       : ');
         pz     = input('manifold pressure ["Hg]  : ');

         uprop0 = [n pz]';

         % Ask if engine-inputvector is correct. If not, re-enter. If
         % the length of the engine-inputvector is too short because
         % the user has pressed <ENTER> without giving a number for one or
         % more inputs, this inputvector must be re-entered by the user.
         % ---------------------------------------------------------------
         disp(' ');

         if length(uprop0) == 2       % uprop0 has right length
            clc
            disp('Current definition of inputvector to engine model:');
            uprop0

            answ = input('Is this correct (y/n)? ','s');
            if answ == 'y'
               ok1 = 1;
            else
               disp(' ');
               answ1 = input('Proceed with manual definition (y/n)? ','s');
               if answ1 == 'n'
                  proceed = 0;     % do not proceed with manual definition
               end

            end
            clear answ answ1

         else                      % length of uprop0 is NOT right
            clc
            disp('Inputvector is too short! You probably have pressed');
            disp('<ENTER> without entering a value for one or more inputs.');
            disp(' ');

            answ1 = input('Proceed with manual definition (y/n)? ','s');
            if answ1 == 'n'
               proceed = 0;     % do not proceed with manual definition
            else
               disp(' ');
               disp('Please re-enter state vector.');
            end
            clear answ1

            disp(' ');
            disp('<<< Press a key >>>');
            pause
         end
      end

      % Operating point is now defined by xinco, uaero0, and uprop0. Now
      % we'll clear variables which are not needed anymore.
      % ----------------------------------------------------------------
      clear V alpha beta p q r psi theta phi xe ye H deltae deltaa deltar
      clear deltaf n pz ok1

      % If user has not chosen to leave manual definition of operating point,
      % the variable proceed will still be equal to one. Then, it is right
      % to leave operating point definition, assuming that the current de-
      % finition is correct. Otherwise, go back to main menu (ok ~= 1!).
      % ---------------------------------------------------------------------
      if proceed == 1
         ok = 1;
      end

      clear proceed

   elseif opt == 3                     % USE OPERATING POINT FROM WORKSPACE
                                       % ----------------------------------
      clc
      if exist('xinco') == 0 | exist('uaero0') == 0 | exist('uprop0') == 0
         % Currently, no operating point has been defined in the Matlab
         % workspace. Display error message and return to main menu.
         % ------------------------------------------------------------
         clc
         disp('ACLIN expects the following variables to be present in the');
         disp('Matlab workspace:');
         disp(' ');
         disp('   xinco = state vector in operating point');
         disp('   uaero0= vector with aerodynamic control inputs');
         disp('   uprop0= vector with engine control inputs');
         disp(' ');
         disp('At least one of these vectors is currently not present, so');
         disp('linearization cannot proceed!');
         disp(' ');
         disp('<<<Press a key to return to main menu>>>');
         pause
      else
         % Ask if current definition of the operating point is correct.
         % If not, program will return to main menu.
         % ------------------------------------------------------------
         clc
         disp('Current definition of operating point (xinco = states,');
         disp('uaero0 = aerodynamic inputs, uprop0 = engine inputs):');
         xinco
         uaero0
         uprop0
         answ = input('Is this correct (y/n)? ','s');
         if answ ~= 'y'
            disp(' ');
            disp('<<<Press a key to return to main menu>>>');
            pause
         else
            ok = 1;  % If current definition is ok, proceed with
                     % linearization
         end
         clear answ
      end

   elseif opt == 4   % RUN ACTRIM TO DETERMINE STEADY-STATE TRIMMED-FLIGHT
                     % CONDITION. Type HELP ACTRIM for more details.
                     % ---------------------------------------------------

      % ACTRIM computes xinco, xdot0, uprop0, and uaero0. Before calling
      % ACTRIM, these variables are cleared to make sure that they will not
      % become mixed-up with the results of ACTRIM if they already exist.
      % To prevent other variables, used in ACLIN from intervening with
      % ACTRIM, all variables will be saved to a temporary file ACLIN.TMP.
      % The worspace will be cleared before starting ACTRIM. If ACTRIM has
      % finished, the old variables will be retrieved from ACLIN.TMP, and
      % the temporary file will be deleted.
      % ---------------------------------------------------------------------
      clear uaero0 uprop0 xinco xdot0 % delete operating point definition
                                %                from workspace (if present)
      save aclin.tmp            % save remaining variables to temporary file
      clear                     % ... and clear workspace

      actrim                    % run ACTRIM

      load aclin.tmp -mat       % retrieve variables from temporary file
      delete('aclin.tmp');

      % Operating point definition is valid only if ACTRIM actually has
      % computed something. If option 'Quit' was selected in ACTRIM, the
      % workspace does not contain a valid definition of the operating
      % point; ok = 1 (quit operating point definition loop) is therefore
      % defined only if xinco, uprop0, and uaero0 exist.
      % -----------------------------------------------------------------
      if exist('xinco') == 0 | exist('uaero0') == 0 | exist('uprop0') == 0
         disp(' ');
         disp('No operating point defined!');
         disp(' ');
         disp(' ');
         disp('<<< Press a key to return to main menu >>>');
         pause
      else
         ok = 1;
      end
   else                                                             % QUIT
                                                                    % ----
      ok   = 1;
      skip = 1;  % Return to end of program rightaway when quitting.

   end

end % of operating-point definition.
clear ok

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if skip ~= 1   % If not quitting from ACLIN, proceed with program.
               % Else, go to end of program rightaway!

   disp(' ');
   disp('<<< Press a key to proceed with model definition >>>');
   pause

   % Define parameters for aircraft model:
   % =====================================
   %
   % AM, EM, GM1, and GM2: matrices, containing parameters for the aircraft
   %                       model. See also the help text and source code for
   %                       MODBUILD.M (contained in the directory AIRCRAFT).
   %
   % The other variables will either be explained when they are used, or are
   % self-explaining (at least if you know something about aircraft stabi-
   % lity and control).
   %
   % Check if these variables already have been defined in the Matlab work-
   % space (by ACTRIM). If not, run LOADER to retrieve them from file.
   % -----------------------------------------------------------------------
   if exist('AM')==0 | exist('EM')==0 | exist('GM1')==0 | exist('GM2')==0
      loader
   end

   % The systems BEAVER and BEAVER1 use a gain block for arbitrarily setting
   % time-derivatives of the state variables to zero. This may be useful for
   % some purposes, for instance to eliminate longitudinal-lateral cross-
   % coupling, or to fix the airspeed to its initial value if an altitude
   % controller is to be evaluated, but no autothrottle is available yet.
   % The gain value is xfix, which is set to 1 if all states may vary, i.e.,
   % if the complete six degree-of-freedom model is used without restric-
   % tions. When states have to be fixed, the routine FIXSTATE.M can be
   % called (type HELP FIXSTATE for more info).
   %
   % Here, all state variables are allowed to vary, so xfix will be set to
   % one. Replace this line by:
   %
   %   fixstate;
   %
   % if you want to set some time-derivatives to zero, even when linearizing
   % the aircraft model.
   %-------------------------------------------------------------------------

   xfix = 1;
   %%%% fixstate;

   disp(' ');
   disp('<<< Press a key to proceed with linearization >>>');
   pause


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   % Proceed with linearization.
   % ===========================

   % Build initial inputvector to the system (contains both aerodynamic
   % and engine inputs). Note: wind velocities and accelerations (inclu-
   % ding atmospheric turbulence) have been set to zero!!!
   % -------------------------------------------------------------------
   uinco = [uaero0; uprop0; 0; 0; 0; 0; 0; 0];

   clc
   disp(['Now linearizing S-function ',sysname]);
   disp(' ');
   disp('Wait a moment, please...');
   home

   % Apply Simulink routine LINMOD to nonlinear aircraft model, contained
   % in the S-function sysname. Note: contrary to the routine ACTRIM, the
   % linearization tool LINMOD is a standard Simulink function. Hence, it
   % is not necessary to initialize the system at this place by calling
   % it once with [sys,x0] = sysname([],[],[],0)!
   % --------------------------------------------------------------------
   [Aac, Bac, Cac, Dac] = linmod(sysname,xinco,uinco);

   disp(' ');
   disp('Linearization succeeded.');
   disp(' ');
   disp('<<< Press a key to continue >>>');
   pause


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   % Select a subset of the states and inputs. Note: the remaining states
   % and inputs are omitted from the state equation by simply eliminating
   % the corresponding elements from the state matrices. The more elements
   % you neglect, the larger the resulting error will be.
   %
   % ACLIN doesn't provide the option to choose a subset of the output
   % equations, because the exact definition of the outputvector from the
   % Simulink system which contains the nonlinear aircraft model is not
   % known (in general). The full twelfth-order linear aircraft model
   % does include the output equations y = Cac*x + Dac*u, but the exact
   % definition of the matrices Cac and Dac, and the outputvector y can be
   % determined only by checking the corresponding nonlinear Simulink
   % model!
   % =====================================================================

   % While-loop in which the user must specify the element numbers of the
   % STATES that should be used for the linear model. These element num-
   % bers are stored in the vector xdef (state definition).
   %
   % The flag 'allstates' is set to one if user wants to maintain defini-
   % tion of state vector. If not, allstates = 0.
   % --------------------------------------------------------------------
   allstates = 0;
   ok = 0;
   while ok ~= 1
      clc
      disp('Select states');
      disp('-------------');
      disp(' ');
      disp('The current state vector is: ');
      disp(' ');
      disp('x = [ V  alpha  beta  p   q   r  psi  theta  phi  xe  ye  H ]''');
      disp(' ');
      disp('      1    2      3   4   5   6   7     8     9   10  11  12');
      disp(' ');
      disp(' ');

      disp('Enter vector with element numbers of states you want to use');
      disp('(enter = use all states):');
      xdef = input('> ');
      if isempty(xdef)                    % Use all states.
         xdef = [1 2 3 4 5 6 7 8 9 10 11 12];
         allstates = 1;                   % Set all states flag.
      end

      % Check if no illegal numbers have been specified.
      % ------------------------------------------------
      if min(xdef) < 1 | max(xdef) > 12   % state numbers outside allowable
                                          % region...
         disp(' ');
         disp('Use element numbers from {1,2,3,4,5,6,7,8,9,10,11,12}!');
         disp(' ');
         disp('<<< Press a key >>>');
         pause
         ok = 0;
      else
         ok = 1;
      end
   end

   % While-loop in which the user must specify the element numbers of the
   % INPUTS that should be used for the linear model. These element num-
   % bers are stored in the vector udef (input definition). Note: wind
   % and turbulence inputs (disturbances) are selected separately.
   %
   % The flag 'allinputs' is set to one if the user wants to maintain
   % the full inputvector, INCLUDING atmospheric disturbances. If not,
   % allinputs = 0.
   % --------------------------------------------------------------------
   allinputs = 0;
   ok = 0;
   while ok ~= 1
      clc
      disp('Select inputs');
      disp('-------------');
      disp(' ')
      disp('The current control-input vector is: ');
      disp(' ');
      disp('u = [ deltae deltaa deltar deltaf   n   pz ]''');
      disp(' ');
      disp('          1      2      3     4     5    6');
      disp(' ');
      disp(' ');

      disp('Enter vector with element numbers of control inputs that you want');
      disp('to use (enter = use all control inputs):');
      udef = input('> ');
      if isempty(udef)                    % use all control inputs.
         udef = [1 2 3 4 5 6];
         allinputs = 1;                   % set all inputs flag (will be
                                          % reset to 0 if influence of wind
                                          % & turbulence is neglected later).
      end

      % Check if no illegal numbers have been specified.
      % ------------------------------------------------
      if min(udef) < 1 | max(udef) > 6    % input numbers outside allowable
                                          % region...
         disp(' ');
         disp('Use element numbers from {1,2,3,4,5,6}!');
         disp(' ');
         disp('<<< Press a key >>>');
         pause
         ok = 0;
      else
         ok = 1;
      end
   end

   clear ok

   % Include wind and turbulence inputs (disturbances) to inputvector?
   % -----------------------------------------------------------------
   disp(' ');
   answ = input('Include wind & turbulence inputs (y/n)? ','s');
   if answ == 'y'
      udef = [udef 7 8 9 10 11 12];
   else
      allinputs = 0;  % Reset all inputs flag. Wind and turbulence are
                      % neglected, so user does NOT want to consider
                      % full inputvector!
   end
   clear answ

   % If user has selected all states AND all outputs, including the
   % atmospheric disturbances (wind & turbulence), there is no need
   % to determine new, simplified matrices for the linearized model,
   % because Aac_s == Aac and Bac_s == Bac in that case. If the user
   % has selected a subset of x and u, or if he has defined the vectors
   % xdef and udef such that the order of the states and/or inputs is
   % shuffled, simplified versions of Aac and Bac will be created.
   %
   % First check if user has specified full state and inputvector
   % (unshuffled) for linearized model. If not, define Aac_s and Bac_s.
   % ------------------------------------------------------------------
   if allstates ~= 1 | allinputs ~= 1

      % Determine new state matrix Aac_s, depending upon element numbers
      % selected above.
      % ----------------------------------------------------------------
      for ii = 1:length(xdef)             % ii = row number
         for jj = 1:length(xdef)          % jj = column number
            Aac_s(ii,jj) = Aac(xdef(ii),xdef(jj));
         end
      end

      % Determine new state matrix Bac_s, depending upon element numbers
      % selected above.
      % ----------------------------------------------------------------
      for ii = 1:length(xdef)             % ii = row number
         for jj = 1:length(udef)          % jj = column number
            Bac_s(ii,jj) = Bac(xdef(ii),udef(jj));
         end
      end

      clear ii jj

   end

   clc;
   disp('State-space matrices of complete 12th-order system:');
   disp('Aac, Bac, Cac, and Dac.');
   disp(' ');
   if allstates ~= 1 & allinputs ~= 1
      disp('State-space matrices of simplified model (state equation only):');
      disp('Aac_s and Bac_s');
      disp(' ');
   end
   disp('<<< Press a key >>>');
   pause

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Create a text matrix with information about the linearized model.
   % Note: the function NUM2STR2 is just a slightly changed version
   % of NUM2STR. Type HELP NUM2STR2 at the Matlab command line  for
   % more info.
   % =================================================================
   line1  = ['Linearized aircraft model of the system ' sysname ':'];
   line2  = '';
   line3  = ['User-specified operating point:'];
   line4  = '';
   line5  = ['Airspeed:          V      =  ' num2str2(xinco(1),10)  ' [m/s]'  ];
   line6  = ['Angle of attack:   alpha  =  ' num2str2(xinco(2),10)  ' [rad]'  ];
   line7  = ['Sideslip angle:    beta   =  ' num2str2(xinco(3),10)  ' [rad]'  ];
   line8  = ['Roll-rate:         p      =  ' num2str2(xinco(4),10)  ' [rad/s]'];
   line9  = ['Pitch-rate:        q      =  ' num2str2(xinco(5),10)  ' [rad/s]'];
   line10 = ['Yaw-rate:          r      =  ' num2str2(xinco(6),10)  ' [rad/s]'];
   line11 = ['Yaw-angle:         psi    =  ' num2str2(xinco(7),10)  ' [rad]  '];
   line12 = ['Pitch-angle:       theta  =  ' num2str2(xinco(8),10)  ' [rad]  '];
   line13 = ['Roll-angle:        phi    =  ' num2str2(xinco(9),10)  ' [rad]  '];
   line14 = ['X-coordinate:      xe     =  ' num2str2(xinco(10),10) ' [m]    '];
   line15 = ['Y-coordinate:      ye     =  ' num2str2(xinco(11),10) ' [m]    '];
   line16 = ['Altitude:          H      =  ' num2str2(xinco(12),10) ' [m]    '];
   line17 = '';
   line18 = ['Elevator angle:    deltae =  ' num2str2(uaero0(1),10) ' [rad]  '];
   line19 = ['Aileron angle:     deltaa =  ' num2str2(uaero0(2),10) ' [rad]  '];
   line20 = ['Rudder angle:      deltar =  ' num2str2(uaero0(3),10) ' [rad]  '];
   line21 = ['Flap angle:        deltaf =  ' num2str2(uaero0(4),10) ' [rad]  '];
   line22 = '';
   line23 = ['Engine speed:      n      =  ' num2str2(uprop0(1),10) ' [RPM]  '];
   line24 = ['Manifold pressure: pz     =  ' num2str2(uprop0(2),10) ' ["Hg]  '];
   line25 = '';
   line26 = ['Full state space model: Aac, Bac, Cac, Dac.'];
   line27 = '';

   % Add definition of Aac_s and Bac_s to text matrix.
   % -------------------------------------------------
   if allstates == 1 & allinputs == 1  % all states and all outputs selected,
                                       % so no model simplifications...
      line28 = ['No simplified model available.'];
      line29 = '';
      line30 = ['x     =  [V alpha beta p q r psi theta phi xe ye H]'''];
      line31 = ['u     =  [ua'' ut'' uwind'']'''];
      line32 = '';
      line33 = ['ua    =  [deltae deltaa deltar deltaf]'''];
      line34 = ['ut    =  [n pz]'','];
      line35 = ['uwind =  [uw vw ww uwdot vwdot wwdot]'''];
      line36 = '';

   else                            % simplified model has been determined

      line28 = ['Aac_s and Bac_s contain simplified model (state eqs. only!)'];
      line29 = '';

      line30 = ['State and input vectors of the simplified model:'];

      line31 = ['x_s=['];
      for ii = 1:length(xdef)
         line31 = [line31 'x(' num2str(xdef(ii)) ') '];
      end
      line31 = [line31(1:length(line31)-1) ']'];

      line32 = ['u_s=['];
      for jj = 1:length(udef)
         line32 = [line32 'u(' num2str(udef(jj)) ') '];
      end
      line32 = [line32(1:length(line32)-1) ']'];

      clear ii jj

      line33 = '';
      line34 = ['where: x = [V alpha beta p q r psi theta phi xe ye H]'''];
      line35 = ['       u = [deltae deltaa deltar deltaf n pz  ...'];
      line36 = ['                     ...  uw vw ww uwdot vwdot wwdot]'''];

   end

   line37 = '';

   % Add time and date to text matrix.
   % ---------------------------------
   t  = clock;
   t1 = num2str(t(4));
   t2 = num2str(t(5));
   t3 = num2str(t(6));

   line38 = ['date: ', date, '   time: ', t1, ':', t2, ':', t3];

   clear t t1 t2 t3


   % Now all explanatory lines will be enhanced to 80 characters,
   % in order to fit them into one string matrix.
   % ------------------------------------------------------------
   line1  = [line1  blanks(79-length(line1 ))];
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
   line25 = [line25 blanks(79-length(line25))];
   line26 = [line26 blanks(79-length(line26))];
   line27 = [line27 blanks(79-length(line27))];
   line28 = [line28 blanks(79-length(line28))];
   line29 = [line29 blanks(79-length(line29))];
   line30 = [line30 blanks(79-length(line30))];
   line31 = [line31 blanks(79-length(line31))];
   line32 = [line32 blanks(79-length(line32))];
   line33 = [line33 blanks(79-length(line33))];
   line34 = [line34 blanks(79-length(line34))];
   line35 = [line35 blanks(79-length(line35))];
   line36 = [line36 blanks(79-length(line36))];
   line37 = [line37 blanks(79-length(line37))];
   line38 = [line38 blanks(79-length(line38))];


   % The explanatory lines are collected in the matrix lindef.
   % ---------------------------------------------------------
   lindef = [line1;  line2;  line3;  line4;  line5;  line6;  line7;  line8;
             line9;  line10; line11; line12; line13; line14; line15; line16;
             line17; line18; line19; line20; line21; line22; line23; line24;
             line25; line26; line27; line28; line29; line30; line31; line32;
             line33; line34; line35; line36; line37; line38];

   clear line1  line1a line2  line3  line4  line5  line6  line7  line8  line9
   clear line10 line11 line12 line13 line14 line15 line16 line17 line18 line19
   clear line20 line21 line22 line23 line24 line25 line26 line27 line28 line29
   clear line30 line31 line32 line33 line34 line35 line36 line37 line38


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   % Results can now be saved to a file, which will be filled with the
   % state space matrices Aac, Bac, Cac, Dac of the linearized aircraft
   % model, and the information matrix lindef. Moreover, the user will
   % be asked if the operating point, defined by xinco, uaero0, and uprop0
   % must be saved to the same file too. In that case, the information
   % matrix trimdef will be saved too if it exists (see ACTRIM for more
   % info).
   %
   % Note: files with linearized aircraft model have extension .LIN!
   % ==================================================================
   clc
   answ = input('Save linear state-space model to file (y/n)? ','s');
   if answ == 'y'

      % Go to default directory if that directory exists (if not, start
      % save-routine from the current directory).
      % ---------------------------------------------------------------
      eval(['chdir ',defdir,';'],['chdir ',currentdir,';']);

      % Obtain filename and path.
      % -------------------------
      [filename,dirname] = uiputfile('*.lin','Save linearized model');

      % Build string variable which specifies what to save in which file.
      % -----------------------------------------------------------------
      savecmmnd=['save ',dirname,filename,' Aac Bac Cac Dac lindef'];
      if allstates ~= 1 | allinputs ~= 1         % simplified matrices exist?
         savecmmnd = [savecmmnd ' Aac_s Bac_s']; %    ... then save them too!
      end

      % Ask if operating point needs to be included to the .LIN file. If it
      % does, add xinco, uaero0, uprop0 and (if present) trimdef to the list
      % of variables to be saved. The text matrix trimdef should be pre-
      % sent in the workspace if the operating point has been determined
      % directly by calling ACTRIM or by loading it from a .TRI-file.
      % -----------------------------------------------------------------
      disp(' ');
      answ = input('Include operating point {xinco,uaero0,uprop0} to file (y/n)? ','s');
      if answ == 'y'
         savecmmnd = [savecmmnd ' xinco uaero0 uprop0'];
         % If operating point has been loaded from .TRI file or computed by
         % directly calling ACTRIM, the definition of the trimmed flight-
         % condition is stored in the text-matrix trimdef. If the operating
         % point is defined in another way, this matrix does not exist. If
         % trimdef exists, it will be saved along with the trimmed flight-
         % condition itself.
         % -----------------------------------------------------------------
         if exist('trimdef') == 1
            savecmmnd = [savecmmnd ' trimdef'];
         end
      end
      clear answ

      % Save linearized model to file (evaluate savecmmnd).
      % ---------------------------------------------------
      clc
      disp('Saving linear state-space model to the file:');
      disp(' ');
      disp(['     ',dirname,filename]);
      disp(' ');

      eval(savecmmnd)

      disp('<<< Press a key >>>');
      pause
   end
   clear answ dirname filename savecmmnd defdir currentdir

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Display results for user.
   % =========================
   clc
   disp('State-space matrices of linearized aircraft model: Aac, Bac, Cac,');
   disp('and Dac (ac = aircraft). Operating point is defined by the vectors');
   disp('xinco, uaero0, and uprop0.');
   disp(' ');
   pause(1.5)
   disp('Examine the nonlinear aircraft model in Simulink for the current');
   disp('definition of the outputvector. The S-function BEAVER uses:');
   disp(' ');
   disp(' y = [x'' dH/dt pb/2V qc/V rb/2V]''');
   disp(' ');
   disp('which contains all relevant information for the autopilot simu-');
   disp('lation model APILOT.');
   disp(' ');

   if allstates ~= 1 | allinputs ~= 1
      disp('Simplified state model available in matrices Aac_s and Bac_s');
      disp('(state equations only!).');
      disp(' ');
   end

   disp('See matrix lindef for more details!');

end % of the part of the program in which the actual linearization takes
    % place, and which contains the save routines (skipped if the option
    % QUIT is selected from the main menu).

disp(' ');
disp('Ready.');
disp(' ');

% Clear variables which are not needed anymore
% --------------------------------------------
clear opt skip sysname uinco udef xdef allstates allinputs ii jj


%---------------------------------------------------------------------------------
% The FDC toolbox. Copyright Marc Rauw, 1994-2000.
% Last revision of this program: October 10, 1997.
%
% History of this file, starting September 8, 1997:
% =================================================
% September 8, 1997
%  - Replaced cd commands with chdir to enhance compatibility
% October 10, 1997
%  - Replaced DOS delete command with general Matlab version
