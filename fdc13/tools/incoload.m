% The FDC toolbox - Load routine INCOLOAD
% =======================================
% INCOLOAD is used by a number of Simulink systems from the FDC toolbox to
% load trimmed flight conditions, linearized aircraft models, etc. from file.
% Note: the parameters of the aircraft model are loaded with the Matlab
% program LOADER; type HELP LOADER for more info.
%
% Type HELP ACTRIM for more info about the determination of steady-state
% trimmed flight conditions; type HELP ACLIN for more info about the
% linearization of the aircraft model.
%
% The default file-extensions used by INCOLOAD are: TRI for a trimmed flight
% condition, LIN for a linearized aircraft model, and MAT for other files.
% The file and path specification are obtained by the Matlab routine
% UIGETFILE.
%

% Define variable skip. If skip == 1, INCOLOAD will be quitted without
% loading any files; if skip == 0, INCOLOAD will first load a datafile.
% Default: skip = 0.
% ---------------------------------------------------------------------
skip = 0;

% While-loop, to correctly specify the filename and path for the datafile.
% As long as ok is not equal to 1, this loop will be repeated (e.g. if the
% file does not exist or the user presses Cancel in the dialog-window).
% ------------------------------------------------------------------------
ok = 0;
while ok ~= 1

   % Determine filetype to be loaded
   % -------------------------------
   opt = menu('Options:','Load trimmed flight condition',...
              'Load linear aircraft model','Load other data','Close');

   % Define default file-extension and title for dialog-window,
   % depending upon the value of opt.
   % ----------------------------------------------------------
   if opt == 1
      defext      = '*.tri';
      dialogtitle = 'Load trimmed flight condition from file';
   elseif opt == 2
      defext      = '*.lin';
      dialogtitle = 'Load linearized aircraft model from file';
   elseif opt == 3
      defext      = '*.mat';
      dialogtitle = 'Load data from file';
   else
      skip = 1;
      ok   = 1;
   end
   clear opt

   if skip ~= 1  % If not quitting...

      % Define default data-directory by calling the subroutine DATADIR.M
      % (which is also used by other FDC subroutines).
      % -----------------------------------------------------------------
      defdir = datadir;

      % If default directory exists, temporarily switch to that directory.
      % ------------------------------------------------------------------
      currentdir = chdir;
      eval(['chdir ',defdir,';'],['chdir ',currentdir,';']);

      % Obtain filename and path.
      % -------------------------
      [filename,dirname] = uigetfile(defext,dialogtitle);

      % If user has not pressed Cancel in the dialog-window, build string
      % for the load command and load the datafile. Else, return to menu.
      % -----------------------------------------------------------------
      if (isstr(filename)~=0 & isstr(dirname)~=0)
         loadcmmnd=['load ',dirname,filename, ' -mat'];
         eval([loadcmmnd,'; ok = 1;'],'disp(''File not found!'')');
      end

      % Back to previous directory
      % --------------------------
      eval(['chdir ',currentdir,';']);

   end % Of part of the program that is skipped when quitting...

end % Of while-loop for correctly entering filename, etc.

% Clear variables which are not needed anymore
% --------------------------------------------
clear currentdir defdir defext dialogtitle filename dirname loadcmmnd
clear skip ok

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% History of this file, starting September 8, 1997:
% =================================================
% September 8, 1997
%   - Replaced cd commands with chdir to enhance compatibility
% October 7, 1997
%   - Editorial changes

