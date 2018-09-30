function [ varargout ] = grid( maker, varnames, position, preargs, postargs )
%handle=GRID(maker,varnames,position,preargs,postargs) Summary of this function goes here
%   Detailed explanation goes here

siz = size(varnames);

varargout = cell(1, nargout);
hs(siz(1),siz(2)) = matlab.ui.control.UIControl;
for i=1:nargout
    varargout{i} = hs;
end

pos = cell(size(varnames));

for i = 1:siz(1)
    for j = 1:siz(2)
        pos{i,j} = mygui.CalcPos([i j], siz, position);
    end
end


[varargout{:}] = cellfun(@(x,y) mygui.make.(maker)(preargs{:}, x, y, postargs{:}),...
                    varnames, pos, 'UniformOutput', false);

end

