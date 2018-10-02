function Create( obj )
%CREATE Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(obj.figure) && obj.figure.isvalid
    return;
end

%Create figure
obj.figure = figure('Units', 'normalized', 'OuterPosition', [0 0.1 1 0.9]);

%Create panels

obj.panels(1) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0 0.1 0.5 0.9],...
                'Title', 'Images');

obj.panels(2) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.50 0.4 0.25 0.6],...
                'Title', 'Clipping');

obj.panels(3) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.75 0.4 0.25 0.6],...
                'Title', 'Nonlinearity');

obj.panels(4) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.5 0.25 0.4 0.15],...
                'Title', 'Background');

obj.panels(5) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.5 0.10 0.4 0.15],...
                'Title', 'Foreground');

obj.panels(6) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.9 0.25 0.1 0.15],...
                'Title', 'Pixel type');

obj.panels(7) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.9 0.10 0.1 0.15],...
                'Title', 'Output');
%Create axes
obj.axes(1) = axes('Parent', obj.panels(1), 'OuterPosition', [0 0.5 1 0.5]);%left bottom width height
obj.axes(2) = axes('Parent', obj.panels(1), 'OuterPosition', [0 0.0 1 0.5]);%left bottom width height

obj.axes(3) = axes('Parent', obj.panels(2), 'OuterPosition', [0 0.2 1 0.8]);%left bottom width height
obj.axes(4) = axes('Parent', obj.panels(3), 'OuterPosition', [0 0.2 1 0.8]);%left bottom width height

% im = imr.readFrame(imr.firstfr);
% CalcHist(im);
% S.inMin = pixelbins(1);
% S.inMax = pixelbins(end);
% normfn = CalcNorm(S);
% MakeSliderPlay(figure1, 1, slpos);
% MakeEditBox(ph(2), 1, 'inMin');
% MakeEditBox(ph(2), 2, 'inMax');
% 
% MakeSlider(ph(3), 2, 'logExponent', -4, 4, slpos2);
% 
% MakeRadio(ph(4), 1, 'clr', 1);
% MakeRadio(ph(5), 2, 'clr', 8);
% 
% pmh = uicontrol(ph(6), 'Style', 'popupmenu', bopts{:},...
%     'Position', [0 0 1 1],...
%     'String', outTypes,'CallBack', @pm_callback);
% 
% tgh = uicontrol(ph(7),'Style', 'togglebutton', bopts{:},...
%     'Position', [0 0 1 1],...
%     'String', 'Write?', 'Min', false, 'Max', true, 'Value', false);
%     
% ShowImages
% DrawClip;
% PlotNonlin;

end

