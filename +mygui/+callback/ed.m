function ed(source, ~, data, varname)
%ED(source,~,data,varname) callback for edit-boxes
%   source: handle of object that called back
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.

data.(varname) = str2double(source.String);
data.Update(source);

end
