function t = num2str2(x,chars)
%-------------------------------------------------------------------------
% NUM2STR2
% ========
% Number to string conversion. Contrary to the Matlab routine NUM2STR,
% this version makes it possible to specify the number of characters
% for the string representation.
%
% T = NUM2STR2(X,C) returns a string T with C characters. In general, the
% number of decimal places will be equal to C - 2 (= number of characters
% minus space reserved for possible signs or decimal points). If a number
% does not fit, it is rounded to a value which does fit in C characters.
% If necessary, an exponent will be created, still within the reserved
% space of C characters. In that case the number of decimal places will
% be reduced (an exponent typically takes four characters, e.g. E+25).
%
% Note: values of C smaller than 6 are not accepted and automatically
% converted to C = 6! This prevents problems that may occur when trying
% to show very large numbers in too few characters. However, you may
% still encounter strange results if you reserve a very small space for
% large numbers.
%
% T = NUM2STR2(X) returns a string T with 6 characters.
%-------------------------------------------------------------------------

nargs = nargin;
if nargs == 0;
   help num2str2
else
   if nargs == 1; % number of characters not specified; use standard value 4
      chars=6;
   end;

   if isstr(x);       % already a string
      t = x;
      if length(t) > chars
         disp(' ')
         disp('Warning:   String-input for NUM2STR2 longer than specified');
         disp('=======    number of characters!');
      end
   else;
      % Reserve a field of length chars for (chars - 2) decimal places
      % (i.e. reserving space for possible decimal point and an optional
      % + or - sign). Convert values of chars smaller than 6 to chars = 6.
      %-------------------------------------------------------------------
      chars = max(chars,6);
      decimal = chars - 2;
      t = sprintf(['%',sprintf('%g',chars),'.',sprintf('%g',decimal),'g'],x);

      % Determine length of string representation of x.
      %------------------------------------------------
      n = length(t);

      % If the actual length of the string is smaller than the specified
      % number of chars fill remaining fields with spaces (ASCII code 32).
      %-------------------------------------------------------------------
      if n < chars;
         t = [32*ones(1,(chars-n)) t];
      elseif n > chars;
         % Decrease number of decimal places to fit the number in a string of
         % 'chars' characters.
         %-------------------------------------------------------------------
         decimal = decimal - (n-chars);
         while n > chars
            t = sprintf(['%',sprintf('%g',chars),'.',sprintf('%g',decimal),'g'],x);
            n = length(t);

            % If the user specifies very odd combinations of the number x and
            % the number of characters it is possible that this loop goes on
            % forever. Therefore quit the loop with an error-message if the
            % value of decimal becomes too small (at least one decimal place
            % needed).
            %----------------------------------------------------------------
            if decimal < 1
               error('Error! Probably too little space reserved for the number.');
            end

            decimal = decimal - 1;
         end
      end
   end
end

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
