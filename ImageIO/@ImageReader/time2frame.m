function [ frame ] = time2frame( irobj,time )
%TIME2FRAME gives frame number closest to TIME

    thetimes = irobj.tracker.frames.time/1000;
    [~,I] = min(abs(thetimes - time));
    frame = I+irobj.tracker.frames.index(1)-1;

end

