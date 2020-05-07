function y = locswtch(u);
%----------------------------------------------------------------
% LOCSWTCH.m contains the switch-criterion for switching from
% Localizer-Armed to Localizer-Coupled.
%
% Inputsignal
% ===========
% u = [Gamma_loc ; d(Gamma_loc)/dt ; locswtch_feedback]
%
%     Gamma_loc is the angle between the centerline of the run-
%     way and the ground-projection of the line from the air-
%     craft's c.g. to the localizer transmitter [rad]
%
%     d(Gamma_loc)/dt is the rate of change of Gamma_loc [rad/s]
%
%     locswtch_feedback is the previous output from locswtch,
%     used to determine if the LOC mode has been switched from
%     'Armed' to 'Coupled' already
%
% Outputsignal
% ============
% y = flag variable, which determines if the Localizer mode is
%     Armed or Coupled (positive = Armed, negative = Coupled,
%     zero = no LOC mode)
%----------------------------------------------------------------

% Check switch-criterion only if the LOC-mode has not already been switched
% from 'Armed' to 'Coupled'. After switching from 'Armed' to 'Coupled', the
% feedback signal from locswtch becomes negative, so as long as the signal is
% not negative the switch criterion will be checked.
% ---------------------------------------------------------------------------
if ~(u(3) < 0)

   % Evaluate switch criterion for Localizer mode. This criterion depends
   % upon a combination of the angle Gamma_loc and its rate-of-change.
   % See refs.[1] and [2] for more details on this criterion.
   % --------------------------------------------------------------------
   if ((10*u(2)+u(1))>0.0001 & u(1)<0) | ((10*u(2)+u(1))<-0.0001 & u(1)>0)
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
