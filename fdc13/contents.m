% The FDC toolbox - Root directory
% ================================
% This directory contains the initialization routines for the FDC
% package. The following files are included:
%
% FDC.M        Calls FDCINIT.M.
%
% FDCINIT.M    The actual initialization routine for the FDC toolbox,
%              must be run at the start of an FDC session.
%
% FDCINIT.INI  This file contains the current default initialization
%              for the FDC toolbox. It is read-out by FDCINIT.M and by
%              some other routines for extracting default path-settings.
%              If this file does not exist, FDCINIT.M will treat you
%              as a first time user (consequently FDCINIT.INI does not
%              exist right after the installation of the toolbox).
%
% FDC_STRT.M   Subroutine, called by FDCINIT.M, which displays graphical
%              user-menu when FDC toolbox has been initialized.
%
% FDC_STRT.MAT Datafile for FDC_STRT.M
%
% FDC_WELC.M   Subroutine, called by FDCINIT.M, which displays welcome
%              screen.
%
% FDC_WELC.MAT Datafile for FDC_WELC.M
%
% FIRSTRUN.M   Utility which simplifies FDC installation for floppy-disk
%              distribution of the package.

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
