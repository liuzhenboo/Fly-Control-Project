function y = navswtch(u);
%--------------------------------------------------------------
% NAVSWTCH.m contains the switch-criterion for switching from
% Navigation-Armed to Navigation-Coupled.
%
% Inputsignal
% ===========
% u = [Gamma_VOR ; navswtch_feedback]
%
%     Gamma_VOR is the angle between the nominal VOR-bearing
%     and the actual VOR-bearing [rad]
%
%     navswtch_feedback is the previous output from navswtch,
%     used to determine if the NAV mode has been switched from
%     'Armed' to 'Coupled' already
%
% Outputsignal
% ============
% y = flag variable, which determines if the VOR-navigation mode
% is Armed or Coupled (positive = Armed, negative = Coupled,
% zero = no NAV mode)
%----------------------------------------------------------------

% Check switch-criterion only if the NAV mode has not already been switched
% from 'Armed' to 'Coupled'. After switching from 'Armed' to 'Coupled', the
% feedback signal from navswtch becomes negative, so as long as the signal
% is not negative the switch criterion will be checked.
% -------------------------------------------------------------------------
if ~(u(2) < 0)

   % Evaluate switch criterion for Navigation mode. If the aircraft cros-
   % ses the required VOR radial, the mode will be switched from Armed to
   % Coupled. In that case, the angle Gamma_VOR will be equal to zero.
   % Since in practice, this will not occur due to numerical inaccuracies,
   % the switch criterion is satisfied if Gamma_VOR is 'small enough'.
   % See refs.[1] and [2] for more details on this criterion.
   % ---------------------------------------------------------------------
   if abs(u(1)) < 0.0001 % Aircraft crosses the reference VOR bearing
      y = -1; % negative = coupled
   else
      y =  1; % positive = armed
   end

else
   y = -1; % stay coupled
end


% References
% ==========
% [1]  M.O. Rauw, A SIMULINK environment for Flight Dynamics and
%      Control analysis - Application to the DHC-2 'Beaver',
%      PART II! Graduate's thesis, Delft University of Technology,
%      Faculty of Aerospace Engineering, Delft, 1993.
%
% [2]  P.N.H. Wever, Ontwerp en implementatie van de regelwetten
%      van de De Havilland DHC-2 'Beaver' (in Dutch). Graduate's
%      thesis, Delft University of Technology, Faculty of Aero-
%      space Engineering, Delft, 1993.

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
