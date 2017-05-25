function [ W ] = sqrtmSVD( C )
%W=SQRTMSVD(C) matrix square root via SVD
%   W s.t. W'*W = C
%   SVD: C = U S V'
%   Assumes C is symm pos semidef => U = V
%   W = U sqrt(S) V'
%   If C not pos semidef, W still real, but W'*W ~= C
%   instead, W'*W rectifies evals of C
%   if C not symm, W'*W sets evecs to right svecs, W*W' sets evecs to left svecs

[U,S,V] = svd(C);
W = U * sqrt(S) * V';

end

