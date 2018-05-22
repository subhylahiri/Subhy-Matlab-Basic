function [ pvs ] = struct2pv( varargin )
%c=STRUCT2PV(s) Convert struct to {Parameter,Values} cell
%   if s.A = B; s.C = D;... then c = {'A',B,'C',D,...}.

pvs = {};

for i=1:length(varargin)
    c=[fieldnames(varargin{i}) struct2cell(varargin{i})]';
    c=c(:)';
    pvs = [pvs c];

end

