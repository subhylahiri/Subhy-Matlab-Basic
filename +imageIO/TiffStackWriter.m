classdef TiffStackWriter < TiffStackReader & ImageWriter
    %TIFFSTACKWRITER writing a sequence of images to a TIFF stack
    %NOTE: this class ignores frame numbers, assumes frames are sequential.
    %It will not delete any frames that the TIFF file already contains.
    % Possible constructors:
    % TSW=TIFFSTACKWRITER(TSTK) get parameters from TiffStackReader
    % TSW=TIFFSTACKREADER(FILENAME)
    % TSW=TIFFSTACKREADER(FILENAME,FIRSTFR,LASTFR)
    %   where FILENAME is a string with the file name, [FIRSTFR,LASTFR]
    %   are the first and last frames(not necessary for writing).
    
    properties
        % DATA:
        options={};
    end
   
   
    methods 
        function writeFrame(obj,im,~)
            imwrite(im,[obj.path,obj.filename],'tiff',obj.options{:},'WriteMode','append');
        end
    end %methods
    
    methods
       %constructor
       function obj=TiffStackWriter(varargin)
           %
           %First: set up argument list for Superclass constructor
           %
           %
           %Second: call Superclass constructor
           %
           obj=obj@TiffStackReader(varargin{:});
           %
           % Third: set the images object
           %
           %
       end %constructor
    end %methods
    
end

