function play(irobj,varargin)

%initialise counters
firstframe = irobj.firstfr;
lastframe = irobj.lastfr;
starttime = [];
endtime = [];
% tracker = [];

varargin = assignApplicable(varargin);

if (~isempty(starttime))
    firstframe =  irobj.tracker.time2frame(starttime);
end
if (~isempty(endtime))
    lastframe =  irobj.tracker.time2frame(endtime);
end
firstframe = max(firstframe, irobj.firstfr);
lastframe = min(lastframe, irobj.lastfr);



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
