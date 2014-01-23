function [ msg ] = CheckValue( variable, test, testname,varargin )
%MSG=CHECKVALUE(VARIABLE,TEST,testname,...) check if VARIABLE passes TEST
%   TEST is a function handle with TEST(VARIABLE)=true/false
%   TESTNAME used in error message, default=func2str(test)
%   ... passed to TEST
%   if nargout=1, returns error message
%   if nargout=0, throws error message

existsAndDefault('testname',func2str(test));
if ~ischar(testname)
    varargin=[{testname},varargin];
    testname=func2str(test);
end

if test(variable,varargin{:})
    msg='';
elseif isscalar(variable)
    msg = ['Variable ' inputname(1) ' failed ' testname ' because ' inputname(1) '=' num2str(variable) '.'];
else
    msg = ['Variable ' inputname(1) ' failed ' testname '.'];
end

if nargout==0
    error(msg);
end

end

