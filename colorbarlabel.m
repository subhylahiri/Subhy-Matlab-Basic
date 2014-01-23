function colorbarlabel( cbarh,label,varargin )
%COLORBARLABEL(cbarh,label,...) Add label to colorbar
%   cbarh = handle of colorbar
%   label = string for colorbar label
%   ...Property,Value,...

set(get(cbarh,'YLabel'),'String',label,'Rotation',270,'VerticalAlignment','bottom',varargin{:});


end

