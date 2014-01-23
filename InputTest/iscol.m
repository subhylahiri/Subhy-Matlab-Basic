function [ tf ] = iscol( v )
%TF=ISCOL(V) is V a column vector? DEPRACATED: use iscolumn instead
%   TF=logical(0,1)

tf = isvector(v) && size(v,2)==1;


end

