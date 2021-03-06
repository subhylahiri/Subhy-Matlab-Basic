function [ pmh ] = pmenu( parent, data, varname, position, choices)
%pmh=PMENU(parent,data,varname,position,choices) Make popup menu
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   position: [left bottom width height]
%   choices: cell aray of strings with possible choices
%
%   DATA must have properties {opts_pnl, opts_btn}
%   DATA must have a method called Update with signature Update(OBJ,SRC)

pmh = uicontrol(parent, 'Style', 'popupmenu', data.opts_btn{:},...
    'Position', position,'String', choices,...
    'DeleteFcn', @mygui.helpers.circDeleteFcn,...
    'CallBack', {@mygui.callback.pmenu, data, varname});

end

