% The FDC toolbox - Model definitions, analytical tools, etc.
% ===========================================================
% The directory TOOLS contains some Matlab routines to load or specify
% model parameters, a program to find steady-state trimmed flight conditions,
% a linearization program, a Matlab macro for post-processing simulation
% results from the non-linear aircraft model, and a Simulink block-library
% containing some useful general-purpose blocks. The following files are
% included:
%
% ACCONSTR.M   Matlab subroutine which is called by the trim program ACTRIM
%              and its subroutine ACCOST. This routine evaluates the flight-
%              path constraints during the trimming process.
%
% ACCOST.M     Matlab subroutine which is called by the trim program ACTRIM.
%              This routine evaluates the cost function during the trimming
%              process.
%
% ACLIN.M      Matlab program for linearizing the non-linear aircraft model,
%              using the Simulink linearization routine LINMOD. ACLIN con-
%              tains many options for defining linearized aircraft models,
%              based upon the definitions of states and inputs from the sys-
%              tem BEAVER. ACLIN also is powerful with regard to the presen-
%              tation of the results from the linearization process.
%
% ACTRIM.M     Matlab program for determining steady-state trimmed flight-
%              conditions for the non-linear aircraft model BEAVER (or any
%              other model which uses the same inputs and outputs). This
%              routine takes into account flight-path constraints. It is
%              quite flexible with regard to the initial definitions of the
%              flight condition and the presentation of the results from the
%              trimming process.
%
% COMMENT.M    Matlab subroutine which is called by ACTRIM - and possibly
%              some other FDC routines - in order to ...  (well, it is better
%              to run COMMENT at the Matlab command line to find it out your-
%              self).
%
% DATADIR.M    Matlab function which determines the default-directory where
%              the other FDC routines will search for datafiles (subdirectory
%              DATA).
%
% FDCDIR.M     Matlab function, used to select an FDC subdirectory as default
%              directory.
%
% FDCHELP.M    Matlab function, used to display on-line help texts for FDC.
%
% FDCTOOLS.MDL Simulink block-library with some useful general-purpose blocks
%              which can't be found in the standard Simulink libraries.
%
% FIXSTATE.M   Matlab program which can be used for artificially fixing
%              state  variables from the aircraft model to their initial
%              values during simulations. For instance, decoupling symmetrical
%              and asymmetrical motions of the aircraft may sometimes be
%              useful, especially for demonstrations of the basic aircraft
%              responses (i.e. its eigenfrequencies, etc.).
%
% HELPDIR.M    Matlab function which determines the default-directory of the
%              FDC help-texts (subdirectory HELP).
%
% INCOLOAD.M   Matlab program which is used for loading all kinds of model
%              parameters from data-files (e.g. trimmed-flight operating
%              points or system matrices of a linearized aircraft model). It
%              is called by ACLIN and ACTRIM, but it can also be used as
%              stand-alone program.
%
% LOADER.M     Matlab program which can be used for loading aircraft-model
%              parameters from the file AIRCRAFT.DAT (which is created by
%              the routine MODBUILD.M from the directory AIRCRAFT. This pro-
%              gram is called by other routines if they can't find the model-
%              parameters in the Matlab workspace when they need them. In
%              addition, LOADER can be used as stand-alone program too.
%
% NSWITCH.M    Matlab program for generating graphical n-switch blocks for
%              Simulink. These n-switch blocks are used to select one out of
%              n different input signals. For instance, if the user wants
%              to include a switch-block for selecting one out of 7 inputs to
%              a graphical Simulink system, the routine NSWITCH can be used
%              to generate the 7-switch block, which then can be included in
%              the desired system. NSWITCH can be started from the Matlab
%              Command-line or is called automatically when selecting the
%              option 'Generate n-switch' from the block-library FDCTOOLS.
%
% NUM2STR2.M   Slightly changed version of NUM2STR. Makes it possible to
%              specify the number of string elements to be used. This routine
%              is called by the trim and linearization routines ACTRIM and
%              ACLIN and the Matlab function SYSTPROP.
%
% RECOVER.M    Small Matlab routine which helps recovering simulation results
%              which were not properly sent to the Workspace due to a bug
%              in Simulink.
%
% RESPLOT.M    Plotting routine with as yet VERY limited capabilities. Still
%              it may be useful to run this program after running RESULTS
%              for viewing the most important simulation results from the
%              non-linear aircraft model. Expect better versions in the
%              future...
%
% RESULTS.M    Matlab macro for post-processing results of simulations of the
%              non-linear aircraft model. This routine is not very flexible:
%              it only works well for systems which use exactly the same
%              input and output vectors as the system BEAVER. However, it is
%              very easy to modify this routine when necessary.
%
% SETDIR.M     Matlab function which asks the user to specify a directory
%              name and then checks whether this directory actually exists.
%              It is called by a number of other FDC programs.
%
% SOFTLIM.M    Matlab function, called by the Simulink block 'Soft-limiter'
%              from the block-library FDCTOOLS.
%
% SYSTPROP.M   Matlab function, computes some basic properties of linear
%              systems in state-space or transfer function format.

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
