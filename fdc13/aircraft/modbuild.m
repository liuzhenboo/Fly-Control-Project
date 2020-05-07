%----------------------------------------------------------------
% The FDC toolbox - MODBUILD
% ==========================
% MODBUILD is a Matlab program, used to build a datafile with
% parameters for the aircraft model. This version of MODBUILD can
% be applied to the DHC-2 'Beaver' model (the Simulink system
% BEAVER) only, but some of the subroutines which are called are
% more general (see comment lines in MODBUILD.M).
%
% MODBUILD needs to be used every time the model parameters are
% changed. This includes changes in mass properties, since these
% are considered to be constant during the short time-intervals
% over which the aircraft responses are considered. It is not
% necessary to run MODBUILD more than once for the same set of
% model parameters if you use the 'save' option.
%
% There is only one way to change parameters, namely: by edi-
% ting the program! Since in practice, MODBUILD will not be
% applied very often, this is not really as inconvenient as it
% looks. Moreover, it is straightforward to add user-input lines
% if required. So, in other words, MODBUILD functions as a simple
% batch-file. The user is informed about the construction of the
% datafile by means of cleverly placed ECHO ON and ECHO OFF com-
% mands.
%
% Change the aircraft-dependent parts of this program if you want
% to implement models of other aircraft.
%----------------------------------------------------------------

% First, we'll save the data which is currently available in the workspace
% to a temporaty file. This is to make sure that no important data will be
% deleted during execution of MODBUILD.
% ------------------------------------------------------------------------
save modbuild.tmp
clear

% MODBUILD HEADER.
%=================
clc;
disp('The FDC toolbox - MODBUILD');
disp('==========================');
disp(' ');
disp('Build datafiles with parameters for non-linear aircraft model.');
disp(' ');
disp('Results are valid for the DHC-2 ''Beaver'' aircraft. Change the');
disp('program MODBUILD.M if models of other aircraft are to be used.');
disp(' ');
disp(' ');
disp('<< Press key to continue >>');
pause
clc

% DEFINE PARAMETERS FOR THE AERODYNAMIC MODEL
% ===========================================

% CURRENT CONFIGURATION: Standard nonlinear model of the DHC-2 'Beaver',
% according to [Tjee and Mulder, 1988]. The aerodynamic force and moment
% coefficients for this aircraft can be written as nonlinear polynomial
% functions of the state and input variables. This model description is
% very compact, because only one set of stability and control derivatives
% (= polynomial coefficients) is needed.
%
% For other aircraft, it is more customary to determine the aerodynamic
% forces and moments by interpolating in large multi-dimensional tables.
% Although such models use significantly more parameter matrices, it is
% really quite straightforward to replace the following matrix definitions
% by similar definitions for other aircraft.
%
% Here, the aerodynamic stability and control derivatives are stored in
% the matrix AM. For aerodynamic models, consisting of multiple tables,
% it is recommended to use variable names like AM1, AM2, etc. to maintain
% commonality with the current 'Beaver' model BEAVER.

echo on

  % Define stability and control derivatives of the DHC-2 'Beaver'
  % for the nonlinear aerodynamic model, which is valid within the
  % 35-55 m/s TAS range (see [Tjee & Mulder, 1988]).
  % --------------------------------------------------------------
  CX0   = -0.03554;    CZ0    = -0.05504;    Cm0  =  0.09448;
  CXa   =  0.002920;   CZa    = -5.578;      Cma  = -0.6028;
  CXa2  =  5.459;      CZa3   =  3.442;      Cma2 = -2.140;
  CXa3  = -5.162;      CZq    = -2.988;      Cmq  = -15.56;
  CXq   = -0.6748;     CZde   = -0.3980;     Cmde = -1.921;
  CXdr  =  0.03412;    CZdeb2 = -15.93;      Cmb2 =  0.6921;
  CXdf  = -0.09447;    CZdf   = -1.377;      Cmr  = -0.3118;
  CXadf =  1.106;      CZadf  = -1.261;      Cmdf =  0.4072;

  CY0   = -0.002226;   Cl0    =  0.0005910;  Cn0  = -0.003117;
  CYb   = -0.7678;     Clb    = -0.06180;    Cnb  =  0.006719;
  CYp   = -0.1240;     Clp    = -0.5045;     Cnp  = -0.1585;
  CYr   =  0.3666;     Clr    =  0.1695;     Cnr  = -0.1112;
  CYda  = -0.02956;    Clda   = -0.09917;    Cnda = -0.003872;
  CYdr  =  0.1158;     Cldr   =  0.006934;   Cndr = -0.08265;
  CYdra =  0.5238;     Cldaa  = -0.08269;    Cnq  =  0.1595;
  CYbdot= -0.1600;                           Cnb3 =  0.1373;

echo off

