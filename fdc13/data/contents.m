% The FDC toolbox - Datafiles for FDC models and tools.
% =====================================================
% This directory is used by FDC tools to store model parameters, trimmed
% flight conditions, linearized aircraft models, etc. The following file-
% types can be found:
%
% (.MAT  General Matlab datafiles.)
%
% .DAT   Model parameter-files. The file AIRCRAFT.DAT contains geometrical
%        properties, mass and mass-distribution data, the coefficients of the
%        aerodynamic model, and the coefficients of the engine forces and
%        moments model of the 'Beaver' aircraft. This file is created by the
%        routine MODBUILD. See the source-file MODBUILD.M for all definitions.
%        Similar datafiles can be created for implementation of other air-
%        craft models; it is recommended to store such files in the directory
%        DATA too.
%
%        The files ACTMOD35.DAT, ACTMOD45.DAT, and ACTMOD55.DAT contain the
%        state-space models of the cable and actuator dynamics of the
%        'Beaver' autopilot (used by the systems APILOT1, APILOT2, and
%        APILOT3; automatically loaded by APINIT.M).
%
%        Note: the .DAT files must be loaded with the extension -mat, since
%        they use the Matlab file-format with non-default file-extensions.
%
% .TRI   Trimmed flight conditions, obtained by the program ACTRIM.M. The
%        example files CR3520.TRI to CR35100.TRI represent trimmed flight
%        conditions for the 'Beaver' for an airspeed of 35 m/s and an altitude
%        of 2000 to 10000 feet, respectively. Such files can be loaded by
%        typing:
%
%              load <filename>.tri -mat   (e.g. load cr3520.tri -mat)
%
%        where the extension -mat is necessary because the files were saved in
%        Matlab file-format with non-standard file-extensions. Or alter-
%        natively: run INCOLOAD, and select the first option ('load trimmed
%        flightconditions from file'). Similar files are also available for
%        an airspeed of 45 m/s, which is the mean airspeed in the flight-
%        envelope of the 'Beaver'. Those files are called CR4520.TRI to
%        CR45100.TRI, respectively.
%
%        Note: after loading any of these files, you can examine the variable
%        'trimdef' for more information about the trimmed-flight condition
%        (the files were created by ACTRIM, which has also automatically built
%        the variable 'trimdef').
%
% .LIN   Linearized aircraft models, obtained by the program ACLIN.M. The
%        example files CR4520.LIN and CR4560.LIN contain the system matrices
%        of linearized state-models of the 'Beaver' for the operating points,
%        defined in CR4520.TRI and CR4560.TRI (the operating point definitions
%        have been stored in the corresponding .LIN files too, see the varia-
%        ble 'trimdef'). Such files can be loaded by typing:
%
%              load <filename>.lin -mat   (e.g. load cr4520.lin -mat)
%
%        Examine the variable lindef for more information about the linearized
%        models from these files (this variable was created auto-matically by
%        ACLIN when it determined the linearized model).

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
