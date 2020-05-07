function defdir=fdcdir(subdir)
% FDCDIR sets subfolder of the FDC toolbox as default folder.
%
% D = FDCDIR(NAME) returns the complete path of the FDC subfolder
% specified in the string variable NAME to the string variable D.
% The FDC root-folder is extracted from the file FDCINIT.INI, or
% set to the default C:\FDC12 if this INI-file can't be found.
%
% Example: D = FDCDIR('APILOT') and C:\MATLAB\TOOLBOX\FDC13 is
% specified as root folder in FDCINIT.INI.
% This yields: D = 'C:\MATLAB\TOOLBOX\FDC13\APILOT'.
%
% FDCDIR is used by several other FDC programs. See also DATADIR
% and HELPDIR.
%
% Note: the program code itself is based upon generic path and
% file-separators, rather than ':\' and '\'!

% Variables:
% ----------
% defdir    default folder, set by FDCDIR
% rootdir   root-folder of the FDC toolbox
% subdir    subfolder of the FDC toolbox, specified by the user

% If possible, load FDC root-folder from FDC initialization
% file fdcinit.ini. If this file can't be found, use the default
% root-folder C:\FDC12.
% --------------------------------------------------------------
if exist('fdcinit.ini') ~= 2
   rootdir = fullfile(matlabroot,'toolbox','fdc13'); % default FDC root-folder
else
   load fdcinit.ini -mat        % retrieve root-folder from fdcinit.ini
end

if nargin == 0
   defdir = rootdir;
else
   defdir = fullfile(rootdir,subdir);
end

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 7, 1997:
% =======================================
% October 7, 1997
%   - Used MATLABROOT and FULLFILE commands to define default FDC root-folder
%   - Defined MATLABROOT\TOOLBOX\FDC13 as default root-name
%   - Changed terminology from 'directory' to 'folder' (except in function and
%     file names)
%   - FDCDIR now returns FDC root-directory if called without input arguments
% June 15, 1998
%   - Added comment about path and file-separators for FDC 1.3, SR1.
