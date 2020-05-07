%----------------------------------------------------------------
% The FDC toolbox - Matlab macro RESULTS
% ======================================
% RESULTS.M is a Matlab macro, wich creates time-trajectories of
% individual inputs to and outputs from the Simulink system BEA-
% VER. RESULTS should be used after running a simulation in which
% the Simulink system BEAVER is involved. During simulations, the
% time-trajectories of all inputvariables are send to the matrix
% In and all time-trajectories of the outputvariables are send to
% to the matrix Out in the Matlab workspace. RESULTS transforms
% these results into time-trajectories of individual inputs and
% outputs, which have self-explaining variable names. So in stead
% of plotting In(:,1) against time, you can plot deltae against
% time after running RESULTS.
%
% See the helpfiles INPUTS.HLP and OUTPUTS.HLP in the subdirecto-
% ry HELP for the exact definitions of the input and output va-
% riables, stored in the matrices In and Out and the variables
% which will be extracted from these matrices by RESULTS.
%
% It is not possible to apply RESULTS to simulation results from
% other systems which do not use the same (default) definitions
% of the matrices In and Out as the system BEAVER. Therefore, if
% you wish to make changes to the lists of inputs and outputs,
% e.g. in order to implement a dynamic model of another aircraft,
% you MUST edit the file RESULTS.M too! This file can be found
% in the subdirectory TOOLS. Apart from some options regarding
% dimensions of variables representing angles and/or angular
% velocities, the macro RESULTS.M is very straightforward, so
% adapting this file for other applications is not difficult.
%
% Note: if the simulation covers many time-points, the matrices
% In and Out will become such large that you may encounter 'Out
% of Memory' errors when running RESULTS.M. In that case, you
% may wish to reduce the number of inputs and outputs, stored
% in the Matlab workspace, thus reducing the size of the matri-
% ces In and/or Out. Of course, you need to delete the correspon-
% ding lines from the file RESULTS.M too if you still want to
% extract time-trajectories of individual inputs and/or outputs.
% 'Out of Memory' errors may occur when simulating aircraft res-
% ponses to atmospheric turbulence, or responses of the aircraft
% to control commands, coming from a digital controller with a
% small sample-time.
%
% Unfortunately, Simulink does not always send the simulation
% results correctly to the workspace. Therefore RESULTS.M always
% checks if the matrices In and Out are present in the workspace.
% If not, it first tries to 'rescue' these 'disappeared' varia-
% bles, assuming that your aircraft model is called BEAVER. If
% In and Out cannot be retrieved, you have to do the simulation
% again. Be careful that you don't mistake old simulation results
% for new ones! This Simulink-problem seems to have something to
% do with the use of To Workspace in the deeper levels of the
% system. Hopefully, this small bug will be fixed soon in newer
% versions of Simulink by the MathWorks Inc.
%
% RESULTS.M does not contain save-options, so remember to store
% the variables yourself. If you save variables, don't forget to
% store the time-axis 'time' too, otherwise you'll not be able
% to plot the time-trajectories of the variables.
%
% See INPUTS.HLP and OUTPUTS.HLP for more info.
%----------------------------------------------------------------


% Check if the matrices In and Out, and the time axis are present in the
% Matlab workspace. If not, make one call to the system BEAVER in order
% to try to 'rescue' the 'lost' simulation results and check again if the
% matrices and time-axis are present (this is done by the routine
% RECOVER.M, which also may be used as a separate routine to recover
% 'lost' results).
% -----------------------------------------------------------------------
if exist('time') == 0 | exist('Out') == 0 | exist('In') == 0
   clc
   disp('Simulation results not found. May be caused by Simulink-bug,')
   disp('so trying to recover the ''lost'' simulation results... ')
   disp(' ');
   recover('beaver');
end
if exist('time') == 0
   error('Time-axis vector ''time'' not present in Workspace!');
elseif exist('Out') == 0
   error('Matrix with output trajectories ''Out'' not present in Workspace!');
elseif exist('In') == 0
   error('Matrix with input trajectories ''In'' not present in Workspace!');
end

% Check if the number of inputs and outputs stored in these matrices cor-
% respond with the default definitions of In and Out used in the system
% BEAVER. Of course, the latter check does not guarantee that the defini-
% tions of the matrices In and Out as found in the Matlab workspace, are in
% accordance with the default definitions used in the system BEAVER, but if
% the number of variables does not match we know for sure that the results
% aren't correct!
%
% The user him/herself must take care of changing RESULTS.M if the defini-
% tions of the matrices In and Out need to be changed!
% ----------------------------------------------------------------------------

