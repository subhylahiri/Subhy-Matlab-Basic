function circDeleteFcn( obj, varargin )
%CIRCDELETEFCN(obj) Summary of this function goes here
%   Detailed explanation goes here

if isempty(varargin)
    obj.Callback = '';
    obj.DeleteFcn = '';
    delete(obj);
else
    cellfun(@(x) clearVal(x, obj), varargin);
    delete(obj);
end

    function clearVal(x, obj)
        obj.(x) = [];
    end

end

