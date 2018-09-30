function [slh, pbh, edh] = play(parent, data, varargin)
%[slh,pbh,edh]=PLAY(parent,data) make slider panel for frame number & Play button
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   DATA must have properties {frameno, firstfr, lastfr} and methods {Play}

if isempty(parent.Title)
    parent.Title = 'Frame';
end
%slider
slh = uicontrol(parent, 'Style', 'slider', varargin{:},...
    'Max', lastfr, 'Min', firstfr,...
    'Value', data.frameno,...
    'SliderStep', [1 10],...
    'Position', [0.1 0.25 0.8 0.7],...
    'DeleteFcn', @mygui.circDeleteFcn,...
    'Callback', {@mygui.callback.sl, data, 'frameno',...
        matlab.ui.control.UIControl.empty, @floor});
%Play button
pbh = uicontrol(parent, 'Style', 'pushbutton', varargin{:},...
    'String', 'Play',...
    'Position', [0.0 0.25 0.1 0.7],...
    'DeleteFcn', @mygui.circDeleteFcn,...
    'Callback', {@mygui.callback.play, data});
%display frame number
edh = uicontrol(parent, 'Style', 'edit', varargin{:},...
    'String', num2str(data.frameno),...
    'Position', [0.9 0.6 0.1 0.35],...
    'DeleteFcn', @mygui.circDeleteFcn,...
    'Callback', {@mygui.callback.sled, slh});
slh.Callback{3} = edh;  %circular references!
%slider labels
uicontrol(parent, 'Style', 'text', varargin{:},...
    'String', data.firstfr,...
    'Position', [0.1 0.05 0.08 0.2]);
uicontrol(parent, 'Style', 'text', varargin{:},...
    'String', data.lastfr,...
    'Position', [0.85 0.05 0.05 0.2]);

end%function MakeSliderPlay
