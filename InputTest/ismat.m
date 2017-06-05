function [ tf ] = ismat( m )
%TF=ISMAT(M) is M a matrix, and *not* a vector or scalar?
%   TF=logical(0,1)

tf = ismatrix(m) && ~isvector(m);


end

