function pos = CalcPosHorz(which, maxwhich, parentpos)
%pos=CALCPOSHORZ(which,maxwhich,parentpos)
%Calculate position for panel in horizontal grid of size PARENTPOS
%   which = this column number
%   maxwhich = total number of columns
%   parentpos = [left bottom width height]

pos = mygui.CalcPos([1, which], [1, maxwhich], parentpos);

end
