function [ tf ] = issquare( m )
%TF=ISSQUARE(M) is M a square array (all dimensions of equal size)?
%   TF=logical(0,1)

tf = ~any(diff(size(m)));


end

