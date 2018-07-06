function [ cu, cr, cb ] = inputparser2pv( p, varargin)
%[cu,cr]=INPUTPARSER2PV(p,...) convert inputParser to parameter value
%pairs
%   p = inputParser object
%   ... = names of fields to exclude (strings)
%   cu = cell array of parameter value pairs from  p.Unmatched
%   cr = cell array of parameter value pairs from  p.Results

r_rm = varargin(isfield(p.Results, varargin));
u_rm = varargin(isfield(p.Unmatched, varargin));

cr = struct2pv(rmfield(p.Results, r_rm));
cu = struct2pv(rmfield(p.Unmatched, u_rm));

if nargout > 2
    cb = [cr cu];
end

end

