function [obj,argcell] = assignToObject(obj, argcell)
%function [s,argcell] = assignToObject(s, x)
%
%if argcell{i} is a property of obj, 
%obj.(argcell{i}) = x{i+1}
%
%removes any parameter, value pairs from argcell and returns
%needs to be made member function if there are properties with private set
%access
% re-modified by Subhaneil Lahiri
% modified by marc gershow from pvpmod by
% (c) U. Egert 1998

%############################################
% this loop is assigns the parameter/value pairs in x to the calling object
keep = true(size(argcell));
if ~isempty(argcell)
    skipnext = false;
   for i = 1:size(argcell,2)
       if skipnext
           skipnext = false;
           continue;
       end
       if (ischar(argcell{i}) && isprop(argcell{i}, obj))         
          [obj.(argcell{i})] = deal(argcell{i+1});
          keep(i:i+1) = false;
          skipnext = true;
       end
   end
end
argcell = argcell(keep);

end

%############################################

