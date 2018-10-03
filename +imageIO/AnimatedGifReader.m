classdef AnimatedGifReader < TiffStackReader
    %ANIMATEDGIFREADER ImageReader for an animated GIF (or TIFF stack)
    %It is an alias for TIFFSTACKREADER
    % Possible constructors:
    % AGR=ANIMATEDGIFREADER(OTHERTSTK) - copy constructor 
    % AGR=ANIMATEDGIFREADER(FILENAME,FIRSTFR,LASTFR)
    %   where FILENAME is a string with the file name, [FIRSTFR,LASTFR]
    %   are the first and last frames.
    % If [FIRSTFR,LASTFR] are not specified, they are set to
    % [1,Number Of Frames]. 

    methods
       %constructor
       function obj=AnimatedGifReader(varargin)
            %
            %First: set up argument list for Superclass constructor
            %
            %Second: call Superclass constructor
            %
            obj=obj@TiffStackReader(varargin{:});
            %
            % Third: set the images object
            %
       end %constructor
    end %methods

end %classdef

