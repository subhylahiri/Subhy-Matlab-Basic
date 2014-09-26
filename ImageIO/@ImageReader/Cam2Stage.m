function [ CM,scale ] = Cam2Stage( irobj )
%CAM2STAGE matrix to convert from camera coordinates to stage coordinates
%   (Length in mm) = (Length in px) * scale
%   (Pos rel to stage in microns) = CM * (Pos rel to pic in px)

%conversion factor px to mm
scale=sqrt(irobj.tracker.stage.ScaleX*irobj.tracker.stage.ScaleY)/10000;
%matrix to convert from camear coordinates to stage coordinates
CM=[-irobj.tracker.stage.ScaleX*sin(irobj.tracker.stage.Angle),...
    -irobj.tracker.stage.ScaleX*cos(irobj.tracker.stage.Angle);...
    irobj.tracker.stage.ScaleY*cos(irobj.tracker.stage.Angle),...
    -irobj.tracker.stage.ScaleY*sin(irobj.tracker.stage.Angle)];

end