[m1,n1] = size(In);
[m2,n2] = size(Out);

if n1 ~= 12
   error('Number of inputs is not equal to 12. RESULTS won''t work!');
elseif n2 ~= 89
   error('Number of outputs is not equal to 89. RESULTS won''t work!');
end

clear m1 n1 m2 n2

% Header to make sure user knows what goes on...
% -----------------------------------------------
clc
disp('FDC 1.2 - RESULTS');
disp('=================');
disp(' ');
disp('Transfer simulation results from matrices In and Out into');
disp('time-trajectories of individual inputs and outputs, using');
disp('self-explaining variable names.');
disp(' ');

% Specify dimension of angles and angular velocities. While-loops ensure
% that that user gives valid answers to the questions.
% ----------------------------------------------------------------------
ok = 0;
while ok ~= 1
   disp(' ');
   angledims = input('Angles in [rad] or [deg] (r/d)? ','s');
   if angledims == 'r'
      disp(' ');
      disp('    Angles will be measured in [rad]');
      c1 = 1;                      % multiplication factor for angles in [rad]
      ok = 1;
   elseif angledims == 'd'
      disp(' ');
      disp('    Angles will be measured in [deg]');
      c1 = 180/pi;                 % multiplication factor for angles in [deg]
      ok = 1;
   else
      disp(' ');
      disp('Enter r for [rad] or d for [deg]!');
   end
end

ok = 0;
while ok ~= 1
   disp(' ');
   ratedims = input('Angular velocities in [rad/s] or [deg/s] (r/d)? ','s');
   if ratedims == 'r'
      disp(' ');
      disp('    Angular velocities will be measured in [rad/s]');
      c2 = 1;        % multiplication factor for angular velocities in [rad/s]
      ok = 1;
   elseif ratedims == 'd'
      disp(' ');
      disp('    Angular velocities will be measured in [deg/s]');
      c2 = 180/pi;   % multiplication factor for angular velocities in [deg/s]
      ok = 1;
   else
      disp(' ');
      disp('Enter r for [rad/s] or d for [deg/s]!');
   end
end

disp(' ');
disp(' ');
disp('Wait a moment please...');

% Now create individual trajectories of control inputs and atmospheric
% disturbances from the results, stored in the matrix In. See INPUTS.HLP
% for the exact definitions.
% ----------------------------------------------------------------------
deltae = In(:,1) * c1;
deltaa = In(:,2) * c1;
deltar = In(:,3) * c1;
deltaf = In(:,4) * c1;
n      = In(:,5);
pz     = In(:,6);
uw     = In(:,7);
vw     = In(:,8);
ww     = In(:,9);
uwdot  = In(:,10);
vwdot  = In(:,11);
wwdot  = In(:,12);

% Now create individual trajectories of outputs from the system BEAVER,
% from the results stored in the matrix Out. See OUTPUTS.HLP for the
% exact definitions.
% ---------------------------------------------------------------------

% State variables:

V        = Out(:,1);
alpha    = Out(:,2)* c1;
beta     = Out(:,3)* c1;
p        = Out(:,4)* c2;
q        = Out(:,5)* c2;
r        = Out(:,6)* c2;
psi      = Out(:,7)* c2;
theta    = Out(:,8)* c2;
phi      = Out(:,9)* c2;
xe       = Out(:,10);
ye       = Out(:,11);
H        = Out(:,12);

% Time-derivatives of states (see VABDOT.HLP, PQRDOT.HLP, EULERDOT.HLP, and
% XYHDOT.HLP):

Vdot     = Out(:,13);
alphadot = Out(:,14)* c1;
betadot  = Out(:,15)* c1;
pdot     = Out(:,16)* c2;
qdot     = Out(:,17)* c2;
rdot     = Out(:,18)* c2;
psidot   = Out(:,19)* c2;
thetadot = Out(:,20)* c2;
phidot   = Out(:,21)* c2;
xedot    = Out(:,22);
yedot    = Out(:,23);
Hdot     = Out(:,24);

% Body-axes velocities (see UVW.HLP):

u        = Out(:,25);
v        = Out(:,26);
w        = Out(:,27);

% Time-derivatives of body-axes velocities (see UVWDOT.HLP):

