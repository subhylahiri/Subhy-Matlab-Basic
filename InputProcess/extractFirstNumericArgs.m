function [theargs,argcell] = extractFirstNumericArgs(argcell,typename)
%[THEARGS,ARGCELL] = FIRSTNUMERICARGS(ARGCELL,TYPENAME) - scalar extract
%numeric arguments, or arguments of appropriate type, that are at the start
%   ARGCELL  = cell of arguments, usually <varargin> contents in an mfile, 
%   TYPENAME = name of type we want (string), default:'numeric'
%   THEARGS  = elements at beginning of ARGCELL that are of type TYPENAME
%THEARG is removed from ARGCELL if found, otherwise THEARG is empty.

%############################################
if ~exist('typename', 'var') || isempty(typename)
    typename='numeric';
end
error(CheckType(argcell,'cell'));
error(CheckType(typename,'char'));
if isempty(argcell)
    theargs = {};
else
    whichind=cellfun(@(x) isa(x,typename),argcell);
    stop1 = find(~whichind,1,'first');
    whichind=cellfun(@(x) isscalar(x),argcell);
    stop2 = find(~whichind,1,'first');
    if isempty(stop1) && isempty(stop2)
        theargs = argcell;
        argcell = {};
    elseif stop1 == 1 || stop2 == 1
        theargs={};
    else
        stop = min(stop1,stop2);
        whichind(stop:end)=false;
        theargs=argcell(whichind);
        argcell(whichind)=[];
    end%if isempty(stop)
end%if isempty(argcell)
%############################################

