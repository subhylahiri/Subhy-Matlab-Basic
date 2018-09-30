function sl(source, ~, data, varname, edslh, fixer)
%SL(source,~,data,varname,edslh,fixer) callback for sliders
%   source: handle of object that called back
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   edslh: handle of SOURCE's accompanying edit-box
%   fixer: optional, function handle to apply to value, e.g. @floor

val = source.Value;
if exist('fixer', 'var')
    val = fixer(val);
    source.Value = val;
end
data.(varname) = val;
edslh.String = num2str(val);
data.Update(source);

end 
