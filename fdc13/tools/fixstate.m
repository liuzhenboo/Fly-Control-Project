% ---------------------------------------------------------------
% The FDC toolbox, routine FIXSTATE
% =================================
% FIXSTATE is a Matlab program, which can be used to artificially
% fix state variables from the non-linear aircraft model (in this
% case the Simulink system BEAVER).
%
% FIXSTATE sets the value of the gain vector xfix, with which the
% time-derivative of the state vector (xdot = dx/dt) is multi-
% plied. The corresponding gain block can be found in the subsys-
% tem 'Aircraft equations of motion' of the S-function BEAVER
% (see also: XFIX.HLP in the HELP directory).
%
% The gain xfix functions as follows: the time-derivative of the
% state-vector, used by the Simulink integrator, is equal to:
%
%     xdot_used = xdot_true .* xfix
%
% xfix consists of ones and zeros only. If xfix = ones(1,12) or
% xfix = 1, xdot_used = xdot_true, so none of the states will be
% fixed. If one or more elements of xfix is (are) equal to zero,
% the time-derivatives of the corresponding states will remain
% zero, hence, these states will remain equal to their initial
% condition.
%
% For instance: if the true airspeed (that is: the first element
% of the state vector x) must be kept constant, xfix has to equal
% [0 1 1 1 1 1 1 1 1 1 1 1]. FIXSTATE can also be used if longi-
% tudinal or lateral dynamics only are examined.
%
% Note: the variable xfix needs to be defined in the workspace
% if the system BEAVER (or a similarly structured aircraft model)
% are evaluated for simulation, trimming, and linearization pur-
% poses. Either set xfix = 1 manually, or use LOADER to define
% the model parameters.
%
% Definition of the state-vector:
% ===============================
%   x     = [V alpha beta p q r psi theta phi xe ye H]'
%
%   V     = true airspeed [m/s]
%   alpha = angle of attack [rad]
%   beta  = sideslip angle [rad]
%   p     = roll-rate [rad/s]
%   q     = pitch-rate [rad/s]
%   r     = yaw-rate [rad/s]
%   psi   = yaw angle [rad]
%   theta = pitch angle [rad]
%   phi   = roll angle [rad]
%   xe    = X-coordinate of aircraft's c.g. [m]
%   ye    = Y-coordinate of aircraft's c.g. [m]
%   H     = altitude of aircraft's c.g. [m] (above sea level)
%
% See XFIX.HLP for more info. Also examine the subsystem
% 'Aircraft equations of motion' of the Simulink model of the
% aircraft (BEAVER).
% -------------------------------------------------------------

clc
disp('FDC 1.3 - FIXSTATE');
disp('==================');
disp('');
disp('Utility to fix one or more states to their initial condition');
disp('(neglect a part of the aircraft dynamics).');
disp('');

% Main menu
% ---------
opt=menu('Options:','Fix asymmetrical states','Fix symmetrical states',...
         'Fix arbitrary states','Don''t fix any states');

if opt == 1                                       % FIX ASYMMETRICAL STATES
                                                  % -----------------------
   disp('');

   % Multiply time-derivatives of V, alpha, q, theta, xe, and H with 1,
   % and the time-derivatives of beta, p, r, psi, phi, and ye with 0
   % (i.e. fix the asymmetrical states).
   % ------------------------------------------------------------------
   xfix = [1 1 0 0 1 0 0 1 0 1 0 1];

   % Maybe user doesn't want to fix ye. This while-loop gives the option
   % to leave ye unfixed.
   % -------------------------------------------------------------------
   ok = 0;
   while ok ~= 1
      answ = input('Fix ye (y/n)? ','s');
      if answ == 'y'
         xfix(11) = 0;
         ok = 1;
      elseif answ == 'n'
         xfix(11) = 1;
         ok = 1;
      else
         disp('Enter y or n.');
      end
   end
   clear ok answ

elseif opt == 2                                    % FIX SYMMETRICAL STATES
                                                   % ----------------------
   disp('');

   % Multiply time-derivatives of V, alpha, q, theta, xe, and H with 0,
   % and the time-derivatives of beta, p, r, psi, phi, and ye with 1
   % (i.e. fix the symmetrical states).
   % ------------------------------------------------------------------
   xfix = [0 0 1 1 0 1 1 0 1 0 1 0];

   % Maybe user doesn't want to fix xe and/or H. These while-loops give
   % the option to leave xe and/or H unfixed.
   % ------------------------------------------------------------------

   ok = 0;
   while ok~= 1
      answ = input('Fix xe (y/n)?','s');
      if answ == 'y'
          xfix(10) = 0;
          ok = 1;
      elseif answ == 'n'
          xfix(10) = 1;
          ok = 1;
      else
          disp('Enter y or n.');
      end
   end

   ok = 0;
   while ok~= 1
      answ = input('Fix H (y/n)? ','s');
      if answ == 'y'
          xfix(12) = 0;
          ok = 1;
      elseif answ == 'n'
          xfix(12) = 1;
          ok = 1;
      else
          disp('Enter y or n.');
      end
   end
   clear ok answ

