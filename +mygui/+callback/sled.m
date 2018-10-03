function sled(source, ~, slh)
%SLED(source,~,slh) callback for edit-boxes in slider panels
%   source: handle of object that called back
%   slh: handle of accompanying slider

val = str2double(source.String);
slh.Value = val;
mygui.helpers.exectuteCallback(slh, []);

end
