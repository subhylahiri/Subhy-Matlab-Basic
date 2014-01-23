function [ tf ] = inrange( x, minval, maxval )
%TF=INRANGE(X,MINVAL,MAXVAL) is MINVAL <= X <= MAXVAL?
%   TF=logical(0,1)

tf = (minval <= x) & (x <= maxval);

end

