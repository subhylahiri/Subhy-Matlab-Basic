function [ obj ] = singletonexpand( func, obj1, obj2 )
%obj=SINGLETONEXPAND(func,obj1,obj2) matlab version of pythonish broadcasting
%   func: function handle 
%   must operate on scalars to produce a scalar: obj=func(obj1,obj2)
%   any singleton dimension of obj1,obj2 is expanded to size of other
%   Matlab arrays have an implicit sequence of hidden trailing singletons

siz1=size(obj1);
siz2=size(obj2);

if length(siz1) < length(siz2)
    siz1 = [siz1 ones(1, length(siz2) - length(siz1))];
elseif length(siz1) > length(siz2)
    siz2 = [siz2 ones(1, length(siz1) - length(siz2))];
end

siz = max(siz1,siz2);

isbroadcastleft = siz1 < siz;
isbroadcastright = siz2 < siz;

if any(siz1(isbroadcastleft) ~= 1) || any(siz2(isbroadcastright) ~= 1)
    error(['left hand side size [' int2str(siz1) ...
        '] not cobroadcastable with right hand side size [' int2str(siz2) ']']);
end

siz = num2cell(siz);

obj(siz{:}) = func(obj1(end), obj2(end));
inds = cell(size(siz));
recurse_broadcast(1, inds, inds, inds);

    function ind = broadcastind(loopind, isbroadcast)
        if isbroadcast
            ind = 1;
        else
            ind = loopind;
        end
    end

    function recurse_broadcast(whichloop, linds, rinds, inds)
    for loopind = 1:siz{whichloop}
        linds{whichloop} = broadcastind(loopind, isbroadcastleft(whichloop));
        rinds{whichloop} = broadcastind(loopind, isbroadcastright(whichloop));
        inds{whichloop} = loopind;
            if whichloop == length(siz)
                obj(inds{:}) = func(obj1(linds{:}), obj2(rinds{:}));
            else
                recurse_broadcast(whichloop + 1, linds, rinds, inds);
            end
    end%for loopind
    end

end

