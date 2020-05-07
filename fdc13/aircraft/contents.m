% The FDC toolbox - Non-linear aircraft models.
% =============================================
% The directory AIRCRAFT contains the non-linear aircraft models and
% the main model-library for the FDC package. The following files are
% included:
%
% BEAVER.MDL   Complete non-linear Simulink model of the De Havilland
%              DHC-2 'Beaver'.
%
% BUTTONS.MDL  Simulink library in which many button-blocks from the
%              FDC toolbox have been gathered.
%
% FDCLIB.MDL   Main FDC library for Simulink, contains the blocks
%              from BEAVER.M sorted in a library. This is a first
%              step towards a more general Aircraft-dynamics library
%              with models for a large range of aircraft. FDCLIB
%              also contains links to the libraries NAVLIB, TOOLS,
%              WINDLIB, the example systems OLOOP1 to OLOOP3, and
%              the complete non-linear 'Beaver' model BEAVER.
%
%    FDCLIB1.MDL   Sublibrary of FDCLIB, contains Airdata blocks.
%    FDCLIB2.MDL   Sublibrary of FDCLIB, contains Aerodynamic model
%                  blocks (currently for the 'Beaver' only).
%    FDCLIB3.MDL   Sublibrary of FDCLIB, contains Engine forces &
%                  moments blocks (currently for the 'Beaver' only).
%    FDCLIB4.MDL   Sublibrary of FDCLIB, contains blocks for forces and
%                  moments due to gravity and non-steady atmosphere.
%    FDCLIB5.MDL   Sublibrary of FDCLIB, contains the general state-
%                  equations of the non-linear aircraft model.
%    FDCLIB6.MDL   Sublibrary of FDCLIB, contains 'additional' output-
%                  equation blocks.
%    FDCLIB7.MDL   Sublibrary of FDCLIB, contains button-blocks for
%                  initializing the non-linear aircraft model.
%    FDCLIB8.MDL   Sublibrary of FDCLIB, contains button-blocks for
%                  starting up trim and linearization routines ACTRIM
%                  and ACLIN.
%    FDCLIB9.MDL   Sublibrary of FDCLIB, contains button-blocks for
%                  post-processing simulation results.
%    FDCLIB10.MDL  Sublibrary of FDCLIB, contains subsystem equivalents
%                  of the system BEAVER (from BEAVER.MDL)
%
% MODBUILD.M   Matlab program which defines the parameters for the
%              Simulink system BEAVER.
%

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
