function btng(source, ~, data, varname)
%BTNG(source,event,data,varname) callback for radio button group
%   source: handle of object that called back
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.

data.(varname) = source.SelectedObject.UserData;
data.Update(source);

end
