% -------------------------------------------------------------
% ILSINIT.m sets the proper parameters for the ILS block and
% the Glideslope (GS) and Localizer (LOC) control laws in the
% systems APILOT2 and APILOT3. This routine MUST be called
% before starting a simulation of APILOT2 or APILOT3.
%
% Note: the properties of the ILS errors must be set by hand,
%       i.e. double-click the ILS error blocks if you want to
%       change these properties!
% -------------------------------------------------------------

disp('Initialize the ILS block and the approach control laws');
disp('======================================================');
disp(' ');
HRW   = input('Runway altitude above sea-level [m] (default 0 m): ');
if isempty(HRW)
   HRW = 0;
end
xRW   = input('Initial X-distance from aircraft to runway [m] (default 0 m): ');
if isempty(xRW)
   xRW = 0;
end
yRW   = input('Initial Y-distance from aircraft to runway [m] (default 0 m): ');
if isempty(yRW)
   yRW = 0;
end
gamgs = input('Reference flightpath angle on glideslope [deg] (default -3 deg): ');
if isempty(gamgs)
   gamgs = -3;
end
psiRW = input('Reference heading of runway [deg] (default 0 deg): ');
if isempty(psiRW)
   psiRW = 0;
end

xloc  = input('X-distance from runway threshold to LOC antenna [m] (dflt 2000 m): ');
if isempty(xloc)
   xloc = 2000;
end
xgs   = input('X-distance from runway threshold to GS antenna [m] (dflt 300 m): ');
if isempty(xgs)
   xgs = 300;
end
ygs   = input('Y-distance from runway centerline to GS antenna [m] (dflt -100 m): ');
if isempty(ygs)
   ygs = -100;
end

% Determine glideslope and localizer sensitivities (these values are
% already determined by the block ILS which computes the nominal ILS
% values, but we also need these values for recovering the values of
% the angles epsilon_gs en Gamma_loc from the glideslope and localizer
% currents that leave the ILS error blocks).
% --------------------------------------------------------------------
if gamgs == 0
   Sgs = 1;
else
   Sgs = 625/abs(gamgs);
end
if xloc == 0
   Sloc = 1;
else
   Sloc = 1.4*xloc;
end

disp(' ');
disp('Ready.');

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 8, 1997:
% ---------------------------------------
% October 8, 1997
%   - Changed terminology from Height to Altitude, according pilot's usage
