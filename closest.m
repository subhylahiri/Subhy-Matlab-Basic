function [val,pos]=closest(x,xi)
%[VAL,POS]=CLOSEST(X,XI) finds the member of X that is closest to XI. VAL
%is its value, POS is its index. X must be a vector, XI can be an array.
%VAL and POS are arrays the smae size as XI. 

assert(size(x,2)==1);
% assert(size(xi,2)==1);

rows=[numel(x),ones(1,ndims(xi))];
cols=[1,size(xi)];

xi=reshape(xi,cols);

diffs=abs(repmat(x,cols)-repmat(xi,rows));

[~,pos]=min(diffs);

pos=shiftdim(pos);
val=x(pos);
