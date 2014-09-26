classdef ImageWriter
    %IMAGEWRITER abstract base class for writing a sequence of image files
    %Derived class should also be derived from a subclass of ImageReader.
    
  
   
   methods (Abstract=true)
       %This method must be defined in a derived class. It takes an image
       %(matrix of integers), IM, and a frame number, FRAMENUMBER. It
       %writes IM to an image file with the appropriate number.
        writeFrame(obj,im,framenumber)
   end %methods: Abstract
   
   methods
       %constructor
       function obj=ImageWriter
       end %constructor
   end %methods

end %clasdef

