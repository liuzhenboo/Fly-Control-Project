function y = gsswitch(u);
%----------------------------------------------------------------
% GSSWITCH.m contains the switch-criterion for switching from
% Glideslope-Armed to Glideslope-Coupled.
%
% Inputsignal
% ===========
% u = [epsilon_gs ; gsswitch_feedback]
%
%     epsilon_gs is the angle between the nominal glide path and
%     the line from the aircraft's c.g. to the glideslope trans-
%     mitter [rad]
%
%     gsswitch_feedback is the previous output from gsswitch,
%     used to determine if the GS mode has been switched from
%     'Armed' to 'Coupled' already
%
% Outputsignal
% ============
% y = flag variable, which determines if the Glideslope mode
%     is Armed or Coupled (positive = Armed, negative = Coupled)
%----------------------------------------------------------------

% Check switch-criterion only if the GS-mode has not already been switched
% from 'Armed' to 'Coupled'. After switching from 'Armed' to 'Coupled', the
% feedback signal from gsswitch becomes negative, so as long as the signal
% is not negative the switch criterion will be checked.
% -------------------------------------------------------------------------
if ~(u(2) < 0)

   % Evaluate switch criterion for Glideslope mode. If the aircraft crosses
   % the glideslope reference line the mode will switch from 'Armed' to
   % 'Coupled'. This is true if the angle epsilon_gs is equal to zero. Since
   % this usually won't occur due to numerical inaccuracies, the switch
   % criterion is satisfied if this angle is 'smal enough'. See refs.[1] and
   % [2] for more details on this criterion.
   % -----------------------------------------------------------------------
   if abs(u(1)) < 0.005
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
