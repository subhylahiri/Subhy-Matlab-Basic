function FigPageFix( figh )
%FIGPAGEFIX(figh) Set page size for printing to pdf.
%   figh = figure object (handle), or array thereof
%   Sets figh.PaperPositionMode = 'auto'; 
%   figh.Papersize = figh.PaperPosition(3:4).
%Needs to be rerun if figh is resized.

if ~exist('figh','var') || isempty(figh)
    figh = gcf;
end

[figh.PaperPositionMode] = deal('auto');
siz = cellfun(@(x) x(3:4), {figh.PaperPosition}, 'UniformOutput', false);
[figh.PaperSize] = siz{:};


end

