function [ varargout ] = grid( maker, preargs, varnames, position, varargin )
%handle=GRID(maker,preargs,varnames,position,...) create a grid of
%UICONTROL objects.
%   maker: char, name of UICONTROL making function,
%   preargs: cell array of scalar arguments, appearing before (VARNAME, POSITION)
%   varname: 2D cell array of names.
%   position: [left bottom width height] containing grid
%   ...: additional matrix arguments, appearing after (VARNAME, POSITION)

siz = size(varnames);

varargout = cell(1, nargout);

args = cell(size(varnames));

for i = 1:siz(1)
    for j = 1:siz(2)
        pos = mygui.helpers.CalcPos([i j], siz, position);
        extra = cellfun(@(x) x(i,j), varargin, 'UniformOutput', false);
        args{i, j} = [{varnames{i,j}, pos}, extra];
    end
end

[varargout{:}] = cellfun(@(x) mygui.make.(maker)(preargs{:}, x{:}),...
                    args, 'UniformOutput', false);
                
for i=1:nargout
    output = varargout{i};
    varargout{i} = reshape([output{:}], siz);
end

end

