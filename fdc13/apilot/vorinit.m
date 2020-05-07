% -------------------------------------------------------------
% VORINIT.m sets the proper parameters for the VOR block in the
% systems APILOT1, APILOT2, and APILOT3. Run this routine be-
% fore starting a new simulation!
%
% See the final thesis of M.O. Rauw, Delft, '93, for more info.
% -------------------------------------------------------------

disp('Initialize the VOR block');
disp('========================');
disp(' ');
HVOR  = input('Altitude of VOR antenna above sea level [m] (default 0): ');
if isempty(HVOR)
   HVOR = 0;
end

xVOR  = input('Initial X-distance to VOR antenna [m] (default 0): ');
if isempty(xVOR)
   xVOR = 0;
end
yVOR  = input('Initial Y-distance to VOR antenna [m] (default 0): ');
if isempty(yVOR)
   yVOR = 0;
end
CD    = input('Course Datum [deg] (default 0): ');
if isempty(CD)
   CD = 0;
end

CD    = CD * pi/180;

disp(' ');
disp('Ready.');

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.

%
% Revision history since October 6, 1997:
% ---------------------------------------
% October 6, 1997
%   - Editorial change
% October 8, 1997
%   - Eliminated unmatched END statement
%   - Changed terminology from Height to Altitude, according pilot's usage
