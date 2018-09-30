function btng(source, event, data, varname)
%BTNG(source,event,data,varname) callback for radio button group
%   source: handle of object that called back
%   event: struct with fields NewValue/OldValue: handles of radio buttons.
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.

data.(varname) = event.NewValue.UserData;
data.Update(source);

end
