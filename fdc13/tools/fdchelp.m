function fdchelp(name)
% FDCHELP displays an HTML help-text from the FDC subdirectory HELP in your
% web-browser. This routine is called by several graphical Simulink systems
% from the FDC toolbox.
%
% FDCHELP NAME displays the help-text for the block NAME. This only functions
% properly if the file NAME.HTM exists in the FDC subdirectory HELP.
%
% Note: the current HTML help-pages were tested for MS Internet Explorer 3.0.
% If you use a different browser, the lay-out may be affected negatively.
% Under some circumstances it may be necessary to open your web-browser
% manually before using FDCHELP (if that is the case it is also necessary for
% viewing the HTML-based help files from the Matlab Helpdesk).

% Variables
% ---------
% subdirectory    used to store the complete path of the FDC subdirectory HELP
% filename        used to store the complete path of the required help-file
% browsercall     creates complete call to browser with the WEB command


% If no input arguments are specified, display the help-text
% for FDCHELP itself in the Matlab command-window.
% ----------------------------------------------------------
if nargin == 0
   help fdchelp
else

   % Determine the path of the subdirectory HELP (see HELPDIR for more
   % details). Also determine the filename of the helpfile, including
   % its path.
   % -----------------------------------------------------------------
   subdirectory = helpdir;
   filename     = [subdirectory filesep name '.htm'];
   browsercall=['web file:' filename ';'];

   % Check whether the filename exists or not. If it can't be found,
   % display an error message.
   % ---------------------------------------------------------------
   if exist(filename) ~= 2
      errordlg(' ERROR: THE SPECIFIED HELPFILE DOES NOT EXIST!');
   else
      eval(browsercall);
   end
end

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 4, 1997:
% =======================================
% October 4, 1997:
%   - Replaced old FDCHELP, which showed ASCII help-texts in graphical window
%     with HTML-based implementation. This new version requires a web-browser
% October 7, 1997:
%   - Editorial changes
% June 12, 2000:
%   - Enhanced support for non-Windows operating systems