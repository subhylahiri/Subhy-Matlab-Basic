function [ ndig ] = NumDigits( n )
%ndig-NUMDIGITS(n) number of digits in decimal representation of integer n

if n==0
    ndig = 1;
elseif n<0
    ndig = 1 + NumDigits(-n);
else
    ndig = floor(log10(n)) + 1;
end

end

