function pmenu(source, ~, data, varname)
%PMENU(source,~,data,varname) callback for popup menu
%   source: handle of object that called back
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.

data.(varname) = source.Value;
data.Update(source);

end
