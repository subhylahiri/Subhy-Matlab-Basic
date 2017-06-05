function [ c ] = struct2pv( s )
%c=STRUCT2PV(s) Convert struct to {Parameter,Values} cell
%   Detailed explanation goes here

c=[fieldnames(s) struct2cell(s)]';

c=c(:)';

end

