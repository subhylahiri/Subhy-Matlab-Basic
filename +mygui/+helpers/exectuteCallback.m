function exectuteCallback( obj, event, varargin )
%EXECTUTECALLBACK Summary of this function goes here
%   Detailed explanation goes here

if isempty(varargin)
    varargin = {'Callback'};
end

callback = obj.(varargin{1});

if iscell(callback)
    fun = callback{1};
    if ischar(fun)
        fun = str2func(fun);
    end
    fun(obj, event, callback{2:end});
elseif ischar(callback)
    fun = str2func(callback);
    fun(obj, event);
else
    callback(obj, event);
end

end

