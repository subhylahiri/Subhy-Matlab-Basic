function tf = parsevalidatestring(varargin)
%TF=PARSEVALIDATESTRING(...) version of VALIDATESTRING suitable for
%inputParser validation
%   All arguments passed to VALIDATESTRING
%   TF = true if it string is valid AND NOT a partial match

validStr = validatestring(varargin{:});
tf = ischar(validStr) && strcmp(validStr,varargin{1});
if ~tf
    validatestring(['_' varargin{1}],varargin{2:end});
end
