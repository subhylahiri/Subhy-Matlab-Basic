function [ obj ] = GetPath( obj )
%GETPATH separate prefix into path+prefix
%   Detailed explanation goes here

i=find(obj.filename=='\',1,'last');
if ~isempty(i)
    obj.path=obj.filename(1:i);
    obj.filename=obj.filename(i+1:end);
end

end

