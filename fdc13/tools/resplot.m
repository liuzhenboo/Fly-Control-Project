% ---------------------------------------------------------------------
% RESPLOT
%
% Sample plot-macro, to be used after running RESULTS.
%
% Change the source-code of this program if you want to plot other
% results or if you are not satisfied with the current presentation of
% the results.
%
% In future versions of the FDC toolbox, this routine will be improved
% considerably.
% ---------------------------------------------------------------------

% First, close all existing figures
% ---------------------------------
close all

hold off;
clf
subplot(221); plot(time,V); grid;
xlabel('time [s]'); ylabel('V [m/s]');
subplot(222); plot(time,alpha); grid;
xlabel('time [s]'); ylabel('alpha [deg]');
subplot(223); plot(time,beta); grid;
xlabel('time [s]'); ylabel('beta [deg]');
subplot(224); plot(time,H); grid;
xlabel('time [s]'); ylabel('H [m]');
pause

clf
subplot(221); plot(time,p); grid;
xlabel('time [s]'); ylabel('p [deg/s]');
subplot(222); plot(time,q); grid;
xlabel('time [s]'); ylabel('q [deg/s]');
subplot(223); plot(time,r); grid;
xlabel('time [s]'); ylabel('r [deg/s]');
pause

clf
subplot(221); plot(time,psi); grid;
xlabel('time [s]'); ylabel('psi [deg]');
subplot(222); plot(time,theta); grid;
xlabel('time [s]'); ylabel('theta [deg]');
subplot(223); plot(time,phi); grid;
xlabel('time [s]'); ylabel('phi [deg]');
pause

clf
subplot(221); plot(time,deltae); grid;
xlabel('time [s]'); ylabel('deltae [deg]');
subplot(222); plot(time,deltaa); grid;
xlabel('time [s]'); ylabel('deltaa [deg]');
subplot(223); plot(time,deltar); grid;
xlabel('time [s]'); ylabel('deltar [deg]');
subplot(224); plot(time,uw,time,vw,time,ww); grid;
xlabel('time [s]'); ylabel('uw, vw, ww [m/s]');

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
%
% Revision history since October 7, 1997:
% =======================================
% October 7, 1997
%  - Replaced CLG commands by CLF for Matlab 5 compatibility.
