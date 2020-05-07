%--------------------------------------------------------------
% APINIT.m can be used to initialize the autopilot systems
% APILOT1, APILOT2, APILOT3, and the nonlinear aircraft model
% BEAVER. This routine needs to be runned before starting a
% new simulation, AND before editing the system (the latter is
% not really necessary, although SIMULINK will sometimes beep
% due to missing parameters if the system is edited without
% having initialized the system).
%--------------------------------------------------------------

s = 0;
while s ~= 6                                      % While not choosing QUIT...

   s = menu('INITIALIZE AUTOPILOT:',...
            '1. Load aircraft model parameters',...
            '2. Load state-space actuator/cable models',...
            '3. Define initial flight condition',...
            '4. Initialize VOR and/or ILS systems',...
            '5. (Fix states)',...
            '6. Close');

   if s == 1                            % LOAD AIRCRAFT MODEL PARAMETERS
      loader

   elseif s == 2                        % LOAD STATE-SPACE MODEL OF ACTUATOR
                                        % PLUS CABLE DYNAMICS.
      actrload

   elseif s == 3                        % DEFINE INITIAL FLIGHT CONDITION
      answ = menu('Define initial flight condition. Options:',...
                  'Run aircraft trim program',...
                  'Load initial condition from file',...
                  'Back to main menu');
      if answ == 1
         actrim;
      elseif answ == 2
         incoload;
      else
         warndlg('No new initial condition defined!','Warning');
         pause(1);
      end
      clear answ

   elseif s == 4                        % INITIALIZE VOR AND/OR ILS MODELS
      answ = 0;
      while answ ~= 3                  % While not going back to the main menu
         answ = menu('Options:','Initialize VOR','Initialize ILS',...
                     'Back to main menu');
         if answ == 1
            vorinit;
         elseif answ == 2
            ilsinit;
         else                          % Set default values if VOR and ILS
                                       % haven't been initialized before
            e1 = exist('xVOR');
            e2 = exist('yVOR');
            e3 = exist('CD');
            if e1~=1 | e2~=1 | e3~=1
               disp('VOR system has not been initialized yet!');
               answ1 = input('Use default values for VOR (y/n)? ','s');
               if answ1 == 'y'
                  HVOR = 0;
                  xVOR = 0;
                  yVOR = 0;
                  CD   = 0;
                  disp(' ');
                  disp('Default values for VOR set');
                  disp(' ');
               end
            end
            e1 = exist('HRW');
            e2 = exist('xRW');
            e3 = exist('yRW');
            e4 = exist('gamgs');
            e5 = exist('psiRW');
            e6 = exist('xloc');
            e7 = exist('xgs');
            e8 = exist('ygs');
            e9 = exist('Sgs');
            e10 = exist('Sloc');
            if e1~=1 | e2~=1 | e3~=1 | e4~=1 | e5~=1 | e6~=1 | e7~=1 | e8~=1 | e9~=1 | e10~=1
               disp('ILS system has not been initialized yet!');
               answ1 = input('Use default values for ILS (y/n)? ','s');
               if answ1 == 'y'
                  HRW   = 0;
                  xRW   = 0;
                  yRW   = 0;
                  gamgs = -3*pi/180;
                  psiRW = 0;
                  xloc  = 2000;
                  xgs   = 300;
                  ygs   = -100;
                  Sgs   = 625/abs(gamgs);
                  Sloc  = 1.4*xloc;
                  disp(' ');
                  disp('Default values for ILS set');
                  disp(' ');
               end
            end
            clear e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 answ1
         end
      end
      clear answ
   elseif s == 5                        % FIX STATES
      fixstate;
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
% October 6, 1997
%   - Editorial changes