AM = [ CX0     CY0     CZ0     Cl0     Cm0     Cn0  ;
       CXa     0       CZa     0       Cma     0    ;
       CXa2    0       0       0       Cma2    0    ;
       CXa3    0       CZa3    0       0       0    ;
       0       CYb     0       Clb     0       Cnb  ;
       0       0       0       0       Cmb2    0    ;
       0       0       0       0       0       Cnb3 ;
       0       CYp     0       Clp     0       Cnp  ;
       CXq     0       CZq     0       Cmq     Cnq  ;
       0       CYr     0       Clr     Cmr     Cnr  ;
       0       0       CZde    0       Cmde    0    ;
       CXdf    0       CZdf    0       Cmdf    0    ;
       0       CYda    0       Clda    0       Cnda ;
       CXdr    CYdr    0       Cldr    0       Cndr ;
       CXadf   0       CZadf   0       0       0    ;
       0       CYdra   0       0       0       0    ;
       0       0       0       Cldaa   0       0    ;
       0       0       CZdeb2  0       0       0    ;
       0       CYbdot  0       0       0       0    ];

AM = AM';

disp(' ');
disp('<< Press key to continue >>');
pause
clc


% DEFINE PARAMETERS FOR ENGINE FORCES & MOMENTS MODEL.
% ====================================================

% CURRENT CONFIGURATION: Standard nonlinear model of the DHC-2 'Beaver',
% according to [Tjee and Mulder, 1988].
%
% The engine forces and moments model of the DHC-2 'Beaver' also expresses
% the force and moment coefficients as nonlinear polynomial functions of
% external inputs and state variables.
%
% Here, the engine stability and control derivatives are stored in the
% matrix EM. For engine models, consisting of multiple tables, it is re-
% commended to use variable names like EM1, EM2, etc. to maintain com-
% monality with the current 'Beaver' model BEAVER.

echo on

  % The nonlinear engine model of the DHC-2 "BEAVER" aircraft
  % valid within the 35-55 m/sec TAS-range (see [Tjee & Mulder, 1988]).
  % -------------------------------------------------------------------
  CXdpt   =  0.1161;
  CXadpt2 =  0.1453;
  CZdpt   = -0.1563;
  Cla2dpt = -0.01406;
  Cmdpt   = -0.07895;
  Cndpt3  = -0.003026;

echo off

EM = [ CXdpt    0        CZdpt    0        Cmdpt    0      ;
       0        0        0        0        0        Cndpt3 ;
       CXadpt2  0        0        0        0        0      ;
       0        0        0        Cla2dpt  0        0      ];

EM = EM';

disp(' ');
disp('<< Press key to continue >>');
pause
clc


% DEFINITION OF RELEVANT AIRCRAFT GEOMETRY AND MASS-DISTRIBUTION PARAMETERS.
%
% (Note: geometry and mass properties are assumed to be constant during the
% motions of interest! If it is required to compute the influence of changes
% in these properties on-line during the simulation, many blocks in the sys-
% tems BEAVER or BEAVER1 have to be changed. First of all, a block which
% computes the geometrical and/or mass properties must be added to the sys-
% tem. Then use a text editor to find the blocks in which the parameter ma-
% trices GM1 and GM2 are used and replace these parameters by variables.
% Add corresponding Inport blocks to these blocks, and make the proper
% connections to the block in which the geometry and mass properties are
% calculated.)
% ==========================================================================

echo on

  % Aircraft data on which the aerodynamic model is based. CHANGE THE
  % VARIABLES ACCORDING TO YOUR OWN WISHES BY EDITING MODBUILD.
  % -----------------------------------------------------------------

  % Mass and mass-distribution.
  % ---------------------------
  Ix      =  5368.39;               % kgm^2 in Fr
  Iy      =  6928.93;               % kgm^2 in Fr
  Iz      = 11158.75;               % kgm^2 in Fr
  Jxy     =     0.0;                % kgm^2 in Fr
  Jxz     =   117.64;               % kgm^2 in Fr
  Jyz     =     0.0;                % kgm^2 in Fr
  m       =  2288.231;              % kg

  % geometric data.
  % ---------------
  cbar    =     1.5875;             % m
  b       =    14.63;               % m
  S       =    23.23;               % m^2

echo off

% THE FOLLOWING EQUATIONS ARE VALID FOR ANY RIGID AIRCRAFT
% (ALSO VALID FOR NON-SYMMETRIC AIRCRAFT).
%
% Calculate inertia parameters (see NASA TP 2768). The formula's
% are valid for symmetric and asymmetric aircraft.
% --------------------------------------------------------------
detI = Ix*Iy*Iz - 2*Jxy*Jxz*Jyz - Ix*Jyz^2 - Iy*Jxz^2 - Iz*Jxy^2;
I1   = Iy*Iz - Jyz^2;
I2   = Jxy*Iz + Jyz*Jxz;
I3   = Jxy*Jyz + Iy*Jxz;
I4   = Ix*Iz - Jxz^2;
I5   = Ix*Jyz + Jxy*Jxz;
I6   = Ix*Iy - Jxy^2;

