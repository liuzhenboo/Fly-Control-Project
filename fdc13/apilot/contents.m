% The FDC toolbox - 'Beaver' autopilot models
% ===========================================
% The directory APILOT contains Simulink models of the 'Beaver' autopilot.
% The following files are included:
%
% ACTRLOAD.M   Matlab program which is called for loading the state-space
%              matrices of the actuator & cable models of the 'Beaver'
%              from file.
%
% APILOT1.MDL  Simulation model of the 'Beaver' autopilot without radio-
%              navigation loops, sensor dynamics, wind, and atmospheric
%              turbulence models. This model contains the basic control
%              loops only, which makes the model easier to handle while
%              speeding up simulations.
%
% APILOT2.MDL  Simulation model of the 'Beaver' autopilot including radio-
%              navigation loops, but without sensor dynamics, wind, and
%              atmospheric turbulence models. Errors in the VOR and ILS
%              signals have been omitted too. This model is more complex
%              than APILOT1, but still relatively fast during simulations.
%              The performance of the radio-navigation loops can be accessed
%              here under 'ideal' circumstances.
%
% APILOT3.MDL  Simulation model of the 'Beaver' autopilot, including radio-
%              navigation loops, wind, atmospheric turbulence, sensor models,
%              and errors in the ILS and VOR signals. This model makes it
%              possible to access the performance of the 'Beaver' autopilot
%              under circumstances which are most close to the reality. Due
%              to the noisy disturbances and discontinuous 'quantized'
%              signals from some sensors, this model takes quite some time
%              to simulate and requires plenty computer memory to store
%              all results. It is, however, easy to filter out only those
%              elements from APILOT3 which are needed for a particular
%              analysis (that's how APILOT1 and APILOT2 were created too).
%
% APINIT.M     Matlab macro for initializing the autopilot simulation model
%              (loading model parameters for the aircraft model, defining
%              an initial flight condition, loading model parameters for
%              the autopilot itself, initializing ILS and VOR blocks, and
%              possibly fixing certain states from the aircraft model).
%              Concisely following all steps from the menus makes it unlikely
%              to miss crucial parameter definitions. After running APINIT,
%              use APMODE for setting the control modes of the autopilot.
%
% APMENU.M     Main menu for autopilot simulations, facilitates choosing the
%              right 'Beaver' autopilot model.
%
% APMODE.M     Matlab macro for choosing the symmetrical and asymmetrical
%              autopilot modes and setting reference values for the control
%              signals. Using APMODE to initialize these control modes
%              ensures that only valid combinations are selected and all
%              relevant reference signals are defined.
%
% GSSWITCH.M   Matlab function, called by the Mode-controller blocks in the
%              systems APILOT2 and APILOT3 to determine when the Glideslope
%              mode must switch over from 'Armed' to 'Coupled'.
%
% ILSINIT.M    Initialization file for the ILS blocks. This routine is called
%              automatically by APINIT if the ILS initialization option is
%              selected in the main menu.
%
% KPAHRAH.M    Matlab program which sets the gains for the Pitch and Roll
%              Attitude Hold simulation models PAH.M, RAH.M, and PAHRAH.M.
%
% LOCSWTCH.M   Matlab function, called by the Mode-controller blocks in the
%              systems APILOT2 and APILOT3 to determine when the Localizer
%              mode must switch over from 'Armed' to 'Coupled'.
%
% NAVSWTCH.M   Matlab function, called by the Mode-controller blocks in the
%              systems APILOT2 and APILOT3 to determine when the Navigation
%              mode must switch over from 'Armed' to 'Coupled'.
%
% PAH.M        Sample simulation model of Pitch Attitude Hold mode of the
%              'Beaver' autopilot (no turn-compensation, no computational
%              delay, no limiters)
%
% PAHRAH.M     Sample simulation model of Pitch AND Roll Attitude Hold modes
%              of the 'Beaver' autopilot (no turn-compensation, no compu-
%              tational delay, no limiters)
%
% PRAHINIT.M   Matlab macro for initializing the systems PAH, RAH, and
%              PAHRAH. Use APINIT if you want to initialize APILOT1, APILOT2,
%              or APILOT3.
%
% RAH.M        Sample simulation model of Roll Attitude Hold mode of the
%              'Beaver' autopilot (no computational delay, no limiters)
%
% VORINIT.M    Initialization file for the VOR blocks. This routine is called
%              automatically by APINIT if the VOR initialization option is
%              selected in the main menu.

%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
