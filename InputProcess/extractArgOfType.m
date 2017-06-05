function [thearg,argcell] = extractArgOfType(argcell,typename)
%[THEARG,ARGCELL] = EXTRACTARGOFTYPE(ARGCELL,TYPENAME) - extract first argument of
%appropriate type
%   ARGCELL  = cell of arguments, usually <varargin> contents in an mfile, 
%   TYPENAME = name of type we want (string)
%   THEARG   = first element of ARGCELL that is of type TYPENAME
%THEARG is removed from ARGCELL if found, otherwise THEARG is empty.

%############################################
error(CheckType(argcell,'cell'));
error(CheckType(typename,'char'));
if isempty(argcell)
    thearg = [];
else
    whichind=find(cellfun(@(x) isa(x,typename),argcell),1,'first');
    if isempty(whichind)
        thearg=[];
    else
        thearg=argcell{whichind};
        argcell(whichind)=[];
    end%if isempty(whichind)
end%if isempty(argcell)

%############################################

