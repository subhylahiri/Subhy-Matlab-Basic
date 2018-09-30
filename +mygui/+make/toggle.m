function tgh=toggle(parent, data, varname, position, varargin)
%tgh=TOGGLE(parent,data,varname,position) make toggle button
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   position = [left bottom width height]
%   DATA must have a method called Update with signature Update(OBJ,SRC)

tgh = uicontrol(parent,'Style', 'togglebutton', varargin{:},...
   'String', varname, 'Position', position,...
   'Min', false, 'Max', true, 'Value', false,...
   'DeleteFcn', @mygui.circDeleteFcn,...
   'Callback', {@tg_callback, data, varname});

end%function MakeEditBox