udot     = Out(:,28);
vdot     = Out(:,29);
wdot     = Out(:,30);

% Dimensionless rotational velocities in aircraft's body-axes (see
% DIMLESS.HLP):

pb_2V    = Out(:,31);
qc_V     = Out(:,32);
rb_2V    = Out(:,33);

% Some additional flightpath variables (see FLPATH.HLP):

gamma    = Out(:,34)* c1;
fpa      = Out(:,35);
chi      = Out(:,36)* c1;
Phi      = Out(:,37)* c1;

% Engine variables (see POWER.HLP):

dpt      = Out(:,38);
P        = Out(:,39);

% Specific forces and kinematic accelerations (see ACCEL.HLP):

Ax       = Out(:,40);
Ay       = Out(:,41);
Az       = Out(:,42);
axk      = Out(:,43);
ayk      = Out(:,44);
azk      = Out(:,45);

% Dimensionless aerodynamic force and moment coefficients (see AEROMOD.HLP):

CXa      = Out(:,46);
CYa      = Out(:,47);
CZa      = Out(:,48);
Cla      = Out(:,49);
Cma      = Out(:,50);
Cna      = Out(:,51);

% Dimensionless propulsive force and moment coefficients (see ENGMOD.HLP):

CXp      = Out(:,52);
CYp      = Out(:,53);
CZp      = Out(:,54);
Clp      = Out(:,55);
Cmp      = Out(:,56);
Cnp      = Out(:,57);

% Aerodynamic forces and moments (see AEROMOD.HLP and FMDIMS.HLP):

Xa       = Out(:,58);
Ya       = Out(:,59);
Za       = Out(:,60);
La       = Out(:,61);
Ma       = Out(:,62);
Na       = Out(:,63);

% Propulsive forces and moments (see ENGMOD.HLP and FMDIMS.HLP):

Xp       = Out(:,64);
Yp       = Out(:,65);
Zp       = Out(:,66);
Lp       = Out(:,67);
Mp       = Out(:,68);
Np       = Out(:,69);

% Forces due to gravity (see GRAVITY.HLP):

Xgr      = Out(:,70);
Ygr      = Out(:,71);
Zgr      = Out(:,72);

% Corrections to body-axes forces due to nonsteady atmosphere (see
% FWIND.HLP):

Xw       = Out(:,73);
Yw       = Out(:,74);
Zw       = Out(:,75);

% Atmosphere variables (see ATMOSPH.HLP):

rho      = Out(:,76);
ps       = Out(:,77);
T        = Out(:,78);
mu       = Out(:,79);
g        = Out(:,80);

% Airdata variables (see AIRDATA1.HLP, AIRDATA2.HLP, and AIRDATA3.HLP):

a        = Out(:,81);
M        = Out(:,82);
qdyn     = Out(:,83);

qc       = Out(:,84);
Ve       = Out(:,85);
Vc       = Out(:,86);

Tt       = Out(:,87);
Re       = Out(:,88);
Rc       = Out(:,89);

% Ready...
% --------
disp(' ');
disp('Ready. Press key to continue...');
pause
clc

% Give user the option to delete matrices In and Out from the workspace
% ---------------------------------------------------------------------
answ = input('Delete matrices In and Out from workspace (y/n)? ','s');
if answ == 'y'
   clear In Out
end

% Display help message for user. Goodbye, see U next time...
% ----------------------------------------------------------
disp(' ');
disp('The workspace now contains time trajectories of the twelve inputs');
disp('(six vectors with control inputs and six with atmospheric distur-');
disp('bances) and the 89 outputs from the system BEAVER. The variable');
disp('names of these vectors are self-explaining, but if you have doubts');
disp('about the definitions, examine the help texts INPUTS.HLP and/or');
disp('OUTPUTS.HLP from the subdirectory HELP.');
disp(' ');
disp('The time-axis against which the results can be plotted is con-');
disp('tained in the variable time.');
disp(' ');
disp('Remember that currently:');
disp(' ');
if angledims == 'd'
   disp('  angles are measured in [deg]');
else
   disp('  angles are measured in [rad]');
end
disp(' ');
if ratedims == 'd'
   disp('  angular velocities are measured in [deg]');
else
   disp('  angular velocities are measured in [rad]');
end
disp(' ');
disp('Ready.');
disp(' ');

clear angledims ratedims ok answ

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 7, 1997:
% =======================================
% October 7, 1997
%   - Editorial changes

