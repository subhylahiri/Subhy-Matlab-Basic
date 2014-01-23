function [ tf ] = isint( x )
%TF=ISINT(X) is X (double) an integer value (not type)?
%   TF=logical(0,1)

tf = x==floor(x);

end

