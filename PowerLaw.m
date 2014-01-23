function [ n,a ] = PowerLaw( x,y )
%[n,a]=POWERLAW(x,y) power law relationship
%   y ~ a*x^n

% n=log(y(end)/y(1))/log(x(end)/x(1));

p=polyfit(log(x),log(y),1);
n=p(1);
a=exp(p(2));

end

