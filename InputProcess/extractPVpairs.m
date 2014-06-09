function [ pvcell,otherargs ] = extractPVpairs( argcell )
%[pvcell,otherargs]=EXTRACTPVPAIRS(argcell) extract parameter-value pairs
%from ARGCELL.
%   Assumes parameter-value pairs are at end of ARGCELL
%   pvcell = {param1,val1,param2,val2,...}
%   otherargs = other arguments from begining of ARGCELL

error(CheckType(argcell,'cell'));

pvcell={};
otherargs=argcell;

for i=1:length(argcell)-1
    if ispvpairs(argcell(i:end))
        otherargs=argcell(1:i-1);
        pvcell=argcell(i:end);
        break;
    end%if
end%for i



end

