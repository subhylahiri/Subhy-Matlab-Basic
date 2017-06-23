classdef VideoFileWriter < ImageWriter
    %VIDEOFILEWRITER ImageReader for a video file, wrapper of VideoWriter
    % Possible constructors:
    % VID=VIDEOFILEWRITER(OTHELVID) - copy constructor
    % VID=VIDEOFILEWRITER(WRITEROBJ)
    % VID=VIDEOFILEWRITER(FILENAME)
    %   where WRITEROBJ is an VideoWriter object for the video,

    properties (SetAccess=private)
       % DATA:
       writerobj; %input video
    end %properties: not editable
   
   
    methods
       function iwriteFrame(obj,im,~)
           writeVideo(obj.writerobj,im);
       end
    end %methods: private utility functions

    methods (Access=private)%for constructiuon
        %called by constructor
        copy=CopyProps(original,copy)
        copy=CopyStruct(strct,copy)
        [s,x] = assignToObject(s, x)
    end%methods
   
    methods
        %constructor
        function obj=VideoFileWriter(varargin)
            %
            %First: set up argument list for Superclass constructor
            %
            switch nargin
               case 0
                   error('Needs some arguments');
               otherwise
                   if ( isa(varargin{1},'VideoWriter') || isa(varargin{1},'char') )
                       args=varargin(2:end);
                   elseif isa(varargin{1},'VideoFileWriter')
                       args=varargin;
                   else
                       error('Unknown inputs');
                   end %if
            end %switch
            %
            %find number of frames, if neccessary
            %
            if isa(varargin{1},'VideoWriter')
               tempreaderobj=varargin{1};
            elseif isa(varargin{1},'char')
               tempreaderobj=VideoWriter(varargin{1});
            else
                tempreaderobj=struct('NumberOfFrames',1);
            end %if
            %
            %Second: call Superclass constructor
            %
            obj=obj@ImageWriter(args{:});
            %
            % Third: set the images object
            %
            %if we're copying another obj
            [tempobj,varargin]=extractArgOfType(varargin,'VideoFileWriter');
            if ~isempty(tempobj)
                obj = CopyProps(tempobj, obj);
            end
            %
            %Extract data from struct:
            [IMstruct,varargin]=extractArgOfType(varargin,'struct');
            if ~isempty(IMstruct)
                obj = CopyStruct(IMstruct, obj);
            end
            %
            %set values manually:
            [obj,varargin]=assignToObject(obj,varargin);
            %
            if isa(tempreaderobj,'VideoWriter')
                obj.writerobj=tempreaderobj;
            end %if
            %
        end %constructor
    end %methods
   
end