Pl  = I1/detI; Pm = I2/detI; Pn = I3/detI;
Ppp = -(Jxz*I2 - Jxy*I3)/detI;
Ppq = (Jxz*I1 - Jyz*I2 - (Iy-Ix)*I3)/detI;
Ppr = -(Jxy*I1 + (Ix-Iz)*I2 - Jyz*I3)/detI;
Pqq = (Jyz*I1 - Jxy*I3)/detI;
Pqr = -((Iz-Iy)*I1 - Jxy*I2 + Jxz*I3)/detI;
Prr = -(Jyz*I1 - Jxz*I2)/detI;

Ql  = I2/detI; Qm = I4/detI; Qn = I5/detI;
Qpp = -(Jxz*I4 - Jxy*I5)/detI;
Qpq = (Jxz*I2 - Jyz*I4 - (Iy-Ix)*I5)/detI;
Qpr = -(Jxy*I2 + (Ix-Iz)*I4 - Jyz*I5)/detI;
Qqq = (Jyz*I2 - Jxy*I5)/detI;
Qqr = -((Iz-Iy)*I2 - Jxy*I4 + Jxz*I5)/detI;
Qrr = -(Jyz*I2 - Jxz*I4)/detI;

Rl  = I3/detI; Rm = I5/detI; Rn = I6/detI;
Rpp = -(Jxz*I5 - Jxy*I6)/detI;
Rpq = (Jxz*I3 - Jyz*I5 - (Iy-Ix)*I6)/detI;
Rpr = -(Jxy*I3 + (Ix-Iz)*I5 - Jyz*I6)/detI;
Rqq = (Jyz*I3 - Jxy*I6)/detI;
Rqr = -((Iz-Iy)*I3 - Jxy*I5 + Jxz*I6)/detI;
Rrr = -(Jyz*I3 - Jxz*I5)/detI;

% Summarizing results in aircraft parameter matrices GM1 and GM2.
% ---------------------------------------------------------------
GM1 = [cbar b    S    Ix   Iy   Iz   Jxy  Jxz  Jyz  m];

GM2 = [ Pl   Pm   Pn   Ppp  Ppq  Ppr  Pqq  Pqr  Prr ;
        Ql   Qm   Qn   Qpp  Qpq  Qpr  Qqq  Qqr  Qrr ;
        Rl   Rm   Rn   Rpp  Rpq  Rpr  Rqq  Rqr  Rrr ];

disp(' ');
disp('<< Press key to continue >>');
pause
clc


% Save the aircraft parameters to file. The default folder for this
% action is the subfolder DATA of the FDC toolbox, which is put in
% the variable defdir. The current directory is stored in the
% variable currentdir, which is used if the default directory can't
% be found.
% =================================================================
defdir = datadir;
currentdir = chdir;

% Go to default directory if that directory exists (if not, start
% save-routine from the current directory).
% ---------------------------------------------------------------
eval(['chdir ',defdir,';'],['chdir ',currentdir,';']);

% Obtain path (use default filename AIRCRAFT.DAT).
% ------------------------------------------------
[filename,dirname] = uiputfile('aircraft.dat','Save aircraft model parameters');

% Build string variable which specifies what to save in which file.
% -----------------------------------------------------------------
savecmmnd=['save ',dirname,filename,' AM EM GM1 GM2'];

% Evaluate the save command-string.
% ---------------------------------
eval(savecmmnd);


% clear used variables
% --------------------
clear savecmmnd defdir currentdir

% CONCLUDING REMARKS.
%====================
clc
disp('Ready. The data can now be loaded into the Matlab workspace');
disp('by typing: LOAD AIRCRAFT.DAT -MAT');
disp(' ');
disp('Aerodynamic data is contained in the matrix AM, engine data is');
disp('contained in EM, aircraft geometry, mass, and mass distribution');
disp('data is contained in GM1 and GM2.');
disp(' ');
disp('You may also use the macro LOADER.M to load the data matrices');
disp('in the Matlab workspace. MODBUILD doesn''t have to be used again,');
disp('unless you want to make changes to the model parameters. In that');
disp('case, MODBUILD.M needs to be edited.');
disp(' ');

% Clear workspace, retrieve variables from temporary MAT-file and delete
% temporary MAT-file. Workspace will now contain the same variables as
% before running MODBUILD.
% ----------------------------------------------------------------------
clear
load modbuild.tmp -mat
delete('modbuild.tmp');


% ------------------------------------------------------------
% References:
%
% R.T.H. Tjee and J.A. Mulder. Stability and Control Deriva-
% tives of the De Havilland DHC-2 "Beaver" aircraft. Report
% LR-556, Delft University of Technology, 1988.
%
% Duke, E.L., Patterson, B.P. and Antoniewicz, R.F. User's
% manual for LINEAR, a Fortran Program to derive Linear Air-
% craft Models. NASA TP 2768, 1987.
%
% Ruijgrok: Elements of Airplane Performance, Delft University
% Press, DUT (L&R), 1990.
%
% Rauw, M.O.: A Simulink environment for Aircraft Dynamics and
% Control analysis - Application to the DHC-2 'Beaver',
% Graduate's thesis, DUT (L&R), 1993.
%
% Rauw, M.O.: FDC 1.2 - A Simulink Toolbox for Flight Dynamics
% and Control Analysis, 1997.
% ------------------------------------------------------------


%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
