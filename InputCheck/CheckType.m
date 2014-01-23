function [ msg ] = CheckType( variable, type )
%MSG=CHECKTYPE(VARIABLE,TYPE) check if VARIABLE is a TYPE
%   TYPE is a string
%   if nargout=1, returns error message
%   if nargout=0, throws error message

if isa(variable,type)
    msg='';
else
    msg = ['Variable ' inputname(1) ' is a ' class(variable) ' when it should be a ' type '.'];
end

if nargout==0
    error(msg);
end

end

