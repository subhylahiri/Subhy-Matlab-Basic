classdef AnimatedGifWriter < TiffStackWriter
    %ANIMATEDGIFWRITER writing a sequence of images to an animated GIF
    %NOTE: this class ignores frame numbers, except the first, and assumes
    %frames are sequential. 
    % Possible constructors:
    % AGW=ANIMATEDGIFWRITER(AGR) get parameters from AnimatedGifReader
    % AGW=ANIMATEDGIFWRITER(FILENAME,...)
    % AGW=ANIMATEDGIFWRITER(FILENAME,FIRSTFR,LASTFR,...)
    %   where FILENAME is a string with the file name, [FIRSTFR,LASTFR]
    %   are the first and last frames (only first matters).
    %   ...Parameter,Value,...
    %       LoopCount = Inf
    %       DelayTime = 0.5;
    %       NumColors = 256;
    
   properties
       % DATA:
       LoopCount = Inf;
       DelayTime = 0.5;
       NumColors = 256;
   end
   
   
   methods 
       function writeFrame(obj,im,framenumber)
           if ismatrix(im)
               [A, map] = gray2ind(im, obj.NumColors);
           else
               [A, map] = rgb2ind(im, obj.NumColors);
           end
           if framenumber == obj.firstfr
               imwrite(A, map, [obj.path, obj.filename], 'gif', obj.options{:},...
                   'LoopCount', obj.LoopCount, 'DelayTime', obj.DelayTime);
           else
               imwrite(A, map, [obj.path, obj.filename], 'gif', obj.options{:},...
                   'WriteMode', 'append');
           end
       end
   end %methods: private utility functions
    
    methods
       %constructor
       function obj = AnimatedGifWriter(varargin)
           %
           %First: set up argument list for Superclass constructor
           %
           %
           %Second: call Superclass constructor
           %
           obj = obj@TiffStackWriter(varargin{:});
           %
           % Third: set the images object
           %
           %
       end %constructor
    end %methods
    
end

