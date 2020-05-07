function comment
%COMMENT        Provides succinct comments at many inconvenient places in the
%               Simulink toolbox FDC (based upon WHY.M of Matlab 386).
%               COMMENT is called by Matlab programs from the FDC toolbox
%               if they think a computation will take some time...
%               (clever eh?)

t = clock;
rand('seed',(100*t(6))^2);
clear t

resp = [
    'Time for a coffee break (at least, if you use a 386 SX)          '
	'Time flies (doesn''t it?)                                         '
	'Time to think it over!                                           '
	'Now crunching... (numbers, that is)                              '
    'Oh! How difficult! My poor CPU can hardly handle it!             '
	'(Running out of sneaky remarks... Please, have patience...)      '
	'Watch your batteries! (just kidding).                            '
	'Check: brains connected before typing?!?                         '
	'CPU running hot! (just kidding).                                 '
	'Do NOT try to recompute this by hand...                          '];
disp(' ')
disp(resp(round(rand*10+.5),:))
disp(' ')

