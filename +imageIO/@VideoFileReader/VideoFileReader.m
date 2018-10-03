classdef VideoFileReader < imageIO.ImageReader
    %VIDEOFILEREADER ImageReader for a video file, wrapper of VideoReader
    % Possible constructors:
    % VID=VIDEOFILEREADER(OTHELVID) - copy constructor
    % VID=VIDEOFILEREADER(READEROBJ)
    % VID=VIDEOFILEREADER(READEROBJ,FIRSTFR,LASTFR)
    % VID=VIDEOFILEREADER(FILENAME)
    % VID=VIDEOFILEREADER(FILENAME,FIRSTFR,LASTFR)
    %   where READEROBJ is an VideoReader object for the video,
    %   [FIRSTFR,LASTFR] are the first and last frames, and FILENAME is a
    %   string the filename of the video. 
    % If [FIRSTFR,LASTFR] are not specified, they are set to
    % [1,READEROBJ.NumberOfFrames].  

    properties (SetAccess=private)
       % DATA:
       readerobj; %input video
    end %properties: not editable
   
   
    methods
       function im=readFrame(obj,framenumber)
           im=readFrame(obj.readerobj,framenumber);
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
        function obj=VideoFileReader(varargin)
            %
            %First: set up argument list for Superclass constructor
            %
            switch nargin
               case 0
                   error('Needs some arguments');
               otherwise
                   if ( isa(varargin{1},'VideoReader') || isa(varargin{1},'char') )
                       args=varargin(2:end);
                   elseif isa(varargin{1},'imageIO.VideoFileReader')
                       args=varargin;
                   else
                       error('Unknown inputs');
                   end %if
            end %switch
            %
            %find number of frames, if neccessary
            %
            if isa(varargin{1},'VideoReader')
               tempreaderobj=varargin{1};
            elseif isa(varargin{1},'char')
               tempreaderobj=VideoReader(varargin{1});
            else
                tempreaderobj=struct('NumberOfFrames',1);
            end %if
            if isempty(args) ...
                   || ( numel(args)==1 && ~isa(args{1},'imageIO.VideoFileReader') ) ...
                   || ( numel(args)>1 && ~( isa(args{1},'double') && isa(args{2},'double') ) )
               args=[{1,tempreaderobj.NumberOfFrames},args];
            end %if
            %
            %Second: call Superclass constructor
            %
            obj=obj@imageIO.ImageReader(args{:});
            %
            % Third: set the images object
            %
            %if we're copying another obj
            [tempobj,varargin]=extractArgOfType(varargin,'imageIO.VideoFileReader');
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
            if isa(tempreaderobj,'VideoReader')
                obj.readerobj=tempreaderobj;
            end %if
            %
        end %constructor
    end %methods
   
end

