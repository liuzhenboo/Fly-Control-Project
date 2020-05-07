function [prop,eigA]=systprop(A,B,C,D)
% SYSTPROP Computes the following properties of a linear system:
%
%          1. time constant                             tau
%          2. natural frequency of undamped system      w0
%          3. eigenfrequency of the system              wn
%          4. period                                    P
%          5. damping factor                            zeta
%          6. percentage overshoot                      PO
%          7. peak-time                                 Tpeak
%          8. settling time                             Tset
%          9. halve-time                                Thalve
%
% Conclusions are displayed on screen and stored in the file SYSTPROP.DAT.
%
% [X,Y] = SYSTPROP(A,B,C,D) or [X,Y] = SYSTPROP(A) returns the system
% properties in the matrix X and the eigenvalues of A in the columnvector Y.
%
% The colums of the matrix X correspond with the system properties 1 through 9
% in the table above. If the elements of the D matrix are all zero, D doesn't
% have to be entered; in that case [X,Y] = SYSTPROP(A,B,C) is accepted too.
%
%    X = [tau, w0, wn, P, zeta, PO, Tpeak, Tset, Thalve]
%
% [X,Y] = SYSTPROP(num,den) evaluates the equivalent transfer function
% representation.
%
% X = SYSTPROP(Y) returns X if Y contains the eigenvalues of a system in a
% columnvector.
%
% See also DAMP, CTRB, OBSV.


% ---------------------------------------------------------------------
% REFERENCE: J. van de Vegte, 'Feedback Control Systems', Prentice Hall
%            International Editions, London, 2nd edition, 1990.
% ---------------------------------------------------------------------


clc

% Disable Matlab warning messages. Since the release of Matlab 5 a lot of
% warnings appeared, which were quite harmless, but very inconvenient for
% the output of this routine.
% -----------------------------------------------------------------------
warning off

% Go to the default FDC data-directory IF that directory can be found; else,
% stay in the current working directory. Store the current directory in the
% variable 'workingdir' in order to be able to return there later. (This
% ensures that the results, which are stored in SYSTPROP.DAT by means of the
% DIARY function, are sent to the appropriate data-directory whenever possible.
% See DATADIR.M and FDCDIR.M for more details.)
% ----------------------------------------------------------------------------
workingdir = pwd;
defdir = feval('datadir');
eval(['chdir ',defdir,';'],['chdir ',workingdir,';']);

nargs=nargin;

if nargs == 0                % No inputs: return help information only
   help systprop

