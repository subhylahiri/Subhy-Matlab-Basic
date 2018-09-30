function push(source, ~, data, method)
%PUSH(source,~,data,method) callback for push-button
%   source: handle of object that called back
%   data: object that carries GUI state (subclass of handle)
%   method: name of method of DATA to call. Signature: METHOD(OBJ,SOURCE)

data.(method)(source);



end
