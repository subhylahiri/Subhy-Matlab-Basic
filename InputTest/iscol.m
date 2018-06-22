function [ tf ] = iscol( v )
%TF=ISCOL(V) is V a column vector, and *not* a scalar?
%   TF=logical(0,1)

tf = iscolumn(v) && ~isscalar(v);


end

