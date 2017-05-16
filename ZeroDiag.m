function [ newmat ] = ZeroDiag( themat, zeroval )
%newmat = ZERODIAG(themat,zeroval) set diagonal elements of themat to zero
%   zeroval: value to use for zero, default:0

if ~exist('zeroval','var') 
    zeroval = 0;
end

% newmat = themat;
% n = length(newmat);
% newmat(logical(eye(n))) = zeroval;

% newmat = themat - diag(diag(themat));

newmat = themat;
n = length(newmat);
newmat(sub2ind([n,n],1:n,1:n)) = zeroval;

end

