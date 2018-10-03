function line(source, ~, data, varnamex, varnamey)
%LINE(source,~,data,varnamex,varnamey) callback for lines on graphs,
%ask user to click on graph and use (x,y) of click.
%   source: handle of object that called back
%   data: object that carries GUI state (subclass of handle)
%   varnamex: name of property of DATA to update with x, or ''.
%   varnamey: name of property of DATA to update with y, or ''.

[x, y] = ginput(1);
if varnamex
    data.(varnamex) = x;
end
if varnamey
    data.(varnamey) = y;
end
if strcmp(varnamex, varnamey)
    data.(varnamex) = [x y];
end
data.Update(source);

end
