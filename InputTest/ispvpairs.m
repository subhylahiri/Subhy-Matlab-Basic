function [ tf ] = ispvpairs( argcell )
%tf=ISPVPAIRS(argcell) is ARGCELL a cell array of parameter-value pairs?
%   tf=true if argcell={param1,val1,param2,val2,...}
%              i.e., cell-row, even length, odd elememnts are chars
%   tf=false otherwise

tf = iscell(argcell) && isrow(argcell) && mod(length(argcell),2) == 0 ...
    && all(cellfun(@ischar,argcell(1:2:end)));

end

