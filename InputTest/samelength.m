function [ tf ] = samelength( A,B )
%TF=SAMELENGTH(A,B) d A and B have the same length?
%   TF=logical(0,1)
%   length(x)=max(size(x));

tf = (length(A)==length(B));


end

