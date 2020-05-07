%----------------------------------------------------------------
% ACTRLOAD.M loads the parameters (state-space matrices) for the
% cable and actuator models of the `Beaver' aircraft. These para-
% meters are needed for several autopilot simulation models,
% including APILOT1, APILOT2, and APILOT3.
%----------------------------------------------------------------

% Note: the variable refvelocity contains the reference velocity for which the
% actuator model is loaded. It is returned by this function for later use, such
% as for the routine KPAHRAH.

ACTMOD = menu('Specify desired actuator/cable model:','Model for V=35 m/s',...
              'Model for V=45 m/s','Model for V=55 m/s','CLOSE');
if ~isempty(ACTMOD)
   if ACTMOD == 1
     load actmod35.dat -mat
     refvelocity = 35;
   elseif ACTMOD == 2
     load actmod45.dat -mat
     refvelocity = 45;
   elseif ACTMOD == 3
     load actmod55.dat -mat
     refvelocity = 55;
   else
     h = warndlg('No actuator and cable model loaded!');
     uiwait(h);
   end
end

clear ACTMOD h

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 5, 1997:
% =======================================
% October 5, 1997
%   - Removed unnecessary disp commands for command-line to improve UI consistency
%   - Added refvelocity as return value (also used as reference velocity for the
%     Pitch and Roll Attitude Hold gains for the systems PAH, RAH, and PAHRAH)
% October 6, 1997
%   - Removed function call for ACTRLOAD (keeps variables 'visible' from outside
%     ACTRLOAD)
% October 8, 1997
%   - Included CLOSE option with warning message and ISEMPTY-check