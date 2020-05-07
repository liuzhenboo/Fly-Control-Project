% FIRSTRUN is an initialization macro for floppy-disk distributions of
% the FDC toolbox. It must be run the first time the toolbox is used.
%
% Note: not applicable for the FDC packages distributed via Internet!

fdcrootdir = fullfile(matlabroot,'TOOLBOX','FDC13');
if exist(fdcroot) ~= 7
   errordlg('Can''t find FDC root-directory!');
else
   chdir fdcroot;
end

clc;
disp(' ');
disp(' FDC setup');
disp(' =========');
disp(' The FDC root-directory must be added to your Matlabpath.');
disp(' To do so, EDITPATH will be started after you press a key.');
disp([' Add the folder ',fdcrootdir,' to the Matlabpath']);
disp(' and make sure the results are saved for future sessions.');
disp(' ');
disp('<<< Press a key to proceed >>>');

% Call path-edit tool EDITPATH
pause
editpath

clc;
disp('   Complete the FDC setup by running FDC or FDCINIT');

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
