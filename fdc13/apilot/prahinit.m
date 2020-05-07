%-----------------------------------------------------------
% PRAHINIT.M initializes the simulation models PAH.M, RAH.M,
%  and PAHRAH.M.
%
%  Note: if you want to initialize the autopilot models
%  APILOT1 to APILOT3 you should run APINIT in stead of
%  PRAHINIT!
%-----------------------------------------------------------

% Initialize refvelocity (reference velocity for actuator model and PAH/RAH gains)
% --------------------------------------------------------------------------------
refvelocity = 45; % default: mean velocity in 'Beaver' flight envelope [m/s]

s = 0;
while s ~= 6                                      % While not choosing QUIT...

   s = menu('INITIALIZE PAH/RAH MODELS:',...
            '1. Load aircraft model parameters',...
            '2. Load state-space actuator/cable models',...
            '3. Define initial flight condition',...
            '4. Define PAH and RAH gain values',...
            '5. (Fix states)',...
            '6. Close');

   if ~isempty(s)
      if s == 1                            % LOAD AIRCRAFT MODEL PARAMETERS
         loader

      elseif s == 2                        % LOAD STATE-SPACE MODEL OF ACTUATOR
                                           % PLUS CABLE DYNAMICS AND OBTAIN
                                           % REFERENCE VELOCITY (35, 45, OR 55 M/S)
         actrload;

      elseif s == 3                        % DEFINE INITIAL FLIGHT CONDITION
         answ = 0;
         answ = menu('Define initial flight condition. Options:',...
                     'Run aircraft trim program',...
                     'Load initial condition from file',...
                     'Back to main menu');
         if answ == 1
            actrim;
         elseif answ == 2
            incoload;
         else
            h=warndlg('No new initial condition defined!','Warning');
            uiwait(h);
         end
         clear answ

      elseif s == 4                        % DEFINE GAINS FOR PAH AND RAH
         [Ktheta,Kq,Ki_1,Kphi,Kr,dar,drr,Ki_2] = kpahrah(refvelocity);
         h=msgbox(['Gains defined for reference velocity ',num2str(refvelocity),' m/s']);
         uiwait(h);

      elseif s == 5                        % FIX STATES
         fixstate

      end
   end
end
clear s


%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 5, 1997:
% =======================================
% October 5, 1997
%   - Removed unnecessary disp commands for command-window in cases where the
%     latest versions of Matlab use graphical menu's
%   - Used warndlg in stead of command-line for warning message
%   - Call KPAHRAH as function with reference velocity as input and extract
%     reference velocity itself from new version of ACTRLOAD
% October 6, 1997
%   - Restored script-status of ACTRLOAD (removed function call)
%   - Improved handling of message and warning boxes
% October 8, 1997
%   - Editorial change
%   - Added ISEMPTY check to prevent Simulink 2 warnings
