%------------------------------------------------------------------
% FDCINIT temporarily enhances the Matlabpath with the FDC root-
% and subfolders. This eases the pressure on the Matlabpath for
% non-frequent users of the FDC toolbox.
%
% FDCINIT creates a datafile called FDCINIT.INI in the root of the
% main folder of Simulink, which contains the extension to the
% Matlabpath, needed for FDC to run properly. It is possible to
% change the Matlabpath extension afterwards, that is: to change
% the names of the folders, to add subfolders, or to delete
% subfolders.
%
% The standard tree-structure for the FDC-package is:
%
% Root-folder:
%           MATLABROOT\TOOLBOX\FDC13\
%
% (note: FDC 1.3 SR1 applies generic path and file-separators, even
% though the documentation is still based upon MD DOS path-notation).
%
% Subfolders:
%           AIRCRAFT  contains the general aircraft model
%           APILOT    contains the autopilot simulation models
%           DATA      used for storing model parameters and other
%                     datafiles (e.g. trim conditions)
%           DOC       contains program documentation (README-files)
%           EXAMPLES  contains open-loop FDC examples
%           HELP      contains help texts for the FDC models
%           NAVIGATE  contains a library with VOR/ILS blocks
%           TOOLS     contains a TOOLS library (Simulink) and pro-
%                     grams for aircraft trim and linearization
%           WIND      contains a wind and turbulence library
%
% When FDCINIT is used for the first time, this standard path will
% be used as starting point for the Matlab-path extension for FDC
% (except for the subfolder DOC, which won't be needed during
% 'normal' FDC sessions). If the user changes this path, the new
% definition will be saved to the file FDCINIT.INI as default set-
% ting. Each time FDCINIT is used, the tree definition will be
% displayed, and the user will be asked if the path needs to be
% changed. It is possible to suppress this message for future runs
% of FDCINIT, in which case the path-definition cannot be changed
% anymore unless FDCINIT.INI is deleted first.
%
% Note: the file FDCINIT.INI is also used by ACTRIM, ACLIN, and
% LOADER to define a default folder in places where results need
% to be saved. If FDCINIT.INI is not present, these routines will
% all use DEFAULT defaults (if you know what I mean).
%------------------------------------------------------------------
clc
errorflag = 0;

% The extension of the Matlabpath is stored in pathext; pathtmp
% is a temporary path-variable, used to delete unwanted space in
% the path extension.
% --------------------------------------------------------------
pathext = [];
pathtmp = [];

if exist('fdcinit.ini') == 0   % Path definition has not been created yet,
                               % use default definitions as starting point.
                               % ------------------------------------------

   % The root folder of the Matlabpath extension (i.e., the FDC root) is
   % stored in rootdir. MATLABROOT\TOOLBOX\FDC13 is the default definition.
   % ----------------------------------------------------------------------
   rootdir = fullfile(matlabroot,'toolbox','fdc13');

   % The definition of the subfolders of the FDC package are stored in
   % subdirs (folder = directory). Default definitions are given below:
   % ------------------------------------------------------------------
   subdirs = ['aircraft'; 'apilot  '; 'data    '; 'examples';
              'help    '; 'navigate'; 'tools   '; 'wind    '];

   % The default definition of the Matlabpath extension will be used and the
   % user will be asked if that's correct (if not, the Matlab-path extension
   % can be changed). This question will appear every next time FDCINIT is
   % used, but it is possible to suppress the message for future sessions.
   % The variable 'suppress' is used to check this. If suppress = 0 (default)
   % the "is this correct" message will appear when starting FDCINIT; if the
   % user selects the option "suppress this message", suppress = 1 will be
   % set, and the message will not appear the next times FDCINIT is started.
   % Redefining the folder tree afterwards is then only possible after
   % deleting the file FDCINIT.INI before running FDCINIT again.
   % ------------------------------------------------------------------------
   suppress = 0;

else

   % Load definition of the Matlabpath extension and suppress variable
   % from the initialization file FDCINIT.INI.
   % -----------------------------------------------------------------
   load fdcinit.ini -mat

end

% Display welcome messages
% ------------------------
fdc_welc;     % welcome screen
pause;        % show until user presses a key
close(gcf);

