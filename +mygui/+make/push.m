function pbh=push(parent, data, method, position)
%pbh=PUSH(parent,data,method,position) make toggle button
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   method: name of method of DATA to call. Signature: METHOD(OBJ,SOURCE)
%   position: [left bottom width height]
%
%   DATA must have properties {opts_pnl, opts_btn}
%   DATA must have a method called Update with signature Update(OBJ,SRC)

if iscell(method)
    [pbh] = mygui.make.grid('push', {parent, data}, method, position);
    return;
end

pbh = uicontrol(parent,'Style', 'pushbutton', data.opts_btn{:},...
   'String', method, 'Position', position,...
   'DeleteFcn', @mygui.helpers.circDeleteFcn,...
   'Callback', {@tg_callback, data, method});

end%function MakeEditBox
