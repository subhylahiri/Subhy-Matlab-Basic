function [ copy ] = CopyStruct( strct,copy )
%copy=COPYSTRUCT(strct,copy) utility for constructing object from struct.
%Compatible with arrays of objects, but only scalar structs.
%needs to be made a private member function:
%     methods (Access=private)
%         copy=CopyStruct(strct,copy)
%     end %methods
% 
%     methods
%         %constructor
%         function obj=Foo(varargin)
%             switch nargin
%                 case 0
%                     %do nothing
%                 case 1
%                     if isa(varargin{1},'struct')
%                         obj=CopyStruct(varargin{1},obj); %copy struct
%                     else
%                         error('Unknown inputs');
%                     end %if
%                 otherwise
%                     error('Unknown inputs');
%             end %switch
%         end %constructor
%     end %methods

if ~isscalar(strct)
    error('can only work with scalar structs');
end


fns=fieldnames(strct);
for i=1:length(fns)
   try
       [copy.(fns{i})]=deal(strct.(fns{i}));
   catch exception
       if ~strcmp(exception.identifier,'MATLAB:class:SetProhibited')
           rethrow(exception);
       end%if
  end%try
end%for


end

