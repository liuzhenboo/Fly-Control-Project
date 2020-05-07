%--------------------------------------------------------------
% APMODE is used to specify the autopilot modes that need
% to be evaluated. The block "Mode Controller" within the auto-
% pilot simulation model uses data from APMODE to define the
% initial autopilot mode, and to find out which switch criteria
% need to be monitored. The block "Reference Signals" uses data
% from APMODE to specify the reference values of theta, phi,
% H, Hdot, or psi. Only step-inputs at t=0 are possible at this
% time, but it is relatively easy to insert other reference
% signals in this block. It is also possible to insert a "From
% Workspace"-block in the subsystem "Reference Signals", in
% order to insert actually measured reference values.
%
% Running APMODE will create the vectors ymod1S, ymod2S,
% ymod1A, ymod2A, yrefS, and yrefA in your workspace. S = sym-
% metrical autopilot mode, A = asymm. mode. The vectors ymod
% contain mode-switches, the vectors yref contain reference
% values. 1 is the initial mode, 2 is used for a possible
% second mode for control laws which have an Armed-phase. Exa-
% mine the blocks "Mode Controller" and "Reference Signals"
% and the listing of APMODE.m for more details.
%--------------------------------------------------------------


%=============================================================================
% Mode-switch signals:
%
% ymodS = [Symm. mode on/off; Symm. outer-loop on/off; ALH on/off;
%          ALS on/off; GS on/off]
% ymodA = [Asymm. mode on/off; Asymm. outer-loop on/off; HH on/off;
%          NAV on/off; LOC on/off]
%
% In order to allow mode-switching, these signals have been divided in two
% parts, one for the initial phase, and one for the second phase. In practice,
% mode switching only takes place in the radio-navigation modes, being the
% glideslope, localizer, and navigation modes. All other modes thus remain
% in their 'initial' phase (the 'second' phase is not defined for those
% modes).
%
% ymod1S contains the setting for the initial phase of the symmetrical modes
% (PAH, ALH, ALS, and GS ARMED); ymod2S contains the setting for the second
% phase of the symmetrical modes (GS COUPLED, not defined for other symme-
% trical modes).
%
% ymod1A contains the setting for the initial phase of the asymmetrical modes
% (RAH, HH, NAV ARMED, and LOC ARMED); ymod2A contains the setting for the
% second phase of the asymmetrical modes (NAV COUPLED and LOC COUPLED, not
% defined for other asymmetrical modes).
%=============================================================================
% Reference signals:
%
% yrefS = [Dtheta_ref; DH_ref; DHdot_ref] contains reference values for
%            PAH, ALH, and ALS modes, respectively. Only constant reference
%            values are used here (corresponding to step at t=0 if the
%            values are not equal to zero), so change the block "Reference
%            Signals" in the system APILOT1, APILOT2, or APILOT3 if you
%            want other inputs.
%
% yrefA = [Dphi_ref; Dpsi_ref] contains reference values for RAH and HH modes.
%=============================================================================

global ymod1S ymod2S ymod1A ymod2A

amode = 0;
smode = 0;

% SYMMETRICAL AUTOPILOT MODE AND REFERENCE SIGNALS.
% -------------------------------------------------

% First initialize the vectors ymod1S, ymod2S, and yrefS:
ymod1S = [0 0 0 0 0]';  % Symmetrical mode-switch vector for initial mode
ymod2S = [0 0 0 0 0]';  % Symmetrical mode-switch vector for second mode after
                        %   mode-switching (used for Glideslope Coupled only)
yrefS  = [0 0 0]';      % Symmetrical reference values

smode  = menu('Specify symmetrical autopilot mode','Pitch Attitude Hold',...
         'Altitude Hold','Altitude Select','Glideslope',...
         'No symmetrical autopilot mode');

if smode == 1                          % Pitch Attitude Hold
   dialogtext1 = 'Pitch Attitude Hold';
   ymod1S = [1 0 0 0 0]'; % PAH
   PAHopt = menu('What reference signal do you want?','Step input Dtheta_ref',...
                 'Dtheta_ref = 0');
   if PAHopt == 1
      Dthetar = input('Give desired theta-step [deg]: ');
      if isempty(Dthetar)
         Dthetar = 0;
      end
      Dthetar = Dthetar*pi/180;
   else
      Dthetar = 0;
   end
   yrefS= [Dthetar 0 0]'; % reference pitch angle: theta_ref = theta0+Dthetar
   clear Dthetar PAHopt

elseif smode == 2                      % Altitude Hold
   dialogtext1 = 'Altitude Hold';
   ymod1S = [1 1 1 0 0]'; % ALH
   ALHopt = menu('What reference signal do you want?','Step input DH_ref',...
                 'DH_ref = 0');
   if ALHopt == 1
      DHr = input('Give desired altitude-step [m]: ');
      if isempty(DHr)
         DHr = 0;
      end
   else
      DHr = 0;
   end
   yrefS = [0 DHr 0]'; % reference altitude: H_ref = H0 + DHr
   clear DHr ALHopt

