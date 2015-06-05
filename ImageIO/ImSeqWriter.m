classdef ImSeqWriter < ImageSequence & ImageWriter
    %ImSeqWriter writing a sequence of image files
    % Possible constructors:
    % IMW=IMSEQWRITER(IMR) get parameters from ImageSequence
    % IMW=IMSEQWRITER(FILEPRE,FIRSTFR,LASTFR)
    % IMW=IMSEQWRITER(FILEPRE,NUMBERFORMAT,FIRSTFR,LASTFR)
    % IMW=IMSEQWRITER(FILEPRE,NUMBERFORMAT,EXTENSION,FIRSTFR,LASTFR)
    %   where FILEPRE is a string with the file name prefix,
    %   [FIRSTFR,LASTFR] are the first and last frames, NUMBERFORMAT is a
    %   string describing the format of the numbers to append to the
    %   filenames (default '%04d') and EXTENSION is a string with the
    %   extension of the filenames (default '.tif'). 
    
   properties
       % DATA:
       options={};
   end
   
   
   methods 
       function writeFrame(obj,im,framenumber)
           imwrite(im,obj.getFilename(framenumber),obj.options{:});
       end
   end %methods: private utility functions
   
%    methods (Static=true)
%        function [ h ] = loadobj( a )
%         %LOADOBJ replace tracker struct with TrackerData object
%         h=loadobj@ImageSequence(a);
%        end
%    end
   
   methods
       %constructor
       function obj=ImSeqWriter(varargin)
           %
           %First: set up argument list for Superclass constructor
           %
           [tempoptions,varargin]=ExtractArgOfType(varargin,'cell');
           %
           %Second: call Superclass constructor
           %
%            if ~isa(varargin{1},'ImageSequence');
%                varargin=[varargin, {1,1}];
%            end %if
           obj=obj@ImageSequence(varargin{:});
           %
           % Third: set the images object
           %
           obj.options=tempoptions;
           %
       end %constructor
   end %methods

end %clasdef

