function dirname = setdir(defdir)
% SETDIR asks the user to specify a directory name and checks if that
% directory is valid. The input argument to this function is the default
% directory (without an input argument there will be no default directory
% during the directory input). Example: SETDIR('C:\MYDATA') uses the
% directory C:\MYDATA as default. Notice the single quotes!
%
% Note: SETDIR has been included to ensure compatibility, but will not be
% supported anymore in future versions of the toolbox! Still, this version
% (FDC 1.3 SR1) is compatible with Matlab 5.

% Variables:
% ----------
% defdir     default directory (for FDC 1.2 usually retrieved by DATADIR.M)
% dirname    the directory as specified by the user
% ok         loop-variable, is set to 1 if directory-specification is correct
% setdir     not a variable but the name of this function

dirname = '';

% Loop is not quitted until the user has specified a valid directory
% ------------------------------------------------------------------
ok = 0;
while ok~=1

   % Without input argument there will be no default directory.
   % ----------------------------------------------------------
   if nargin == 0
      dirname = input(['Specify directory: '] ,'s');
   else
      disp(' ');
      disp(['Default directory: ' defdir]);
      dirname = input('Specify directory (press <Enter> for default directory):','s');
      disp(' ');
      if isempty(dirname)
         dirname = defdir;
      end
   end

   % Check if the specified directory exists. If not display warning.
   % ----------------------------------------------------------------
   if exist(dirname) ~=7
        errordlg('Specified directory doesn''t exist!','Error');
        pause(1);
   else
        ok = 1; % For quitting while-loop
   end
end

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
