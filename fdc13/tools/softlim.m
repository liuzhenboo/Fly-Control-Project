function [y,x0] = softlim(t,x,u,flag,max_u,lin_u)
% --------------------------------------------------------------------
% Soft-limiter with partly linear throughput. This M-file is called
% by the graphical Soft-limiter block in the TOOLS-library of the FDC
% toolbox. S-function format was used to be able to use additional
% parameters in function call:
%
% function [y,x0] = softlim(t,x,u,flag,max_u,lin_u)
%
% Input : u = unlimited signal
% Output: y = limited signal
%
% Parameters:
%   max_u, defines limiter range (output lies between max_u and -max_u)
%   lin_u, defines range where throughput of the limiter is linear
%          (works only if lin_u < max_u!)
%
% Other function arguments:
%   t   : time (not used)
%   x   : state vector (not used)
%   flag: defines which outputs are returned by the S-function; SOFTLIM
%         returns the S-function properties if flag==0 and if flag==3
%         the output y is returned (other values of flag neglected).
% ---------------------------------------------------------------------

nargs = nargin;
if nargs == 0    % No input arguments: display help text for SOFTLIM
   help softlim
else
   % compute output if flag is equal to 3, initialize S-function if flag == 0,
   % do not return anything for other values of flag.
   if flag == 3
      sp0 = max(-lin_u , min(u,lin_u));
      sp1 = u - sp0;
      y = sp0 + sp1*(max_u-lin_u)/(abs(sp1)+(max_u-lin_u));
   elseif flag == 0
      if lin_u >= max_u
         error('Linear range must be smaller than max. limiter range!')
      end
      x0 = [];
      y  = [0 0 1 1 0 1];
   else
      y = [];
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
