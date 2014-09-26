function [ copy ] = CopyConstruct( original,copy )
%COPYCONSTRUCT utility for writing copy constructors.
%needs to be made a private member function:
%    methods (Access=private)
%        copy=CopyConstruct(original,copy)
%    end %methods


fns=properties(original);
for i=1:length(fns)
   try
       copy.(fns{i})=original.(fns{i});
   catch exception
       if ~strcmp(exception.identifier,'MATLAB:class:SetProhibited');
           rethrow(exception);
       end%if
  end%try
end%for


end

