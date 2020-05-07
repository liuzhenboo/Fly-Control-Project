%-----------------------------------------------------------------
% TRIMDEMO
% ========
% Demonstrates the trimming facility by determining trimmed-flight
% elevator deflections as a function of the true airspeed V for
% the DHC-2 'Beaver' aircraft (horizontal, wings-level flight).
%
% The trim code from this program has largely been copied from
% ACTRIM.M. See the source code of that program for more info
% about the optimization process. Note: in future versions of the
% FDC toolbox, it is planned to put the actual trim-computations
% completely into separate Matlab FUNCTIONS in order to enhance
% the flexibility of ACTRIM. That will make it easier to create
% applications such as this trim-demo program.
%-----------------------------------------------------------------

clc
disp('TRIMDEMO');
disp('========');
disp(' ');
disp('Demonstration of the trimming facility. Determining trimmed-');
disp('flight elevator deflections for ten different airspeeds V by');
disp('calling the S-function BEAVER. This will take some time to');
disp('compute!');
disp(' ');

% Load aircraft parameters for the 'Beaver' model.
% ------------------------------------------------
load aircraft.dat -mat

xinco=[45,zeros(0,11)]';
xfix=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER INPUTS: (PARTLY) DEFINE FLIGHT CONDITION %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Steady horizontal wings-level flight-condition (user-input for
% altitude, flaps and engine speed only).
% --------------------------------------------------------------
H = input('Altitude [ft], default = 6000: ');
if isempty(H)
   H = 6000;
end
H = H*0.3048; % feet to metres

deltaf = input('Flap angle [deg], default = 0: ')*pi/180;
if isempty(deltaf)
   deltaf = 0;
end

n = input('Engine speed [RPM], default = 2000: ');
if isempty(n)
   n = 2000;
end

psi      = 0;                        % heading [rad]
phi      = 0;                        % roll angle [rad]
gamma    = 0;                        % flightpath angle [rad]
phidot   = 0;                        % roll rate [rad/s]
psidot   = 0;                        % yaw rate [rad/s]
thetadot = 0;                        % pitch rate [rad/s]
G        = 0;                        % centripetal acceleration [m/s^2]

pz       = 20; % Initial guess of manifold pressure ["Hg]

deltae   = []; % Will be filled with deltae-value for 10 velocities.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACTUAL TRIM PROCESS                                       %
%                                                           %
% MOST OF THE FOLLOWING CODE HAS BEEN COPIED FROM ACTRIM.M! %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Options for numerical optimization routine FMINS
% ------------------------------------------------
options     = foptions([]);  % Use default options for FMINS...
options(2)  = 1e-09;         % ... except for the error tolerance, which
options(3)  = 1e-09;         %     is set to a smaller value, and
options(14) = 2*options(14); %     max nr of iterations, which is doubled.

% The Simulink system BEAVER or an equivalent aircraft model is called by
% the function call xdot = feval('beaver',t,x,u,'outputs'), followed by
% xdot = feval('beaver',t,x,u,'derivs') to obtain the time-derivatives of
% the state vector x. Here t = 0 (system is time-independent). The
% function call is created here, and stored in the variable modfun.
% Note: the aircraft model itself will be compiled before applying these
% function calls!
% -----------------------------------------------------------------------
modfun   = ['xdot = feval(''beaver'',0,x,u,''outputs'');'];
modfun   = [modfun 'xdot = feval(''beaver'',0,x,u,''derivs'');'];

% Pre-compile the aircraft model.
% -------------------------------
feval('beaver',[],[],[],'compile');

% Take 10 different velocities within the 'Beaver' flight-envelope
% ================================================================
for V = 30:3:60,                                  % TAS-range [m/s]

  % Initial guess of state vector
  % -----------------------------
  xinco = [V 0 0 0 0 0 0 0 0 0 0 0]';

  % constant variables
  % ------------------
  ctrim = [V H psi gamma G psidot thetadot phidot deltaf n phi]';

  % vtrim = [alpha beta deltae deltaa deltar pz]', will be adjusted
  % by trim algorithm
  % ---------------------------------------------------------------
  vtrim = [0 0 0 0 0 pz]';

  iterate = 1;
  while iterate
     clc
     disp(['Searching stable solution at V = ' num2str(V) ' m/s']);
     pause(1);
     disp(' ');

     % Call minimization routine FMINS.
     % vtrimmed = [alpha beta deltae deltaa deltar pz]' (trimmed-flight).
     % ----------------------------------------------------------------------
     [vtrimmed,options] = fmins('accost',vtrim,options,[],...
                                          ctrim,'s','c','f',modfun);

     % options(10) = current number of evaluations of the S-function
     % options(14) = max. number of iterations
     % ------------------------------------------------------------------
     if options(10) == options(14)  % max. number of iteration is reached,
                                    % without reaching minimum
        disp(' ');
        disp('Warning: solution hasn''t converged!');

        answ = input('Perform more iterations ([y]/n)? ','s');
        if isempty(answ) | answ == 'y'
           iterate  = 1;                         % Keep on iterating
           % The first estimation for the 'new' minimization process is
           % now equalled to the result from the 'old' minimization pro-
           % cess, to get a better initial estimation.
           % -------------------------------------------------------------
           vtrim = vtrimmed;
        else
           iterate  = 0;  % Make sure iteration will be stopped
        end
        clear answ

     else  % optimization stopped before reaching max. number of iterations
        iterate = 0;
     end
   end  % of iteration-loop.
   clear iterate

   disp(' ');

   % Call subroutine ACCONSTR, which contains the flight-path constraints
   % once more to obtain the final values of the inputvector and states.
   % --------------------------------------------------------------------
   [x,u] = acconstr(vtrimmed,ctrim,'s','c','f');

   deltae = [deltae u(1)];
end


% Release compiled aircraft model now that all results are known
% --------------------------------------------------------------
feval('beaver',[],[],[],'term');


% Get rid of variables from optimization process which are not needed
% anymore.
% -------------------------------------------------------------------
clear ctrim vtrim vtrimmed options modfun


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE TRIMMED-FLIGHT ELEVATOR DEFLECTION CURVE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot results
% ------------
V = [30:3:60];
plot(V,-deltae*180/pi);
title('Elevator deflection vs. true airspeed');
xlabel('V [m/s]');
ylabel('-delta_e [deg]');
text(36, 0  , ['Flap angle: ' num2str(deltaf*180/pi) ' deg']);
text(36, 0.5, ['Engine speed: ' num2str(n) ' RPM']);
text(36, 1.0, ['Altitude: ' num2str(H) ' m']);


%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since February 7, 1998:
% ========================================
% February 7, 1998
%   - revised program to obtain Matlab 5 compatibility
%   - added line to load aircraft parameters automatically
%   - changed default value of altitude to 6000 feet
%   - doubled max. number of iterations
% June 12, 2000
%   - exchanged 'options' and '[ ]' input arguments in FMINS call (bugfix)
%   - included definition of xinco and xfix on top of the file to prevent errors
