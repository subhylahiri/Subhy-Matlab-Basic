classdef FigSeqPrinter < ImSeqWriter
    %FIGSEQPRINTER print a sequence of figures (vector formats)
    %   Detailed explanation goes here
    
    
    
   methods 
       function writeFrame(obj,im,framenumber)
           imwrite(im,obj.getFilename(framenumber),obj.options{:});
       end
       
       function writeFig(obj,figh,framenumber)
           print(figh,obj.getFilename(framenumber),obj.options{:});
       end
   end %methods: private utility functions

   methods
       %constructor
       function obj=FigSeqPrinter(varargin)
           %
           %First: set up argument list for Superclass constructor
           %
           %
           %Second: call Superclass constructor
           %
%            if ~isa(varargin{1},'ImageSequence');
%                varargin=[varargin, {1,1}];
%            end %if
           obj=obj@ImSeqWriter(varargin{:});
           %
           % Third: set the images object
           %
           %
       end %constructor
   end %methods


    
    
end

