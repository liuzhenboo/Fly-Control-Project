function recover(systname)
%-------------------------------------------------------------------
% RECOVER('SFUNC') makes one call to the Simulink system SFUNC, to
% recover simulation results which are 'lost' due to a bug in
% Simulink version 1.2c (I don't know if this bug exists for newer
% versions of Simulink). This bug apparantly prevents results to
% be transferred to the Workspace when using 'To Workspace' blocks
% in graphical systems. Re-initializing the system helps restoring
% the 'lost' results, without repeating the simulation itself.
%-------------------------------------------------------------------

sfunctioncall = [systname,'([],[],[],0);'];
eval(sfunctioncall);

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