% Display path information, unless user has selected 'suppress' option
% during an earlier FDC session.
% --------------------------------------------------------------------
if suppress ~= 1
   if exist('fdcinit.ini') == 0  % First time use: more details shown
      clc
      disp('Current Matlabpath extension for the FDC toolbox:');
      disp(' ');
      disp('FDC root-folder:');
      disp('----------------');
      disp(['   ',matlabroot,filesep,'TOOLBOX',filesep,'FDC13']);
      disp(' ');
      disp('FDC subfolders:');
      disp('---------------');
      disp('   AIRCRAFT    nonlinear aircraft model and model libraries');
      disp('   APILOT      autopilot simulation models');
      disp('   DATA        model parameters and other FDC datafiles');
      disp('   EXAMPLES    examples and tutorials');
      disp('   HELP        on-line help texts');
      disp('   NAVIGATE    radio-navigation library (VOR, ILS)');
      disp('   TOOLS       analytical tools, general blocklibrary, etc.');
      disp('   WIND        wind and turbulence blocks');
      disp(' ');
      disp('By default this definition should be allright. Change only if');
      disp('really neccessary!');
      disp(' ');

   else

      disp('Current Matlabpath-extension for the FDC toolbox:');
      disp(' ');
      disp(['FDC root folder:    ', rootdir]);
      disp(' ');
      disp(['FDC subfolders:     ', subdirs(1,:)]);
      [m,n] = size(subdirs);

      for i = 2:m
         disp(['                    ', subdirs(i,:)]);
      end

      disp(' ');

   end
end

