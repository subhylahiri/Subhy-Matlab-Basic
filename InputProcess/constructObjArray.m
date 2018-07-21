function [ obj, args ] = constructObjArray( obj, args )
%[obj,args]=CONSTRUCTOBJARRAY(obj,args) utility for class constructors that
%builds arrays of specified size.
%   obj  = object being constructed. Output OBJ will have the correct size.
%   args = cell array of arguments to constructor. Size info taken from
%          scalar numeric arguments at the start of the list and removed
%          from the output ARGS.

[siz,args] = extractFirstNumericArgs(args);

if isempty(siz)
    siz = {1,1};
elseif isscalar(siz)
    siz = [{1},siz];
end%if isempty(siz)

if any([siz{:}]==0)
    obj = obj.empty(siz{:});
else
    obj(siz{:}) = obj;
end%if any(siz==0)

end

