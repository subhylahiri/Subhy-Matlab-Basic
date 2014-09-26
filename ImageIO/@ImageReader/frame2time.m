function [ time ] = frame2time( irobj,frame )
%FRAME2TIME gives time of FRAME number

time=irobj.tracker.frames.time(frame-irobj.tracker.frames.index(1)+1)/1000;


end

