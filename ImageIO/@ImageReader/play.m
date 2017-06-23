function play(irobj,varargin)

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='ImageReader.play';
    p.StructExpand=true;
    p.KeepUnmatched=false;
    p.addOptional('firstframe',-Inf)
    p.addOptional('lastframe',Inf)
end
p.parse(varargin{:});



firstframe = max(p.Results.firstframe, irobj.firstfr);
lastframe = min(p.Results.lastframe, irobj.lastfr);



figure1=figure('CloseRequestFcn',@figclose);
axes1=axes('Parent',figure1);
i=firstframe;
while i<=lastframe
   im=irobj.readFrame(i);
   imshow(irobj.scaleIm(im),'Parent',axes1);
   title(irobj.frameTitle(i));
   drawnow;
   i=i+1;
   pause(0.1);
end %for i    
% close(figure1)   


    function figclose(src,~)
        lastframe=i;
        delete(src);
    end

end %play
