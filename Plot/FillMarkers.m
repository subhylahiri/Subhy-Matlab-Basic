function FillMarkers(line_handles)
%FILLMARKERS(line_handles) Fill plot markers with marker edge colours
%   line_handles: array of line objects, 
%   i.e. of class matlab.graphics.chart.primitive.Line

[line_handles.MarkerFaceColor] = line_handles.Color;

end