else                         % SYSTPROP called with inputs: compute system
   diary systprop.dat        % properties and store them in file SYSTPROP.DAT


   if nargs >= 3             % Three or four inputs: system matrices of a
                             % linear state-space system

      if nargs == 3;         % No D matrix specified
         [m1,n1] = size(B);
         [m2,n2] = size(C);
         D = zeros(m2,n1);   % Create loose D-matrix (all elements equal
                      % to zero)
      end

      % Display type of input for SYSTPROP.DAT diary-file
      % -------------------------------------------------
      disp('Linear state-space system:');
      A,B,C,D
      disp(' ');

      error(abcdchk(A,B,C,D)); % Check dimensions of system matrices.

      % Determine controllability and observability of the system
      % ---------------------------------------------------------
      Co = ctrb(A,B);
      Ob = obsv(A,C);
      rankA = rank(A);
      disp(' ');
      disp(' ');
      if rank(Co) == rankA & rank(Ob) == rankA
         disp('System is controllable and observable.');
      elseif rank(Co) == rankA
         disp('System is controllable.');
      elseif rank(Ob) == rankA
         disp('System is observable.');
      else
         disp('System is neither controllable nor observable');
      end;

      eigA = eig(A);           % Determine eigenvalues of the system matrix A.

   elseif nargs == 1           % Only one input: system matrix A or vector
                               % with eigenvalues Y. Scalar input is always
                               % treated as a single eigenvalue so if you
                               % actually want to input an 1x1 matrix A you
                               % must define the matrices B, C, and D too,
                               % for instance: SYSTPROP(A,0,0,0).
      [m,n] = size(A);

      if n==1                  % Treat input A as a vector with eigenvalues.

        % Display type of input for SYSTPROP.DAT diary-file
       % -------------------------------------------------
         Y = A;
        disp('Vector with eigenvalues:');
         Y
        disp(' ');

         eigA = A;
      elseif m == n            % Treat input A as state matrix.

        % Display type of input for SYSTPROP.DAT diary-file
       % -------------------------------------------------
         disp('System matrix:');
         A
        disp(' ');

         eigA = eig(A);        % Determine eigenvalues of the system matrix A.
      else
         error('Error:  Input incorrect for SYSTPROP')
      end

   elseif nargs == 2           % Two inputs: numerator and denominator of
                               % transfer function. Treat input A as vector
                               % with coefficients of the numerator (A = num)
                               % and B as vector with coefficients of the
                               % denominator (B = den).

      % Display type of input for SYSTPROP.DAT diary-file
      % -------------------------------------------------
      num = A;
    den = B;
      disp('Transfer function:');
    num,den
      disp(' ');

      eigA = roots(B);
      eigB = roots(A);
      if max(sign(eigB)) == 1
         disp('Poles found in right half-plane => non-minimum phase system.')
      elseif max(sign(eigB)) == -1
         disp('All poles in left half-plane => minimum phase system.')
      end

   else                        % More than four inputs: not correct.

      error('Error: too many inputs for SYSTPROP')
   end

   [m,n] = size(eigA);

   for i = 1:1:m
      ra = real(eigA(i,1));    % Real parts of the eigenvalues
      ia = imag(eigA(i,1));    % Imaginary parts of the eigenvalues

      prop(i,9) =  log(0.5)/ra;          % halve time [s]
      prop(i,1) = -1/ra;                 % time constant [s]
      prop(i,2) =  abs(eigA(i,1));       % undamped natural frequency [rad/s]
      prop(i,5) = -ra/prop(i,2);         % damping coefficient [-]
      prop(i,8) =  4*prop(i,1);          % settling time [s]