elseif smode == 3                      % Altitude Select
   dialogtext1 = 'Altitude Select';
   ymod1S = [1 1 0 1 0]'; % ALS
   ALSopt = menu('What reference signal do you want?',...
                 'Step input DHdot_ref','DHdot_ref = 0');
   if ALSopt == 1
      DHdotr = input('Give desired Hdot-step [m/s]: ');
      if isempty(DHdotr)
         DHdotr = 0;
      end
   else
      DHdotr = 0;
   end
   yrefS = [0 0 DHdotr]'; % reference rate-of-climb: Hdot_ref = Hdot0 + DHdotr
   clear DHdotr ALSopt

elseif smode == 4                      % Glideslope Capture & Hold
   dialogtext1 = 'Glideslope';
   ymod1S = [1 1 1 0 0]'; % GS-armed (control logic equal to ALH mode)
   ymod2S = [1 1 0 0 1]'; % GS-coupled
   % Note: DHr = 0 (Armed phase), glideslope-coupled reference signal
   % comes from ILS block.
else
   % Keep ymod1S = [0 0 0 0 0]', and ymod2S = [0 0 0 0 0]'.
   dialogtext1 = 'No symmetrical';
end


% ASYMMETRICAL AUTOPILOT MODE AND REFERENCE SIGNALS.
% --------------------------------------------------

% First initialize the vectors ymod1A, ymod2A, and yrefA:
ymod1A = [0 0 0 0 0]';  % Asymmetrical mode-switch vector for initial mode
ymod2A = [0 0 0 0 0]';  % Asymmetrical mode-switch vector for second mode
                        %   after mode-switching (used for LOC-coupled and
                        %   NAV-coupled only)
yrefA  = [0 0]';        % Asymmetrical reference values

amode = menu('Specify asymmetrical autopilot mode','Roll Attitude Hold',...
             'Heading Hold/Heading Select','VOR navigation mode',...
             'Localizer','No asymmetrical autopilot mode');

if amode == 1                          % Roll Attitude Hold
   dialogtext2 = 'Roll Attitude Hold';
   ymod1A = [1 0 0 0 0]'; % RAH
   RAHopt = menu('What reference signal do you want?','Step input Dphi_ref',...
         'Dphi_ref = 0');
   if RAHopt == 1
      Dphir = input('Give desired phi-step [deg]: ');
      if isempty(Dphir)
         Dphir = 0;
      end
      Dphir = Dphir*pi/180;
   else
      Dphir = 0;
   end
   yrefA = [Dphir 0]'; % Reference roll-angle: phi_ref = phi0 + Dphir
   clear Dphir RAHopt

elseif amode == 2                      % Heading Hold / Heading Select
   dialogtext2 = 'Heading Hold / Heading Select';
   ymod1A = [1 1 1 0 0]'; % HH
   HHopt  = menu('What reference signal do you want?',...
                 'Step input Dpsi_ref','Dpsi_ref = 0');
   if HHopt == 1
      Dpsir = input('Give desired psi-step [deg]: ');
      if isempty(Dpsir)
         Dpsir = 0;
      end
      Dpsir = Dpsir*pi/180;
   else
      Dpsir = 0;
   end
   yrefA = [0 Dpsir]'; % Reference yaw-angle = reference heading:
                       %                                psi_ref = psi0 + Dpsir
   clear Dpsir HHopt

elseif amode == 3                      % VOR Navigation mode
   dialogtext2 = 'VOR Navigation';
   ymod1A = [1 1 1 0 0]'; % NAV-armed (control-logic equal to HH mode)
   ymod2A = [1 1 0 1 0]'; % NAV-coupled
   % Note: Dpsir = 0 (Armed phase), reference signal for NAV-coupled comes
   % from VOR block .
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                           MAAR PSI???
elseif amode == 4                      % Localizer mode
   dialogtext2 = 'Localizer';
   ymod1A = [1 1 1 0 0]'; % LOC-armed (control-logic equal to HH mode)
   ymod2A = [1 1 0 0 1]'; % LOC-coupled
   % Note: Dpsir = 0 (Armed phase), reference signal for LOC-coupled comes
   % from ILS block.
else
   % Keep ymod1A = [0 0 0 0 0]' and ymod2A = [0 0 0 0 0]'
   dialogtext2 = 'No asymmetrical';
end

clear smode amode

% Display information box with mode information
% ---------------------------------------------
h1=msgbox([dialogtext1,' mode selected']);
uiwait(h1);
h2=msgbox([dialogtext2,' mode selected']);
uiwait(h2);
clear h1 h2

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
%   - Used warndlg in stead of command-line for warning messages
% October 6, 1997
%   - Added message dialog to finish autopilot mode definition
% October 8, 1997
%   - Removed duplicate warning messages