function DispCounterPar( i, imax )
%msg=DISPCOUNTERPAR(i,imax) Display progress of parfor loop
%   i    = current value of loop counter, starting from 1
%   imax = maximum value of loop counter
%use DispCounter(0,imax) to set up display
%use DispCounter(imax+1,imax) to delete final display

if i==0
    fprintf(['\n' repmat('.',1,imax) '\n\n']);
elseif i>imax
    fprintf(repmat('\b',1,imax+1));
    fprintf(repmat('\b',1,imax+1));
    fprintf('\b');
else
    fprintf('\b|\n');
end



end

