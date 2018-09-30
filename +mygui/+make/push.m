function pbh=push(parent, data, method, position, varargin)
%pbh=PUSH(parent,data,method,position) make toggle button
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   method: name of method of DATA to call. Signature: METHOD(OBJ,SOURCE)
%   position = [left bottom width height]
%   DATA must have a method called Update with signature Update(OBJ,SRC)

pbh = uicontrol(parent,'Style', 'pushbutton', varargin{:},...
   'String', method, 'Position', position,...
   'DeleteFcn', @mygui.circDeleteFcn,...
   'Callback', {@tg_callback, data, method});

end%function MakeEditBox
