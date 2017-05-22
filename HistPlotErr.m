function [ ph ] = HistPlotErr( xs, ys, varargin )
%HISTPLOTERR Summary of this function goes here
%   Detailed explanation goes here

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='HistPlotErr';
    p.StructExpand=true;
    p.KeepUnmatched=true;
    p.addRequired('xs',@(x)validateattributes(x,{'numeric'},{'2d'},'HistPlotErr','xs',1));
    p.addRequired('ys',@(x)validateattributes(x,{'numeric'},{'2d'},'HistPlotErr','ys',2));
    p.addOptional('xe',[],@(x)validateattributes(x,{'numeric'},{'2d'},'HistPlotErr','xe',3));
    p.addOptional('ye',[],@(x)validateattributes(x,{'numeric'},{'2d'},'HistPlotErr','ye',4));
    p.addOptional('yerr',[],@(x)validateattributes(x,{'numeric'},{'2d'},'HistPlotErr','yerr',5));
    p.addParameter('Type','stairs',@(x)validateattributes(x,{'char', 'string'},{'scalartext'},'HistPlotErr','Type'));
end
p.parse(data,varargin{:});
r=p.Results;

Type = validatestring(r.Type, {'stairs', 'area'}, 'HistPlotErr', 'Type');
doerr = true;
plotargs = inputparser2pv(p);

if iscolumn(xs)
    xs = xs';
    ys = ys';
end
if iscolumn(r.xe)
    xe = r.xe';
    ye = r.ye';
    yerr = r.yerr';
else
    xe = r.xe;
    ye = r.ye;
    yerr = r.yerr;
end

if isempty(xe)
    doerr = false;
elseif size(xs,1) == size(xe,1) + 1
    Type = 'stairs';
elseif size(xs) == 2 * size(xe,1) + 1
    Type = 'area';
else
    error('sizes of histogram and error bars do not match');
end

if strcmp(Type, 'stairs')
    phsa = stairs(xs, ys, plotargs{:});
else
    phsa = area(xs, ys, plotargs{:});
end

if doerr
    phe = errorbar(xe, ye, yerr, plotargs{:});
        for i = 1:length(phsa)
            phe.Color = phsa.Color;
        end
end


ph = [phsa, phe];


end

