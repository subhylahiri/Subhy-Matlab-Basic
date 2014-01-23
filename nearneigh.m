function n = nearneigh(startpos,zto)
% NEARNEIGH nearest neighbour of element in other vector
% NEARNEIGH(startpos,zto) finds nearest neighbour of 
% position startpos in vector zmat and  returns its index
if ~isnan(startpos)
    targetrow = zto-startpos;
    [~,I] = min(targetrow);
    n=I;
else
    n=0;
end %if
