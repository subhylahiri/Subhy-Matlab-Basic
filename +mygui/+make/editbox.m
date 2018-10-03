function [ph, edh] = editbox(parent, data, varname, position)
%[ph,edh]=EDITBOX(parent,data,varname,position) make edit box
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   position [left bottom width height]
%
%   Makes its own panel.
%   DATA must have properties {opts_pnl, opts_btn}
%   DATA must have a method called Update with signature Update(OBJ,SRC)

if iscell(varname)
    [ph, edh] = mygui.make.grid('editbox', {parent, data}, varname, position);
    return;
end

ph = uipanel(parent, data.opts_pnl{:},...
        'Position', position,...
        'Title', varname);
%control
edh = uicontrol(ph, 'Style', 'edit', data.opts_btn{:},...
    'String', num2str(data.(varname)),...
    'Position', [0.05 0.05 0.9 0.9], 'Max', 1, 'Min', 0,...
    'DeleteFcn', @mygui.helpers.circDeleteFcn,...
    'Callback', {@mygui.callback.ed, data, varname});

end%function MakeEditBox
