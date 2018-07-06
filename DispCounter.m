function DispCounter( i, imax, lab, step )
%msg=DISPCOUNTER(i,imax,lab) Display value of loop counter
%   i    = current value of loop counter, starting from 1
%   imax = maximum value of loop counter
%   lab  = display prefix (string)
%   frmt = format specification, eg '%3d/%3d'
%use DispCounter(imax+1,imax,lab) to delete final display
%make sure you start with i=1

if ~exist('step','var')
    step=1;
end
frmt = [lab ' %d/%d '];

if i>1
    fprintf(repmat('\b',[1 numel(sprintf(frmt,i-step,imax))]));
end

if i<=imax
    fprintf(frmt,i,imax);
end



end