%    prop(i,10) = -2*ra/(ra^2 + ia^2);  % time step upper limit for Euler method stability [s]

      if ia ~= 0               % Non-zero imaginary part of the eigenvalues:
                               % determine properties of oscillatory signals.

         prop(i,3)= prop(i,2)*sqrt(1-prop(i,5)^2);  % eigenfrequency [rad]
         prop(i,4)= abs(2*pi/prop(i,3));            % period [s]
         prop(i,7)= pi/prop(i,3);                   % peak time[s]
      else
         prop(i,3)= 0;
         prop(i,4)= inf;       % non-oscillatory behaviour: period is infinite
         prop(i,7)= inf;       % and the peak time too (????)
      end
      if prop(i,5) ~= 1        % non-zero damping coefficient
         prop(i,8) = 100*exp(-pi*prop(i,4)/sqrt(1-prop(i,4))); % overshoot [%]
      end

      % Analyze the results (categorize the characteristic responses for
      % the different eigenvalues into corresponding 'system modes' as a
      % function of the eigenvalues)
      %-----------------------------------------------------------------
      if ia == 0 & ra < 0;
         mode ='stable, non-oscillatory';
      elseif ia == 0 & ra > 0;
         mode ='unstable, non-oscillatory';
      elseif ia ~= 0 & ra < 0;
         mode ='stable, oscillatory';
      elseif ia ~= 0 & ra > 0 | prop(i,5) < 0 & prop(i,5) > -1;
         mode ='unstable, oscillatory';
      elseif prop(i,5) == 1 | ra == 0;
         mode ='critically damped, indifferent';
      elseif prop(i,5) < -1;
         mode ='unstable, non-oscillatory';
      elseif prop(i,5) > 1;
         mode ='non-oscillatory';
      else;
         mode ='unknown (!!)';
      end;
      if ia == 0;
         disp(['Mode ' num2str(i) ' is ' mode ' with eigenvalue: ' num2str(ra) ])
      elseif ia < 0
         disp(['Mode ' num2str(i) ' is ' mode ' with eigenvalue: ' num2str(ra) ' ' num2str(ia) 'i'])
      else
         disp(['Mode ' num2str(i) ' is ' mode ' with eigenvalue: ' num2str(ra) ' +' num2str(ia) 'i'])
      end
   end
   disp(' ')
   diary off
   disp('<<< Press a key to continue >>>');
   pause
   clc
   diary on

   % In the following lines the routine NUM2STR2 is called in stead of
   % the standard Matlab routine NUM2STR in order to obtain better screen
   % formatting.
   %---------------------------------------------------------------------
   if m == 1
      disp('                          Mode 1')
      disp('                          ======')
      disp(['Time constant       :   ' num2str2(prop(1,1),8) '   [s]']);
      disp(['Undamped nat. freq. :   ' num2str2(prop(1,2),8) '   [rad/s]']);
      disp(['Eigenfrequency      :   ' num2str2(prop(1,3),8) '   [rad/s]']);
      disp(['Period              :   ' num2str2(prop(1,4),8) '   [s]']);
      disp(['Damping coefficient :   ' num2str2(prop(1,5),8) '   [-]']);
      disp(['Overshoot           :   ' num2str2(prop(1,6),8) '   [%]']);
      disp(['Peak time           :   ' num2str2(prop(1,7),8) '   [s]']);
      disp(['Settling time       :   ' num2str2(prop(1,8),8) '   [s]']);
      disp(['Halve time          :   ' num2str2(prop(1,9),8) '   [s]']);
   elseif m == 2
      disp('                          Mode 1       Mode 2')
      disp('                          ======       ======')
      disp(['Time constant       :   ' num2str2(prop(1,1),8) '     ' num2str2(prop(2,1),8) '   [s]']);
      disp(['Natural frequency   :   ' num2str2(prop(1,2),8) '     ' num2str2(prop(2,2),8) '   [rad/s]']);
      disp(['Eigenfrequency      :   ' num2str2(prop(1,3),8) '     ' num2str2(prop(2,3),8) '   [rad/s]']);
      disp(['Period              :   ' num2str2(prop(1,4),8) '     ' num2str2(prop(2,4),8) '   [s]']);
      disp(['Damping coefficient :   ' num2str2(prop(1,5),8) '     ' num2str2(prop(2,5),8) '   [-]']);
      disp(['Overshoot           :   ' num2str2(prop(1,6),8) '     ' num2str2(prop(2,6),8) '   [%]']);
      disp(['Peak time           :   ' num2str2(prop(1,7),8) '     ' num2str2(prop(2,7),8) '   [s]']);
      disp(['Settling time       :   ' num2str2(prop(1,8),8) '     ' num2str2(prop(2,8),8) '   [s]']);
      disp(['Halve time          :   ' num2str2(prop(1,9),8) '     ' num2str2(prop(2,9),8) '   [s]']);
   elseif m == 3
      disp('                          Mode 1       Mode 2       Mode 3')
      disp('                          ======       ======       ======')
      disp(['Time constant       :   ' num2str2(prop(1,1),8) '     ' num2str2(prop(2,1),8) '     ' num2str2(prop(3,1),8) '   [s]']);
      disp(['Natural frequency   :   ' num2str2(prop(1,2),8) '     ' num2str2(prop(2,2),8) '     ' num2str2(prop(3,2),8) '   [rad/s]']);
      disp(['Eigen frequency     :   ' num2str2(prop(1,3),8) '     ' num2str2(prop(2,3),8) '     ' num2str2(prop(3,3),8) '   [rad/s]']);
      disp(['Period              :   ' num2str2(prop(1,4),8) '     ' num2str2(prop(2,4),8) '     ' num2str2(prop(3,4),8) '   [s]']);
      disp(['Damping coefficient :   ' num2str2(prop(1,5),8) '     ' num2str2(prop(2,5),8) '     ' num2str2(prop(3,5),8) '   [-]']);
      disp(['Overshoot           :   ' num2str2(prop(1,6),8) '     ' num2str2(prop(2,6),8) '     ' num2str2(prop(3,6),8) '   [%]']);
      disp(['Peak time           :   ' num2str2(prop(1,7),8) '     ' num2str2(prop(2,7),8) '     ' num2str2(prop(3,7),8) '   [s]']);
      disp(['Settling time       :   ' num2str2(prop(1,8),8) '     ' num2str2(prop(2,8),8) '     ' num2str2(prop(3,8),8) '   [s]']);
      disp(['Halve time          :   ' num2str2(prop(1,9),8) '     ' num2str2(prop(2,9),8) '     ' num2str2(prop(3,9),8) '   [s]']);
   elseif nargs ~= 0
      disp('           tau [s]  w0 [rad/s]  wn [rad/s]       P [s]    zeta [-]')
      for i = 1:1:m
         disp(['Mode ' int2str(i) ':   ' num2str2(prop(i,1),8) '    ' num2str2(prop(i,2),8) '    ' num2str2(prop(i,3),8) '    ' num2str2(prop(i,4),8) '    ' num2str2(prop(i,5),8)])
      end
      disp(' ');
      disp('            PO [%]   Tpeak [s]    Tset [s]  Thalve [s]')
      for i=1:1:m
         disp(['Mode ' int2str(i) ':   ' num2str2(prop(n,6),8) '    ' num2str2(prop(i,7),8) '    ' num2str2(prop(n,8),8) '    ' num2str2(prop(n,9),8)])
      end
      disp(' ');
      disp('tau   : time constant                      PO    : percentage overshoot');
      disp('w0    : natural freq. of undamped system   Tpeak : peak-time');
      disp('wn    : eigenfrequency of the system       Tset  : settling-time');
      disp('P     : period                             Thalve: halve-time');
      disp('zeta  : damping factor');
   end

  disp(' ');

   diary off
   disp('<<< Press a key to continue >>>');
   disp(' ');
   pause
   clc
   diary on

   disp('Notes:')
   disp('======')
   disp('  1. Stable if all poles in left half plane of the s-plane')
   disp('  2. To avoid excessive overshoot and unduly oscillator behaviour, the')
   disp('     damping ratio must be adequate, thus the cos(pi) not too close to 90 deg.')
   disp('  3. Time constant and settling time are reduced (response speed increased)')
   disp('     by increasing the negative real part of the poles.')
   disp('  4. Undamped frequency = distance to origin, moving the poles out radially')
   disp('     increases the speed of response, thus reducing settling time, peak time')
   disp('     and rise time, while overshoot remains constant.')
   disp('  5. Natural frequency = resonant frequency.')
   disp('  6. Peak time and rise time are reduced by increasing the imaginary part')
   disp('     of the pole locations.')
   disp(' ');
   disp(' ');
   disp('Refer to source-code of SYSTPROP.M for more details about the computations.');
   disp('------------------------------------------------------------------------------');
   disp(' ');

   diary off

   disp('Ready.')
   disp(' ')
   disp('Results are available in the diary-file SYSTPROP.DAT');
end

% Return to the old working directory
% -----------------------------------
eval(['chdir ',workingdir,';']);

% Enable Matlab warning messages again
% ------------------------------------
warning on

%------------------------------------------------------------------
% Program originally written by E.A. van der Zwan in 1993; modified
% for inclusion to the FDC-toolbox by Marc Rauw in 1996.
%
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
