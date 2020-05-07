FDC 1.3.3                                      Revision date: May 18, 2002
=========


   #######################################################################
   ##                                                                   ##
   ##   IMPORTANT: BEFORE INSTALLING THE FDC TOOLBOX, PLEASE READ THE   ##
   ##              LICENSE INFORMATION IN LICENSE.TXT!                  ##
   ##                                                                   ##
   #######################################################################




                  FDC 1.3.3 --- A Simulink Toolbox for Flight
                        Dynamics and Control Analysis

                                 M.O. Rauw
                            (rauw@dutchroll.com)


  Haarlem, The Netherlands
  February 1998, July 1998, June 2000, May 2001, December 2001, May 2002



  ABSTRACT
  ========
  The Flight Dynamics and Control (FDC) toolbox is a graphical software
  environment for the design and analysis of aircraft dynamics and control
  systems, based upon Matlab and Simulink. It simplifies the Flight Control
  System design process by integrating linear and non-linear analysis within
  one software environment. The toolbox has been set up around a general
  non-linear aircraft model which has been constructed in a modular way,
  thus providing maximal flexibility to the user. The aircraft model can be
  accessed by means of the graphical user-interface of Simulink. The toolbox
  also includes some analytical Matlab routines for extracting steady-state
  flight conditions and determining linearized models for user-specified
  operating points, Simulink models of atmospheric disturbances and
  radio-navigation systems, extensive models of a `classical' autopilot, and
  several help-utilities which simplify the handling of the systems and
  tools.

  Keywords: Flight Control System Design, Aircraft Modeling, Non-linear
            Simulation, Computer Assisted Design



  ABOUT THE CURRENT FDC DISTRIBUTION PACKAGE
  ==========================================
  This is the third minor release of FDC 1.3, which is identical to the
  previous release (FDC 1.3 Service Release 2), except for its licensing
  terms. This version is the first to be licensed under the Dutchroll
  Open Source Software License (DOSSL), version 1.0; see LICENSE.TXT for
  more information.

  FDC 1.3.3 requires Matlab 5.1 / Simulink 2.1 or newer. If you use Matlab
  4.x / Simulink 1.x, you can use version 1.2 of the toolbox, which is also
  available via the FDC homepage (see below). FDC 1.3.3 has also been tested
  successfully with Matlab 5.3 / Simulink 3.0 and Matlab 6.0 / Simulink 4.0.
  If you encounter any problems with newer Matlab versions, please let me
  know. Any suggestions for further improvements are also welcome; the
  contact address is given at the bottom of this document. FDC 1.3.3 has
  been stored in the file FDC13-3.ZIP.

  Detailed documentation for this particular version is not available, but
  the user-manual for the previous FDC version (1.2) will be of great help.
  This user-manual is available in PostScript and PDF format via the FDC home-
  page (see below).

  FDC 1.3.3 includes HTML-based help-texts for on-line assistance, which will
  also help to get you started. If you are able to access the 'Matlab Help
  Desk' from your copy of Matlab, the HTML help-function for FDC 1.3 should
  work correctly as well.


  Installing the FDC toolbox
  ==========================
  Note: the path-notations in this section are in Windows 9x format. Replace
  this by the appropriate format for other operating systems.

  1. Copy the file FDC13-3.ZIP to a temporary directory.

  2. Unpack FDC13-3.ZIP to a suitable destination directory. It is recommended
     to create a subdirectory (subdirectory) FDC13 in the TOOLBOX directory of
     Matlab and use this as destination for FDC 1.3.3. For example, if
     you have installed Matlab in the directory C:\MATLAB, the recommended
     destination for FDC 1.3 SR2 will be C:\MATLAB\TOOLBOX\FDC13). It is
     necessary to retain the FDC directory structure when unpacking. For
     instance, if you use PKUNZIP for MS-DOS, this can be done by including
     the -d option to the pkunzip command-line. Other unpack routines, such
     as Winzip, will probably do this automatically.

     NOTE: when unpacked, FDC 1.3.3 requires about 4.8 Mbytes of disk space!

  3. Now start Matlab 5.1 (or later). The Matlab search path should now be
     enhanced with the FDC directories. It is recommended to add the FDC root-
     directory to the Matlab path permanently, since this simplifies future use.
     This can be done with the Matlab utility EDITPATH.M. If you followed
     the recommendations above, the FDC root-directory will be something like
     C:\MATLAB\TOOLBOX\FDC13. NOTE: FDC 1.3.3 does NOT support directory
     names that contain spaces! Therefore, if you have installed Matlab to
     C:\Program Files\Matlab, it is recommended to install FDC 1.3.3 into
     C:\FDC13 or any other directory that does not contain spaces. Select
     this directory and select 'Add to path', 'Add to back', and 'OK'. Next,
     select 'Save settings' to make this a permanent change. (Alternatively,
     if you don't want to have the FDC root-directory permanently saved to the
     search-path, use the CHDIR command to go to this root-directory, e.g.:
     chdir c:\matlab\toolbox\fdc13, and proceed with the following step.)

  4. Run FDC.M. After some welcome messages, this routine will initialize
     the FDC toolbox and enhance the search-path with the remaining FDC
     subdirectories. You will be asked to check whether the FDC path is
     correct. In practice, only the FDC root-directory may be faulty,
     especially if you did not install the toolbox to the \matlab\toolbox\fdc13
     directory. So pay special attention to the FDC root-directory. If you are
     convinced that everything is allright, and if you're not planning to
     change anything in the nearby future, press 'S' to suppress the
     directory-check for future FDC sessions.

  5. The toolbox has now been installed completely. You now have the option
     to go to the main FDC library, view the HTML-based help texts, or view
     the contents of the toolbox-directories. The last option will show ALL
     Matlab toolboxes, not only FDC 1.3.3 - double-clicking the directory
     names will yield  more information about their contents. If you don't
     want any of these options, choose 'Cancel'. Opening the FDC library is
     then still possible by typing 'fdclib' (without the quotes) at the
     Matlab command-line, and the index-page of the HTML help-texts can be
     accessed by typing 'fdchelp index' at the command-line.

     It is recommended to view the *.TXT files in the subdirectory DOC for
     more information:

      CONTENTS.TXT    gives a complete overview of the files from FDC 1.3
      HISTORY.TXT     gives an overview of the FDC development since the
                        very fist version
      LICENSE.TXT     license agreement
      README1.TXT     this file
      README2.TXT     gives some background information about compatibility
                        problems you may encounter when upgrading from a
                        previous version of the FDC toolbox
      SUPPORT.TXT     gives information about the user-support for FDC 1.3
      WHATSNEW.TXT    lists the new features in FDC 1.3

  6. If you use Matlab 5.2 / Simulink 2.2 (i.e. release 10), or newer, you will
     probably receive the following warning message when you try to open any
     Simulink system from the FDC toolbox:

        Warning: Run 'slupdate('[system name]')' to convert the block diagram
        to the format of the current version of Simulink

     To eliminate this warning in future FDC sessions, you should simply
     follow the instruction in the warning message: after opening the system,
     run 'slupdate', and save the system directly thereafter. If you re-open
     the system later, the warning message will be gone. Notice that you may
     also receive warning messages from some of the Matlab programs from the
     FDC toolbox if you use Matlab 5.2 or newer. You can turn off the warning
     messages with the 'warning off' command, but it is recommended to take
     appropriate action, as indicated in the warning message itself. However,
     warning messages are different from error messages, in that they don't
     stop program execution and don't affect the results.

  7. Visit http://www.dutchroll.com/problems.html to view a list of known
     issues for the FDC toolbox. See http://www.dutchroll.com/faq.html for
     a list of frequently asked questions. (Note: if these addresses do not
     work correctly, check out http://www.dutchroll.com itself.)

  8. Before each next FDC session, it is necessary to run FDC.M again, in
     order to obtain the appropriate path-enhancement. If you used EDITPATH
     in step 3 as prescribed, just type fdc at the command-line after starting
     Matlab. Otherwise, go to the fdc root-directory first, and then type fdc.
     If you use the FDC toolbox often, it may be useful to permanently add the
     FDC directories to the Matlab path. This includes the FDC root-directory,
     plus the following subdirectories:

      \AIRCRAFT
      \APILOT
      \DATA
      \EXAMPLES
      \HELP
      \NAVIGATE
      \TOOLS
      \WIND

     (adding \DOC is not really necessary). If these directories are available
     in the Matlab path, it it no longer necessary to run FDC.M before an FDC
     session. In that case, the main menu can be opened by typing

       fdc_strt

     at the Matlab command prompt.


  Uninstalling the FDC toolbox
  ============================
  Although there is no uninstall utility for this toolbox, the process is
  simple: just delete the entire FDC 1.3 directory, including all sub-
  directories. If you have added the FDC directories to your Matlab path,
  do not forget to delete them from the path definition file after
  uninstalling the toolbox.


  The FDC 1.2 user-manual
  =======================
  As said before, there is no documentation for FDC 1.3. However, the
  user-manual for FDC 1.2 still provides a very valuable source of infor-
  mation. The changes in FDC version 1.3 mainly concern the user-interface
  and on-line help-functions, while the structure of all models, as well
  as the theoretical backgrounds have not changed since version 1.2.
  Disregard the installation instructions in the report, apply the in-
  structions from this README-file instead, and check out the other *.TXT
  files and on-line documentation to learn more about the differences
  between FDC 1.2 and FDC 1.3. As a rule of thumb: if the information in
  the on-line documentation differs from that in the user-manual, the
  on-line version is probably right. :)

  The user-manual can be obtained in PostScript or PDF format via the
  download page of the FDC website: http://download.dutchroll.com (follow
  the link to the FDC 1.2 user-manual; check out http://www.dutchroll.com
  itself if the download link doesn't work). Note: it is not necessary to
  download FDC 1.2 itself, unless you really need a Matlab 4 version of
  the FDC toolbox. If you use Matlab 5.1 and Simulink 2.1 or newer, it
  would be a waste of time and source of frustration to download FDC
  version 1.2, because it is not compatible with Matlab 5/Simulink 2 and
  newer.


  Possible problems and how to solve them
  =======================================

   Missing block diagrams?!?
   -------------------------
   All graphical Simulink models were created under a screen-resolution
   of 800x600 pixels. In order to prevent them from being hidden for
   users who run Simulink under a lower screen-resolution, the block-
   diagrams have been positioned in the upper-left corner of the
   screen. However, there is still a chance that one or more systems
   have slipped through this positioning process. So if you don't see
   anything appearing when you open a graphical system or double-click
   a subsystem block, try using the 'tile' or 'cascade' options of MS
   Windows. It is likely that this will reveal the 'missing' block-
   diagrams.

   Nothing happens?!?
   ------------------
   Sometimes, if you double-click a title-block in a graphical Simulink
   system, or press a button of a graphical user menu, it may seem that
   nothing happens. In that case, check out the command window! It is
   very likely that the program expects you to enter something in there.
   If your screen is large enough, it is recommended to keep the command
   window constantly in view to solve this problem. Unfortunately,
   Simulink does not automatically activate the command window if
   something is displayed in there. In future versions of the FDC toolbox
   I will try to avoid using the command-window as much as possible...


  Other known problems
  ====================
  An up-to-date list of know problems can be found at:
  http://problems.dutchroll.com. (Check out http://www.dutchroll.com if
  that link doesn't work.)


  Copying
  =======
  The FDC toolbox may be copied freely under the restrictions put forward
  in LICENCE.TXT, which can be found in the subdirectory DOC of the toolbox.


  Getting started with open-loop simulations of the `Beaver'
  ==========================================================
  If you want to make an open-loop simulation of the `Beaver', proceed as
  follows:

  1. Open the system OLOOP1 by typing oloop1 at the command-line, or by
     double-clicking its 'button-block' in the main FDC library FDCLIB.
     Notice that by default it contains a block-shaped input to the elevator,
     which allows us to monitor the short-period and phugoid motions of the
     aircraft.

  2. Double-click the 'LOADER' button to retrieve the model parameters.
     In the list-box that will be displayed, select the file AIRCRAFT.DAT.

   3. Double-click the 'INCOLOAD' button and select the option 'Load trimmed
      flight condition'. A list-box will be opened, containing all files with
      extension TRI. A file-name like 'CR4520.TRI' means: a wings-level steady-
      state flight condition in CRuise flight at 45 m/s and flightlevel 20
      (2000 ft). So, for instance, select for instance CR4520.TRI.

   4. Start the simulation. One of the output variables from the aircraft model
      will be plotted automatically, others may be shown after the simulation
      has finished (which is after having determined the aircraft motions for
      a period of 120 seconds after applying the block-input).

   5. Double-click the button RESULTS. This will open a Matlab macro that runs
      in the command-window. Select the angles to be expressed in degrees and
      the angular velocities to be expressed in degrees per second. The time-
      trajectories of all outputs have now been converted to vectors in the
      Matlab workspace with self-explaining variable-names. They can be plotted
      with commands like:

         plot(time,alpha);
         plot(time,p);
         plot(time,Hdot);
         plot(time,deltae);

      and so on. Or run the plotting-macro RESPLOT by typing:

         resplot

      at the command-line. See the user manual for more information.


  Contact Address
  ===============
  For feedback or questions about the FDC toolbox, contact the author at
  rauw@dutchroll.com, or fill in the feedback form on the FDC website, at:
  http://contact.dutchroll.com.

  The FDC homepage can be found at: http://www.dutchroll.com

                                      -oOo-



---------------------------------------------------------------------
The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
This software is licensed under the Dutchroll Open Source Software
License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
for detailed information.
