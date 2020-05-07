%--------------------------------------------------------------
% APMENU.m is a simple Matlab macro which displays a menu for
% selection of the autopilot simulation model. See APILOT.HLP
% in the directory HELP (type TYPE APILOT.HLP at Matlab command
% line) for more info about the systems APILOT1, APILOT2, and
% APILOT3.
%--------------------------------------------------------------

apsystem = menu('CHOOSE AUTOPILOT SIMULATION MODEL',...
                'APILOT1: no radio-NAV, no turbulence',...
                'APILOT2: no radio-NAV noise, no turbulence',...
                'APILOT3: complete model',...
                'PAH: Pitch Attitude Hold mode only',...
                'RAH: Roll Attitude Hold mode only',...
                'PAHRAH: Pitch and Roll Attitude Hold modes only',...
                'Close');
if ~isempty(apsystem)
   if apsystem == 1
      apilot1
   elseif apsystem == 2
     apilot2
   elseif apsystem == 3
     apilot3
   elseif apsystem == 4
     pah
   elseif apsystem == 5
     rah
   elseif apsystem == 6
     pahrah
   else
   end
end
clear apsystem

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 8, 1997:
% =======================================
% October 8, 1997
%  - Added isempty-check to prevent Simulink 2 warnings.
%  - Deleted CLC command (not necessary because Simulink 2 creates GUI menu)
