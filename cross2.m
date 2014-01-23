function [ axb ] = cross2( a, b )
%CROSS2(A,B) cross product of 2d vectors
%   returns A_1 B_2 - A_2 B_1

assert(numel(a)==2);
assert(numel(b)==2);

axb = a(1)*b(2)-a(2)*b(1);


end

