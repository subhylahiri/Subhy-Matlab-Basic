function [ clipped_vals ] = clip( varargin )
%clipped_vals=CLIP(vals,lo,hi) Clip values to a range.
%   vals: values to clip.
%   lo:   lower bound of range, default = 0 (Also accepts length-2 vector).
%   hi:   upper bound of range, default = 1.

persistent p
if isempty(p)
    p=inputParser;
    p.addRequired('vals');
    p.addOptional('lo', 0);
    p.addOptional('hi', 1);
end
p.parse(varargin{:});
r=p.Results;

if ~isscalar(r.lo)
    r.hi = r.lo(2);
    r.lo = r.lo(1);
end

clipped_vals = min(max(r.vals, r.lo), r.hi);

end

