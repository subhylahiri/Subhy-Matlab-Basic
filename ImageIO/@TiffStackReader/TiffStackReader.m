classdef TiffStackReader < ImageReader
    %TIFFSTACKREADER ImageReader for a TIFF stack
    % Possible constructors:
    % TSTK=TIFFSTACKREADER(OTHERTSTK) - copy constructor 
    % TSTK=TIFFSTACKREADER(FILENAME,FIRSTFR,LASTFR)
    %   where FILENAME is a string with the file name, [FIRSTFR,LASTFR]
    %   are the first and last frames.
    % If [FIRSTFR,LASTFR] are not specified, they are set to
    % [1,Number Of Frames]. 

   properties (SetAccess=private)
       % DATA:
       filename=''; %name of TIFF file, e.g. 'im_00001.tif'
   end %properties: not editable
   
   properties 
       % DATA:
       path=''; %path to files
   end %properties: not editable
   
   
   methods
       function im=readFrame(obj,framenumber)
           im=imread([obj.path,obj.filename],framenumber);
       end
   end %methods: private utility functions

   methods (Access=private)
       copy=CopyConstruct(original,copy)
       h=GetPath(h)
   end %methods
   
   methods (Static=true)
       function [ h ] = loadobj( a )
            %LOADOBJ replace tracker struct with TrackerData object
            h=loadobj@ImageReader(a);
            h=GetPath(h);
       end
   end
   
   methods
       %constructor
       function obj=TiffStackReader(varargin)
           %
           %First: set up argument list for Superclass constructor
           %
           switch nargin
               case 0
                   error('Needs some arguments');
               otherwise
                   if isa(varargin{1},'char')
                       args=varargin(2:end);
                   elseif isa(varargin{1},'TiffStackReader')
                       args=varargin;
                   else
                       error('Unknown inputs');
                   end %if
           end %switch
           %find number of frames, if neccessary
           if isempty(args) ...
                   || ( numel(args)==1 && ~isa(args{1},'TiffStackReader') ) ...
                   || ( numel(args)>1 && ~( isa(args{1},'double') && isa(args{2},'double') ) )
               if exist(varargin{1},'file')==2
                   args=[{1,numel(imfinfo(varargin{1}))},args];
               else
                   args=[{1,1},args];
               end%if exist
           end %if
           %
           %Second: call Superclass constructor
           %
           obj=obj@ImageReader(args{:});
           %
           % Third: set the images object
           %
           if isa(varargin{1},'TiffStackReader')
               obj=CopyConstruct(varargin{1},obj); %copy constructor
           elseif isa(varargin{1},'char')
               obj.filename=varargin{1};
               obj=GetPath(obj);
           else
                error('Unknown inputs');
           end %if
          %
       end %constructor
   end %methods
   
end %classdef

