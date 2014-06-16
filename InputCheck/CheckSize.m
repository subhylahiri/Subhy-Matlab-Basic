function [ msg ] = CheckSize( variable, test, testname,varargin )
%MSG=CHECKSIZE(VARIABLE,TEST,testname,...) check if VARIABLE passes TEST
%   TEST is a function handle with TEST(VARIABLE)=true/false
%   TESTNAME used in error message, default=func2str(test)
%   ... passed to TEST
%   if nargout=1, returns error message
%   if nargout=0, throws error message

% existsAndDefault('testname',func2str(test));
if ~exist('testname','var')
    testname=func2str(test);
end
if ~ischar(testname)
    varargin=[{testname},varargin];
    testname=func2str(test);
end

if test(variable,varargin{:})
    msg='';
else
    msg = ['Variable ' inputname(1) ' failed ' testname ' because size(' inputname(1) ')=[' num2str(size(variable)) '].'];
end

if nargout==0 && ~isempty(msg)
    error(msg);
end

end

