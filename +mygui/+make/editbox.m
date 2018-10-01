function [ph, edh] = editbox(parent, data, varname, position)
%[ph,edh]=EDITBOX(parent,data,varname,position) make edit box
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   position [left bottom width height]
%
%   DATA must have properties {opts_pnl, opts_btn}
%   DATA must have a method called Update with signature Update(OBJ,SRC)

if iscell(varname)
    [ph, edh] = mygui.make.grid('editbox', {parent, data}, varnames, position);
    return;
end

ph = uipanel(parent, data.opts_pnl{:},...
        'Position', position,...
        'Title', varname);
%control
edh = uicontrol(phe, 'Style', 'edit', data.opts_btn{:},...
    'String', num2str(S.(varname)),...
    'Position', [0.05 0.05 0.9 0.9], 'Max', 1, 'Min', 0,...
    'DeleteFcn', @mygui.circDeleteFcn,...
    'Callback', {@mygui.callback.ed, data, varname});

end%function MakeEditBox
