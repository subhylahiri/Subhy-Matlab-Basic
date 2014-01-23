function [ tf ] = samesize( A,B )
%TF=SAMESIZE(A,B) d A and B have the same size?
%   TF=logical(0,1)

tf = ndims(A)==ndims(B) && all(size(A)==size(B));


end

