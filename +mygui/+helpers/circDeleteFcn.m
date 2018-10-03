function circDeleteFcn( obj, ~, varargin )
%CIRCDELETEFCN(obj) delete callback function to remove circular references
%in its callbacks.
%   obj: object that has the circular reference in its callbacks.
%   ... names of callbacks containing circular reference, default: 'Callback'

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

