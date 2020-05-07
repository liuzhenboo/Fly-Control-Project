Compatibility issues on FDC 1.3
===============================
FDC 1.3 was created on a Pentium 133 PC, using Matlab for Windows version
5.1 and Simulink version 2.1 and Windows 95. The programs do not function
under previous versions of Matlab/Simulink.

Previous versions are:

* 'FDC 1.0' for Matlab 3.5/Simulink 1.2 (nameless predecessor of the other
   FDC versions; available on request only)

* 'FDC 1.1' (a.k.a. BEAST 1.1 beta) for Matlab 3.5/Simulink 1.2 (available
   on request only)

* FDC 1.2 for Matlab 4.2 / Simulink 1.3 (available via www.dutchroll.com)

FDC 1.3 has been tested successfully with Matlab 5.3 / Simulink 3.0 and
Matlab 6.0 / Simulink 4.0.

If you have created Simulink systems which themselves call systems from
FDC 1.1 or FDC 1.2, it should be possible to apply those systems in
conjuction with FDC 1.3. However, your systems may be affected by
compatibility problems caused by Matlab itself! The most important one:
Matlab 5.x / Simulink 2.x don't support calling graphical systems with an
S-function block anymore. The only way to find out whether or not your
custom-made systems for FDC 1.1 / 1.2 function properly with FDC 1.3 is to
try. It is advised NOT to mix-up the files from the FDC 1.3 distribution
diskette with older versions in order to avoid compatibility problems for
the toolbox itself.

Regarding the HTML-based on-line help facility: users of Netscape Commu-
nicator 4.0 should keep a copy of this browser running in the background,
since Matlab 5.1 is not able to open it by itself when required. This
problem does not affect older versions of Netscape and Microsoft Internet
Explorer, and presumably the problem has been solved with newer versions
of Matlab. The helpfiles themselves don't use any advanced HTML options,
so they should be useable in any modern webbrowser (they should even work
with primitive browsers such as Lynx and Netscape 2).

---------------------------------------------------------------------
The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
This software is licensed under the Dutchroll Open Source Software
License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
for detailed information.