if suppress == 0  % Do not skip the "Is this correct?"-message (definition
                  % from FDCINIT.INI will be used if suppress == 1). The
                  % variable suppress is stored in the file FDCINIT.INI.
                  % ------------------------------------------------------
   answ=input('FDC path ok? ([y]=yes, n=no, s=suppress this message in future): ','s');

   if isempty(answ)
      answ = 'y';
   end
   if answ == 'n'
      % Change Matlabpath extension.
      % -----------------------------
      ready = 0;
      while ready ~= 1
         clc
         opt = menu('Options','Change FDC root folder',...
                    'Rename or delete FDC subfolders',...
                    'Add FDC subfolders','Close');

         if opt == 1        % Change root folder.
                            % -------------------
            disp(' ');
            disp(' ');
            disp(['Current FDC root: ' rootdir]);
            disp(' ');

            % Enter new name of root folder (including root drive).
            % --------------------------------------------------------
            newroot = input('New root folder: ','s');
            if ~isempty(newroot)
               rootdir = newroot;
               clear newroot
            end

         elseif opt == 2    % Change or delete subfolders.
                            % ----------------------------
            disp(' ');
            disp(' ');
            newsubs = [];
            for i = 1:m     % For all subfolders: ask if changes have to
                            % be made, if the subdir has to be deleted from
                            % the path, or if old subfolder must be used.
                            % ----------------------------------------------
               disp(' ');
               disp(' ');
               disp(['Subfolder ' num2str(i) ': ' subdirs(i,:)]);
               disp(' ');

               answ2 = '';
               while isempty(answ2)
                  answ2 = input('c = change, d = delete from path, s = skip: ','s');
               end

               if answ2 == 'c'
                  newname = input('New subfolder [<= 8 characters!]: ','s');
                  if isempty(newname)
                     newname = subdirs(i,:);
                  end

                  % Check length of new entries, to make sure that folder
                  % name is not too long, and to add spaces to folder name
                  % if it has less than eight characters.
                  % ------------------------------------------------------
                  L = length(newname);
                  if L > 8
                     error('Directory name must be shorter than 9 characters!');
                  elseif L < 8
                     for ii = 1:(8-L)  % add spaces to newsub to get sub-
                                       % folder name of 8 characters.
                        newname = [newname ' '];
                     end
                  end

                  % New subfolder stored in newsubs.
                  % --------------------------------
                  newsubs = [newsubs; newname];

               elseif answ2 == 'd'

                  % Don't store a foldername in newsubs (has the same
                  % effect as deleting a foldername from the variable
                  % subdirs!).
                  % -------------------------------------------------
                  disp(' ');
                  disp(['subfolder ' subdirs(i,:) ' deleted!']);

               else

                  % Store old subfolder from FDCINIT.INI or
                  % the default folders (used if FDCINIT.INI doesn't
                  % exist yet) in variable newsubs.
                  % ------------------------------------------------
                  newsubs = [newsubs; subdirs(i,:)];

               end

            end

            % Use new folder tree, stored in newsubs, instead of the old
            % definition, which was stored in subdirs (overwrite subdirs).
            % ------------------------------------------------------------
            subdirs = newsubs;
            [m,n] = size(subdirs); % To prevent errors when subfolder-
                                   % change code is called again directly
                                   % after finishing THIS subdir-change.
            disp(' ');
            disp('Current definition of subfolder tree:');
            disp(' ');
            disp(subdirs);
            disp(' ')
            disp(' ');
            disp('<<< Press a key >>>');
            pause

         elseif opt == 3    % Add subfolders to tree

            ready1 = 0;
            disp(' ');
            while ready1 ~= 1
               clc
               disp('Current definition of subfolder tree:');
               disp(' ');
               disp(subdirs);
               disp(' ');
               disp(' ');
               disp('Enter name of subfolder to add');
               disp('[<= 8 characters, enter = ready!]:');
               disp(' ');

               % Enter new subfolder name.
               % -------------------------
               newname = input('> ','s');

               % If new entry is empty, no new folders will be added to
               % the folder tree anymore.
               % ------------------------------------------------------
               if isempty(newname)
                  ready1 = 1;
               end

               % Check length of the subfolder to make sure that the
               % folder name is not longer than eight characters, or to
               % add spaces to folder name if it is shorter than eight
               % characters.
               % ------------------------------------------------------
               L = length(newname);

               if L > 8
                  error('Filename must be shorter than 9 characters!');
               elseif L < 8 & L > 0
                  for ii = 1:(8-L)  % add spaces to newsub to get sub-
                                    % folder name of 8 characters.
                                    % -------------------------------
                     newname = [newname ' '];
                  end
               end

               % Add new folder entry to tree, stored in subdirs.
               % ------------------------------------------------
               if ready1 ~= 1
                  subdirs = [subdirs; newname];
               end

               [m,n] = size(subdirs); % To prevent errors when subfolder-
                                      % enhancement code is called again
                                      % directly after finishing THIS
                                      % subdir-enhancement.
            end

         elseif opt == 4    % Ready, current Matlabpath extension is ok.
                            % ------------------------------------------
            disp(' ');
            disp(' ');

            % Last check of the Matlabpath extension...
            % -----------------------------------------
            disp('Current Matlabpath-extension for the FDC toolbox:');
            disp(' ');
            disp(['FDC Root folder:    ', rootdir]);
            disp(' ');
            disp(['FDC Subfolders:     ', subdirs(1,:)]);
            [m,n] = size(subdirs);

            for i = 2:m
               disp(['                    ', subdirs(i,:)]);
            end

            disp(' ');
            answ3 = input('Path ok ([y]/n)? ','s');
            if isempty(answ3)
               answ3 = 'y';
            end
            if answ3 == 'y'
               % Now we finally know for sure that tree is correct...
               % ----------------------------------------------------
               ready = 1;
            end

         end

      end  % of while-loop (loop is left if ready = 1).

      % Save results to FDCINIT.INI file.
      % ---------------------------------
      save fdcinit.ini rootdir subdirs suppress

   elseif answ == 's'

      % The displayed path should now be correct, but checking anyway
      % -------------------------------------------------------------
      if exist(rootdir) ~= 7
         h = errordlg('Specified root-directory does not exist! Check installation, and re-run FDC.M - the results are not correct!');
         uiwait(h);
         clear h
         errorflag = 1;

      else

         % Don't change Matlabpath extension, and don't display the "Is this
         % correct?" message anymore in the future.
         % ------------------------------------------------------------------
         disp(' ');
         disp('If you select this option, the current setting for the Matlab-');
         disp('path-extension for the FDC toolbox will be used for ALL future');
         disp('sessions. The path-definition can only be changed with FDCINIT');
         disp('again after deleting the file FDCINIT.INI from the FDC root-');
         disp('folder!');
         disp(' ');
         disp('So: are you sure you want to suppress the FDC path-verification');
         disp('for future sessions ([y]/n)?');
         disp(' ');
         answ1 = input('?> ','s');
         if isempty(answ1)
            answ1 = 'y';
         end
         if answ1 == 'y'
            disp(' ');
            disp('So be it...');
            disp(' ');
            disp('<<< Press a key >>>');
            pause

            % Change suppress to 1, to make sure that the folder tree in
            % FDCINIT.INI will be used as Matlabpath extension from now on
            % (every time FDCINIT is started).
            % ------------------------------------------------------------
            suppress = 1;

            % Save results to FDCINIT.INI file.
            % ---------------------------------
            save fdcinit.ini rootdir subdirs suppress
         end
      end

   else  % Current path setting is correct... but checking anyway!

      if exist(rootdir) ~= 7
         h = errordlg('Specified root-directory does not exist! Check installation, and re-run FDC.M - the results are not correct!');
         uiwait(h);
         clear h
         errorflag = 1;
      end

      if exist('fdcinit.ini') == 0

         % Save results to FDCINIT.INI file. This is not necessary if
         % FDCINIT.INI already exists, since the current setting will
         % be used.
         % ----------------------------------------------------------
         save fdcinit.ini rootdir subdirs suppress

      end
   end
