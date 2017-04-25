function FigPageFix( figh )
%FIGPAGEFIX(figh) Set page size for printing to pdf
%   figh = figure object (handle)
%   Sets figh.PaperPositionMode = 'auto'; 
%   figh.Papersize = hFig.PaperPosition(3:4).
%   Needs to be rerun if figh is resized.

if ~exist('figh','var') || isempty(figh)
    figh = gcf;
end

figh.PaperPositionMode = 'auto';
figh.PaperSize = hFig.PaperPosition(3:4);


end

