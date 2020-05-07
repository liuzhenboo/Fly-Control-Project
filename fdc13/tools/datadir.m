function defdir=datadir
% DATADIR determines the default directory for FDC datafiles.
% This function is called by several routines from the FDC toolbox.
%
% See also FDCDIR.

% Variables
% ---------
% defdir    default directory determined by DATADIR.M

defdir = fdcdir('data');

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 7, 1997:
% =======================================
% October 7, 1997
%  - Editorial changes
