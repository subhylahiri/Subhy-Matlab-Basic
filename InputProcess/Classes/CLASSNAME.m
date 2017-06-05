classdef CLASSNAME
    %CLASSNAME template for class definition
    %   Find/Replace CLASSNAME with the name of your class
    %   copy CopyProps, CopyStruct, assignToObject to class folder
    %   Make sure {extractFirstNumericArgs,extractArgOfType,outer_resize,singletonexpand}
    %   are in your path
    
    methods (Access=private)%help with nonscalar objects
        %
        function result = cellised(obj,methodname,varargin)
        %result = CELLISED(obj,METHODNAME,...) returns obj sized cell array
        %of outputs of method METHODNAME 
        %   Should only be called from another method as:
%             function val = METHODNAME(obj,varargin)
%                 %description
%                 if isscalar(obj)
%                     siz = ...;
%                 else
%                     siz = obj.vectorised('METHODNAME',varargin{:});
%                 end%isscalar(obj)
%             end
        %
            result = arrayfun(@(x) x.(methodname)(varargin{:}), obj, 'UniformOutput', false);
        end
        %
        function result = vectorised(obj,methodname,varargin)
            result = obj.cellised(methodname,varargin{:});
            if isscalar(result{1})
                result = reshape([result{:}], size(obj));
            elseif isvector(result{1}) || isvector(obj)
                result = squeeze(reshape([result{:}],[size(result{1}) size(obj)]));
            else
                result = reshape([result{:}],[size(result{1}) size(obj)]);
            end
        end
    end

    methods (Access=private)%for constructiuon
        %called by constructor
        copy=CopyProps(original,copy)
        copy=CopyStruct(strct,copy)
        [s,x] = assignToObject(s, x)
    end%methods
    
    methods%Constructor
        function obj = CLASSNAME(varargin)
        %obj=CLASSNAME(...) description of CLASSNAME
        %obj=CLASSNAME(m,n,p,...) make CLASSNAME of size [m,n,p...]
        %obj=CLASSNAME(...,CLASSNAME,...) copy data from another CLASSNAME
        %obj=CLASSNAME(...,struct,...) copy data from scalar struct

            if nargin ~=0%false -> default constructor does nothing
                    %
                    %default parameters:
                    %Set size of object:
                    %
                    [siz,varargin] = extractFirstNumericArgs(varargin);
                    if isempty(siz)
                        siz={1,1};
                    elseif isscalar(siz)
                        siz=[{1},siz];
                    end%if isempty(siz)
                    if any([siz{:}]==0)
                        obj=CLASSNAME.empty(siz{:});
                    else
                        obj(siz{:})=CLASSNAME;
                    end%if any(siz==0)
                    %
                    %if we're copying another obj
                    [tempobj,varargin]=extractArgOfType(varargin,'CLASSNAME');
                    if ~isempty(tempobj)
                        [obj, tempobj] = outer_resize(obj, tempobj);
                        obj = singletonexpand(@CopyProps, tempobj, obj);
                        obj = CopyProps(tempobj,obj);
                    end
                    %
                    %Extract data from struct:
                    %
                    [CLASSNAMEstruct,varargin]=extractArgOfType(varargin,'struct');
                    if ~isempty(CLASSNAMEstruct)
                        [obj, CLASSNAMEstruct] = outer_resize(obj, CLASSNAMEstruct);
                        obj = singletonexpand(@CopyStruct, CLASSNAMEstruct, obj);
                    end
                    %
                    %set values manually:
                    [obj,varargin]=assignToObject(obj,varargin);
                    %
                    if ~isempty(varargin)
                        error('Unknown inputs');
                    end
            end%if nargin ~=0
        end%function CLASSNAME Constructor
    end%methods CLASSNAME Constructor
end