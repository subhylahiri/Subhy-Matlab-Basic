classdef VideoReader < ImageReader
    %VIDEOREADER ImageReader for a video file
    % Possible constructors:
    % VID=VIDEOREADER(OTHELVID) - copy constructor (NOT IMPLEMENTED NOW)
    % VID=VIDEOREADER(READEROBJ)
    % VID=VIDEOREADER(READEROBJ,FIRSTFR,LASTFR)
    % VID=VIDEOREADER(FILENAME)
    % VID=VIDEOREADER(FILENAME,FIRSTFR,LASTFR)
    %   where READEROBJ is an mmreader object for the larva video,
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
           im=read(obj.readerobj,framenumber);
       end
   end %methods: private utility functions

   methods (Access=private)
       copy=CopyConstruct(original,copy)
   end %methods
   
   methods (Static=true)
       function [ h ] = loadobj( a )
        %LOADOBJ replace tracker struct with TrackerData object
        h=loadobj@ImageReader(a);
       end
   end
   methods
       %constructor
       function obj=VideoReader(varargin)
           %
           %First: set up argument list for Superclass constructor
           %
           switch nargin
               case 0
                   error('Needs some arguments');
               otherwise
                   if ( isa(varargin{1},'mmreader') || isa(varargin{1},'char') )
                       args=varargin(2:end);
                   elseif isa(varargin{1},'VideoReader')
                       args=varargin;
                   else
                       error('Unknown inputs');
                   end %if
           end %switch
           %find number of frames, if neccessary
           if isa(varargin{1},'mmreader')
               tempreaderobj=varargin{1};
           elseif isa(varargin{1},'char')
               tempreaderobj=mmreader(varargin{1});
           end %if
           if isempty(args) ...
                   || ( numel(args)==1 && ~isa(args{1},'VideoReader') ) ...
                   || ( numel(args)>1 && ~( isa(args{1},'double') && isa(args{2},'double') ) )
               args=[{1,tempreaderobj.NumberOfFrames},args];
           end %if
           %
           %Second: call Superclass constructor
           %
           obj=obj@ImageReader(args{:});
           %
           % Third: set the images object
           %
           if isa(varargin{1},'VideoReader')
               obj=CopyConstruct(varargin{1},obj); %copy constructor
           elseif ( isa(varargin{1},'mmreader') || isa(varargin{1},'char') )
               obj.readerobj=tempreaderobj;
           else
                error('Unknown inputs');
           end %if
           %
       end %constructor
   end %methods
   
end

