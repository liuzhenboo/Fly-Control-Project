function fdc_strt()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

load fdc_strt

a = figure('Color',[0.9 0.88 0.88], ...
	'Colormap',mat0, ...
	'MenuBar','none', ...
	'NumberTitle','off', ...
	'PointerShapeCData',mat1, ...
	'Position',[193 247 459 265], ...
	'Tag','Fig1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.9 0.88 0.88], ...
	'FontSize',12, ...
	'FontWeight','bold', ...
	'Position',[14.25 159 322.5 30.75], ...
	'String',mat2, ...
	'Style','text', ...
	'Tag','StaticText1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','fdclib;', ...
	'FontWeight','bold', ...
	'Position',[35.25 119.25 279.75 25.5], ...
	'String','Open main FDC library FDCLIB', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','fdchelp(''index'');', ...
	'FontWeight','bold', ...
	'Position',[35.25 90 279.75 25.5], ...
	'String','View on-line help for the FDC toolbox in a web-browser', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','helpwin', ...
	'FontWeight','bold', ...
	'Position',[35.25 60 279.75 25.5], ...
	'String','View contents of FDC folders (double-click folder names)', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.9 0.88 0.88], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ForegroundColor',[0.8 0 0], ...
	'HorizontalAlignment','left', ...
	'Position',[18.75 8.25 219 25.5], ...
	'String','See the files *.txt in the FDC subfolder \DOC for more information.', ...
	'Style','text', ...
	'Tag','StaticText1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','close(gcf)', ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'Position',[270 10.5 63 24], ...
	'String','Cancel', ...
	'Tag','Pushbutton2');


%-----------------------------------------------------------------------
% The FDC toolbox. Copyright M.O. Rauw, 1994-2002. All rights reserved.
% This software is licensed under the Dutchroll Open Source Software
% License (DOSSL), version 1.0. See LICENSE.TXT in the DOC subdirectory
% for detailed information.
