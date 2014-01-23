function [ tf ] = isrow( v )
%TF=ISROW(V) is V a row vector?
%   TF=logical(0,1)

tf = isvector(v) && size(v,1)==1;


end

