% The FDC toolbox - Load routine LOADER
% =====================================
% LOADER is a Matlab program to load the parameter matrices for the
% aircraft models from file. Run MODBUILD first to create such data-
% files if they do not yet exist or if they have to be updated.
%
% Note: LOADER also defines the default value of the vector xfix,
% unless xfix is already defined in the Matlab workspace. This
% variable is used by the gain-block XFIX of the aircraft model to
% artificially fix states to their initial values; see XFIX.HLP or
% FIXSTATE.HLP for more info.

% Variables
% ---------
% defdir       default directory determined by DATADIR.M
% datadir      not a variable but a Matlab function
% currentdir   used to store current directory
% filename     name of the datafile, specified by the user (*.dat)
% dirname      name of the directory, specified by the user
% loadcmmnd    stores the resulting command to load the datafile
% xfix         gain vector which may be altered to fix states from the
%              aircraft model (see also FIXSTATE)

% Define default data-directory by calling the subroutine DATADIR.M.
% ------------------------------------------------------------------
defdir  = datadir;

% Go to default directory if that directory exists (if not, start
% load-routine from the current directory).
% ---------------------------------------------------------------
currentdir = chdir;
eval(['chdir ',defdir,';'],['chdir ',currentdir,';']);

% Obtain filename and path.
% -------------------------
[filename,dirname] = uigetfile('*.dat','Load model parameters from file');

% If user has not pressed Cancel in the dialog-window, build string for the
% load command and load the datafile.
% -------------------------------------------------------------------------
if (isstr(filename)~=0 & isstr(dirname)~=0)
   loadcmmnd=['load ',dirname,filename, ' -mat'];
   eval([loadcmmnd,';'],'disp(''File not found!'')');

   % Use the full model (all twelve state equations) if no restrictions have
   % been specified yet. Type HELP FIXSTATE for more info about the meaning
   % of the gain-variable xfix!
   % -----------------------------------------------------------------------
   if exist('xfix')~=1
       xfix = 1;
   end
end

% Back to previous directory.
% ---------------------------
eval(['chdir ',currentdir,';']);

% Clear variables which are not needed anymore.
% ---------------------------------------------
clear loadcmmnd filename dirname defdir currentdir


%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% History of this file, starting September 8, 1997:
% =================================================
% September 8, 1997
%  - Replaced cd commands with chdir to enhance compatibility
% October 7, 1997
%  - Editorial changes
