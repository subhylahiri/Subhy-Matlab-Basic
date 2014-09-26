function [ obj ] = GetPath( obj )
%GETPATH separate prefix into path+prefix
%   Detailed explanation goes here

i=find(obj.filepre=='\',1,'last');
if ~isempty(i)
    obj.path=obj.filepre(1:i);
    obj.filepre=obj.filepre(i+1:end);
end

end

