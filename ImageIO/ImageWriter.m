classdef ImageWriter
    %IMAGEWRITER abstract base class for writing a sequence of image files
    %Derived class should also be derived from a subclass of ImageReader.
    
  properties
      %clip images from figures so that # rows & cols is a multiple of this
      clipfactor=16;
      %resolution for figure capture
      resolution=0;
  end
   
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
           rgb=print(figh,'-RGBImage',['-r' int2str(obj.resolution)]);
%            f=getframe(figh);
%            [im,map] = frame2im(f);    %Return associated image data 
%            if isempty(map)            %Truecolor system
%              rgb = im;
%            else                       %Indexed system
%              rgb = ind2rgb(im,map);   %Convert image data
%            end
       end
       
       function writeFig(obj,figh,framenumber)
           im=obj.fig2im(figh);
           im=obj.clip(im);
           obj.writeFrame(im,framenumber);
       end
       
       function im=clip(obj,im)
           cliptop=mod(size(im,1),obj.clipfactor);
           clipbottom=ceil(cliptop/2);
           cliptop=cliptop-clipbottom;
           clipleft=mod(size(im,2),obj.clipfactor);
           clipright=ceil(clipleft/2);
           clipleft=clipleft-clipright;
           if ndims(im)==3
               im(1:cliptop,:,:)=[];
               im(end-clipbottom+1:end,:,:)=[];
               im(:,1:clipleft,:)=[];
               im(:,end-clipright+1:end,:)=[];
           else
               im(1:cliptop,:,:)=[];
               im(end-clipbottom+1:end,:,:)=[];
               im(:,1:clipleft,:)=[];
               im(:,end-clipright+1:end,:)=[];
           end
       end
   end
   
   methods
       %constructor
       function obj=ImageWriter
       end %constructor
   end %methods

end %clasdef

