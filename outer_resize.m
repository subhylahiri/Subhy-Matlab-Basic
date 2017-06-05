function [ obj1, obj2 ] = outer_resize( obj1, obj2 )
%[obj1,obj2]=OUTER_RESIZE(obj1,obj2) Reshape for singleton expansion
%   If obj1 or obj2 is a row vector, makes it a column
%   Adds enough leading singletons to size of obj2 for singleton expansion
%   in an outer product type operation

siz1 = size(obj1);
siz2 = size(obj2);

if isrow(obj1)
    siz1 = wrev(siz1);
end
if isrow(obj2)
    siz2 = wrev(siz2);
end
if isscalar(obj1)
elseif isvector(obj1)
    siz2 = [1 siz2];
else
    siz2 = [ones(1, length(siz1)) siz2];
end%if isscalar(result{1})

obj1 = reshape(obj1, siz1);
obj2 = reshape(obj2, siz2);

end

