function [ obj ] = GetPath( obj, doext )
%obj.GETPATH(doext) separate prefix into path+prefix.
%   Attempts to split OBJ.filepre into [OBJ.path, OBJ.FILEPRE].
%   If doext, also attempts to split OBJ.filepre into
%   [OBJ.filepre, OBJ.numberformat, OBJ.extension]


cmpts = strsplit(obj.filepre, '\');
if ~isscalar(cmpts)
    obj.path = [strjoin(cmpts(1:end-1), '/') '/'];
end
obj.filepre = cmpts{end};

if doext
    [match,nomatch] = regexp(obj.filepre, '%[^diuoxXfeEgGcsbt]*[diuoxXfeEgGcsbt]','match','split');
    if length(match) > 1
        error('Found multiple possible format directives');
    end
    if ~isempty(match)
        obj.filepre = nomatch{1};
        obj.numberformat = match{1};
        if ~isempty(nomatch{2})
            obj.extension = nomatch{2};
        end
    end
end

end

