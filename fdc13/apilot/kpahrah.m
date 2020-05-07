function [Ktheta,Kq,Ki_1,Kphi,Kr,dar,drr,Ki_2] = kpahrah(Vref)
%-------------------------------------------------------------
% KPAHRAH.M sets the gain factors for the simulation models
%   PAH.M, RAH.M, and PAHRAH.M as a function of the velocity
%   of the aircraft (those systems do not contain the complete
%   gain-scheduling functions from the complete simulation
%   models APILOT1, APILOT2, and APILOT3). The reference
%   velocity must be entered as input argument to this func-
%   tion. Without input arguments it will be set to 45 m/s.
%-------------------------------------------------------------

% The input argument Vref contains the reference velocity for which the
% gains must be computed. If it is empty, the default velocity of 45 m/s
% will be used instead (mean velocity of 'Beaver' flight envelope).
% ----------------------------------------------------------------------
if nargin == 0
   Vref = 45;
end

% Gains for Pitch Attitude Hold mode (no turn-compensation).
% ----------------------------------------------------------
Ktheta = -0.001375*Vref^2 + 0.1575*Vref - 4.8031;
Kq     = -0.000475*Vref^2 + 0.0540*Vref - 1.5931;
Ki_1   =  0.5;

% Gains for Roll Attitude Hold mode.
% ----------------------------------
Kphi   =  0.000975*Vref^2 - 0.108*Vref + 2.335625;
Kr     = -4;
dar    =  0.165;
drr    = -0.000075*Vref^2 + 0.0095*Vref - 0.4606;
Ki_2   =  0.25;

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 5, 1997:
% =======================================
% October 5, 1997
%   - Included input argument Vref and gains as output arguments
%   - Removed unnecessary disp commands for better user-interface consistency
