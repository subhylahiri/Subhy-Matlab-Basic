function [ph, slh, edh, pbh] = slider(parent, data, varname, position, minval, maxval)
%[ph,slh,edh,pbh]=SLIDER(parent,data,varname,minval,maxval,slpos) make slider panel
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   position [left bottom width height]
%   minval, maxval: range of DATA.VARNAME
%
%   DATA must have properties {opts_pnl, opts_btn}
%   DATA must have a method called Update with signature Update(OBJ,SRC)

if iscell(varname)
    [ph, slh, edh, pbh] = mygui.make.grid('editbox', {parent, data}, varnames,...
        position, minval, maxval);
    return;
end


midval = data.(varname);
ph = uipanel(parent, data.opts_pnl{:},...
        'Position', position, 'Title', varname);
%slider
slh = uicontrol(ph, 'Style', 'slider', data.opts_btn{:},...
    'Max', maxval, 'Min', minval, 'Value', midval,...
    'SliderStep', [0.05 0.1],...
    'Position', [0.1 0.25 0.8 0.7],...
    'DeleteFcn', @mygui.helpers.circDeleteFcn,...
    'Callback', {@mygui.callback.sl, data, varname,...
        matlab.ui.control.UIControl.empty});
%button to set slider to middle value
pbh = uicontrol(ph, 'Style', 'pushbutton', data.opts_btn{:},...
    'String', num2str(midval),...
    'Position', [0.0 0.25 0.1 0.7],...
    'Callback', {@mygui.callback.slpb, slh, midval});
%display value of slider
edh = uicontrol(ph, 'Style', 'edit', data.opts_btn{:},...
    'String', num2str(slh.Value),...
    'Position', [0.9 0.25 0.1 0.7],...
    'DeleteFcn', @mygui.helpers.circDeleteFcn,...
    'Callback', {@mygui.callback.sled, slh});
slh.Callback{3} = edh;  %circular references!
%slider labels
uicontrol(ph, 'Style', 'text', data.opts_btn{:},...
    'String', num2str(minval),...
    'Position', [0.1 0.05 0.08 0.2]);
uicontrol(ph, 'Style', 'text', data.opts_btn{:},...
    'String', num2str(midval),...
    'Position', [0.1+0.8*(midval-minval)/(maxval-minval) 0.05 0.05 0.2]);
uicontrol(ph, 'Style', 'text', data.opts_btn{:},...
    'String', num2str(maxval),...
    'Position', [0.85 0.05 0.05 0.2]);

end%function MakeSlider