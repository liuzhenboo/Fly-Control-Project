% The FDC toolbox - Examples of using FDC models and tools.
% =========================================================
% The directory EXAMPLES contains demo-files for the FDC toolbox.
% The following files are contained in this directory:
%
% OLOOP1.MDL   Simulink system for evaluating open-loop responses of the
%              'Beaver' aircraft to block or ramp-shaped control inputs to
%              the elevator, rudder, ailerons, flaps, manifold pressure,
%              and/or engine RPM.
%
% OLOOP1T.MDL  'Tutorial', describing the construction of OLOOP1. This system
%              explains the meaning of the different blocks from OLOOP1.
%
% OLOOP2.MDL   Simulink system for evaluating open-loop responses of the
%              'Beaver' aircraft to atmospheric turbulence.
%
% OLOOP2T.MDL  'Tutorial', describing the construction of OLOOP2. This system
%              explains the meaning of the different blocks from OLOOP1.
%
% OLOOP3.MDL   Simulink system for evaluating open-loop responses of the
%              'Beaver' aircraft to control inputs, using a linearized version
%              of the aircraft model (linear state-space matrices determined
%              by applying the linearization program ACLIN to the non-linear
%              aircraft model BEAVER.MDL from the directory AIRCRAFT).
%
% OLOOP3T.MDL  'Tutorial', describing the construction of OLOOP3. This system
%              explains the meaning of the different blocks from OLOOP3.
%
% TRIMDEMO.M   Demonstration of the steady-state trim option, applied to the
%              S-function BEAVER. This demo computes steady-state values for
%              the elevator deflection as a function of the true airspeed
%              and puts the results in a figure. The source-code of this
%              demo has been copied largely from the routine ACTRIM.M, con-
%              tained in the directory TOOLS.

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
