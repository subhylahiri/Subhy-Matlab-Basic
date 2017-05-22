function [ st, eb, ar ] = HistCountErr( data, varargin )
%[st,eb,ar]=HISTCOUNTERR(data,bins,...) data for histogram plot with errors
%   outputs: structs st & ar: ('x','y'), eb: ('x','y','err')
%       st: for plotting with STAIRS
%       eb: for plotting with ERRORBAR
%       ar: for plotting with AREA
%   data: data to count. treated as data(:), passed to HISTCOUNTS
%   bins: # bins or bin edges. optional, passed to HISTCOUNTS
%   'param',value:  passed to HISTCOUNTS, 'Normalization' affects errors

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='HistCountErr';
    p.StructExpand=true;
    p.KeepUnmatched=true;
    p.addRequired('data',@(x)validateattributes(x,{'numeric'},{},'HistCountErr','data',1));
    p.addOptional('bins',[],@(x)validateattributes(x,{'numeric'},{'vector'},'HistCountErr','bins',2));
    p.addParameter('Normalization','count',@(x)validateattributes(x,{'char', 'string'},{'scalartext'},'HistCountErr','Normalization'));
end
p.parse(data,varargin{:});
r=p.Results;

Normalization = validatestring(r.Normalization, {'count', 'probability', 'countdensity', 'pdf', 'cumcount', 'cdf'}, 'HistCountErr', 'Normalization');
N = numel(data);
st = struct('x', [], 'y', []);
eb = struct('x', [], 'y', [], 'err', []);
ar = struct('x', [], 'y', []);

[eb.y, st.x] = histcounts(data, varargin{:});

st.y = [eb.y, eb.y(end)];
eb.x = st.x(1:end-1) + diff(st.x) / 2;

[ar.x, ar.y] = stairs(st.x, st.y);

switch Normalization
    case 'count'
        eb.err = sqrt(eb.y .* (N - eb.y) / (N - 1));
    case 'probability'
        eb.err = sqrt(eb.y .* (1 - eb.y) / (N - 1));
    case 'countdensity'
        w = diff(st.x);
        eb.err = sqrt(eb.y .* (N - eb.y) / (N - 1)) ./ w;
    case 'pdf'
        w = diff(st.x);
        eb.err = sqrt(eb.y .* (1 - w .* eb.y) ./ (w * (N - 1)));
    case 'cumcount'
        eb.err = sqrt(eb.y .* (N - eb.y) / (N - 1));
    case 'cdf'
        eb.err = sqrt(eb.y .* (1 - eb.y) / (N - 1));
end%switch

end

