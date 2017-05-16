function [ cndig ] = CumNumDigits( n )
%cndig-NUMDIGITS(n) sum of numbers of digits in decimal representations of
%integers from 1 to n 


ndig = NumDigits(n);

cndig = ndig * (n+1) - 1 - (10^ndig - 10) / 9;

end

