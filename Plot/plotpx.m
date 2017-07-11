function ph=plotpx(px,varargin)
%PH=PLOTPX(PX,VARARGIN) plots the points, PX, in [row,col] format. All
%other arguments are passed to plot. Returns the plot handle.

if size(px,2)~=2 && size(px,1)==2
    px=px';
end

ph=plot(px(:,2),px(:,1),varargin{:});