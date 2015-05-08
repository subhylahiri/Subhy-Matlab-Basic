function DispCounter( i, imax, lab )
%msg=DISPCOUNTER(i,imax,lab) Display value of loop counter
%   i    = current value of loop counter, starting from 1
%   imax = maximum value of loop counter
%   lab  = display prefix (string)
%use DispCounter(imax+1,imax,lab) to delete final display

if i>1
    fprintf(repmat('\b',[1 numel(sprintf([lab '%d/%d '],i-1,imax))]));
end
if i<=imax
    fprintf([lab '%d/%d '],i,imax);
end



end

