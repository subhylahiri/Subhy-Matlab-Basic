function pos = CalcPos(which, maxwhich, parentpos)
%pos=CALCPOS(which,maxwhich,parentpos)
%Calculate position for panel in grid of size PARENTPOS
%   which = this [row, column] number
%   maxwhich = total number of [rows columns]
%   parentpos = [left bottom width height]

pos = parentpos;
%note that [row col] is opposite order to [left bot] & [wdth hght]
pos(3:4) = pos(3:4) ./ wrev(maxwhich);
num = wrev(which) .* [1, 1];
%num is [col row]
num(end) = maxwhich(1) - num(end);
num(1) = num(1) - 1;
pos(1:2) = pos(1:2) + pos(3:4) .* num;

end
