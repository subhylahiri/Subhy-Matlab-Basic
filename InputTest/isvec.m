function [ tf ] = isvec( v )
%TF=ISVEC(V) is V a vector, and *not* a scalar?
%   TF=logical(0,1)

tf = isvector(v) && ~isscalar(v);


end

