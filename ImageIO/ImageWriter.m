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
       function rgb=fig2im(obj,figh)
           %get image from figure handle figh
           error(CheckType(obj,'ImageWriter'));
           f=getframe(figh);
           [im,map] = frame2im(f);    %Return associated image data 
           if isempty(map)            %Truecolor system
             rgb = im;
           else                       %Indexed system
             rgb = ind2rgb(im,map);   %Convert image data
           end
       end
       
       function writeFig(obj,figh,framenumber)
           im=obj.fig2im(figh);
           obj.writeFrame(im,framenumber);
       end
   end
   
   methods
       %constructor
       function obj=ImageWriter
       end %constructor
   end %methods

end %clasdef

