function [ pvs ] = struct2pv( varargin )
%pvs=STRUCT2PV(s,...) Convert struct(s) to {Parameter,Values} cell
%   if s.A = B; s.C = D;... then pvs = {'A',B,'C',D,...}.
%   can combine multiple structs

pvs = {};

for i=1:length(varargin)
    c=[fieldnames(varargin{i}) struct2cell(varargin{i})]';
    c=c(:)';
    pvs = [pvs c];

end

