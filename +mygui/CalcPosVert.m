function pos = CalcPosVert(which, maxwhich, parentpos)
%pos=CALCPOSVERT(which,maxwhich,parentpos)
%Calculate position for panel in vertical grid of size PARENTPOS
%   which = this row number
%   maxwhich = total number of rows
%   parentpos = [left bottom width height]

pos = mygui.CalcPos([which, 1], [maxwhich, 1], parentpos);

end
