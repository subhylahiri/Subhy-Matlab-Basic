function slpb(~, ~, slh, val)
%SLPB(~,~,slh,val) callback for push-buttons in slider panels
%   slh: handle of accompanying slider
%   val: value to set slh.Value to

slh.Value = val;
mygui.helpers.exectuteCallback(slh, []);

end
