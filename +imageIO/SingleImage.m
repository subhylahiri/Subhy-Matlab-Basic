classdef SingleImage < ImageReader
    %SINGLEIMAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess=private)
        im
    end
    
    methods
       function im=readFrame(obj,~)
           im = obj.im;
       end
    end
    
    methods
        %constructor
        function obj=SingleImage(varargin)
            %
            %First: set up argument list for Superclass constructor
            %
            %Second: call Superclass constructor
            %
            obj=obj@ImageReader(1,1);
            %
            % Third: set the images object
            %
            if nargin > 0
                if ischar(varargin{1}) || isstring(varargin{1})
                    obj.im = imread(varargin{1});
                else
                    obj.im = varargin{1};
                end%if ischar
            end%if nargin
            %
            %
        end %constructor
    end %methods
    
end