end

% Add new folders to Matlabpath. Include the FDC root-folder itself only
% if it doesn't exist already. (If the user follows the installation
% guidelines, the FDC root-folder will be added to the default definition
% of the Matlabpath, while the FDC subfolders are added by FDCINIT.
% Duplicate names in the Matlabpath will create warning messages, which
% are thus quite likely for the FDC root-folder but not for the subfolders.
% For this reason, checking FDC subfolders for duplicate names was NOT
% considered necessary.)
% -------------------------------------------------------------------------
if computer=='PCWIN',
   pos = findstr(lower(matlabpath),lower(rootdir));
else
   pos = findstr(matlabpath,rootdir);
end

[m,n] = size(subdirs); % Update, because subdirs may be changed.
if isempty(pos)
   path(path,rootdir);
end
for i = 1:m
   path(path,fullfile(rootdir,deblank(subdirs(i,:))));
end

if errorflag == 0
    fdc_strt;
else
    disp(' ');
    delete('fdcinit.ini');
    error('There were errors. Check your FDC root-folder and run FDC again! ');
end

% Clear all unwanted variables.
% -----------------------------
clear pathext pathtmp n m answ answ1 answ2 answ3 i ii rootdir subdirs
clear newsubs newname suppress opt ready ready1 L errorflag


%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since September 31, 1997
% =========================================
% September 31, 1997
%   - Added initialization of the variable pathtmp for Matlab 5 compatibility
% October 5, 1997
%   - Changed keyboard input routines to prevent Matlab 5 warnings about
%     (possibly) empty string variables
% October 7, 1997
%   - Changed terminology: 'directory' is now called 'folder' (except for the
%     variables 'subdirs', which was maintained for compatibility reasons)
%   - Generalized the code to improve portability of the code to non-Windows
%     versions of Matlab
% October 10, 1997
%   - Editorial changes; show new on-line help-instructions after initializing
%   - Included root-folder check after user specifies that path is correct
%   - Discouraged path-changes for new users
% October 12, 1997
%   - Created graphically more appealing welcome message (see FDC_WELC.M)
%   - Created menu which guides the user to FDCLIB and on-line help-texts after
%     initializing the toolbox (see FDC_STRT.M)
% February 7, 1998
%   - FDCINIT does not show folder-structure anymore if the user has selected
%     the 'Suppress' option during an earlier FDC session
%   - Choosing the option 'S' (suppress) during the folder-check will now produce
%     an error message if the root-folder is not correct i.s.o. accept the wrong
%     entry
%   - FDC root-folder is not added to the Matlabpath anymore if it already exists
%     in the default Matlabpath definition
%   - Several editorial changes
% June 15, 1998
%   - Added path-comment for SR1 version of FDC 1.3
% June 12, 2000
%   - Editorial change to prevent path problems when upper-case characters are
%     applied in directory names
%   - New path extension commands allow the use of spaces within directory-names
%     (but other FDC files have not yet been updated, so it doesn't work yet!)