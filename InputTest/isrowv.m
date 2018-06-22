function [ tf ] = isrowv( v )
%TF=ISROWV(V) is V a row vector, and *not* a scalar??
%   TF=logical(0,1)

tf = isrow(v) &&  ~isscalar(v);


end