elseif opt == 3                                      % FIX ARBITRARY STATES
                                                     % --------------------
   % While-loop to correctly enter the numbers of the states that should
   % be fixed.
   % -------------------------------------------------------------------
   ok = 0;
   while ok ~= 1

      % Give user-information.
      % ----------------------
      clc
      disp('Fix arbitrary states.');
      disp('=====================');
      disp('');
      disp('The state vector equals:');
      disp('   [V alpha beta p q r psi theta phi xe ye H]');
      disp('');
      disp('');

      % Specify the element numbers of state vector which ought to be fixed.
      % --------------------------------------------------------------------
      disp('Specify a vector containing the element numbers of the');
      disp('states that should be fixed ( [] = don''t fix any states ): ');
      fix = input('> ');

      % Check if no illegal numbers have been specified.
      % ------------------------------------------------
      if min(fix) < 1 | max(fix) > 12    % state numbers outside allowable
                                         % region...
         disp('');
         disp('Use element numbers from {1,2,3,4,5,6,7,8,9,10,11,12}!');
         disp('');
         disp('<<< Press key >>>');
         pause
         ok = 0;
      else
         ok = 1;
      end
   end

   % Now determine xfix, depending upon element numbers selected above.
   % ------------------------------------------------------------------
   xfix = [1 1 1 1 1 1 1 1 1 1 1 1];  % default value: all states may vary

   for i = 1:length(fix)              % change defaults if necessary
      xfix(fix(i)) = 0;
   end
   clear fix i

else                                                 % DON'T FIX ANY STATES
                                                     % --------------------
   xfix = 1;
end

% Re-initialize system (these program lines are needed to make sure that
% changes in xfix are actually effectuated in the system). First, the
% name of the aircraft model will be asked (and stored in sysname). The
% aircraft model MUST use the same definition of the state vector as
% BEAVER in order to function properly.

% First load model parameters (if they don't already exist).
% ---------------------------------------------------------------------
if exist('AM')==0 | exist('EM')==0 | exist('GM1')==0 | exist('GM2')==0
   loader
end

clc
disp('Give name of system with aircraft model (8 characters max.)');
disp('default = beaver');
sysname = input('> ','s');
if isempty(sysname)
   sysname = 'beaver';
end

% Build command string for initializing the aircraft model.
% ---------------------------------------------------------
initcmmnd = ['[sys,x0] = ' sysname '([],[],[],0);'];

disp('');
disp('Re-initializing system...');

% Re-initializing is possible only if initial value of state vector, xinco
% is present in Matlab workspace! The initial condition of the integrator-
% block in the subsystem 'Aircraft Equations of Motion' of the systems
% BEAVER and BEAVER1 is equalled to xinco.
% ------------------------------------------------------------------------
if exist('xinco') == 1
   eval(initcmmnd);
   clear sys x0     % Results are not needed, we only want Simulink
                    % to create a new internal representation of the
                    % aircraft model. Hence this clear command!
   disp('');
   disp('<<< Press Key >>>');
   pause
else
   disp('');
   disp('System has not been re-initialized because xinco hasn''t been');
   disp('defined yet! Define xinco, and either open the system BEAVER,');
   disp('or type: ');
   disp('');
   disp('   sysname([],[],[],0);');
   disp('');
   disp('at the Matlab workspace, where sysname = name of aircraft model.');
   disp('');
   disp('Alternatively, start trim algorithm or linearization program,');
   disp('define xinco and start simulation, or load xinco from .TRI-file');
   disp('and start simulation.');
   disp('');
   disp('<<< Press Key >>>');
   pause
end

clear sysname initcmmnd

% Show which states have been fixed.
% ----------------------------------
clc
disp('Ready.');
disp('');
if length(xfix) == 12  % i.e. xfix ~= 1, so it is likely that some states
                       % have been fixed indeed...

   % Check for all twelve states if they have been fixed or not
   % ----------------------------------------------------------
   if xfix(1)  == 0, disp('V has been fixed'); end
   if xfix(2)  == 0, disp('alpha has been fixed'); end
   if xfix(3)  == 0, disp('beta has been fixed'); end
   if xfix(4)  == 0, disp('p has been fixed'); end
   if xfix(5)  == 0, disp('q has been fixed'); end
   if xfix(6)  == 0, disp('r has been fixed'); end
   if xfix(7)  == 0, disp('psi has been fixed'); end
   if xfix(8)  == 0, disp('theta has been fixed'); end
   if xfix(9)  == 0, disp('phi has been fixed'); end
   if xfix(10) == 0, disp('xe has been fixed'); end
   if xfix(11) == 0, disp('ye has been fixed'); end
   if xfix(12) == 0, disp('ze has been fixed'); end
end
disp('');


%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 7, 1997:
% =======================================
% October 7, 1997
%  - Editorial changes
