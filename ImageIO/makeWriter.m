function [ writer ] = makeWriter( mainarg, varargin )
%writer=MAKEWRITER(...) make an appropriate image writer object.
%   input: a VideoWriter object, or a filename with extension.
%   output: VideoFileWriter, ImSeqWriter, TiffStackWriter or AnimatedGifWriter

if isa(mainarg, 'VideoWriter')
    writer = VideoFileWriter(mainarg, varargin{:});
    return
end

allargs = [{mainarg}, varargin];
charargs = cellfun(ischar, allargs) | cellfun(isstring, allargs);
if ~any(charargs)
    error('Need a string containing an extension to know what to do with this input.');
end
strargs = allargs(charargs);

tf = cellfun(@(x) contains(x, '.'), strargs);
if ~any(tf)
    error('Need an extension to know what to do with this input.');
end
ext = strsplit(strargs{find(tf, 1, 'last')}, '.');
ext = lower(ext{end});

if ismember(ext, {'avi','mj2','mpg','wmv','asf','asx','mp4','m4v','mov','ogg'})
    writer = VideoFileWriter(allargs{:});
    return
end

if any(contains(strargs, '%'))
    writer = ImSeqWriter(allargs{:});
    return
end

if ismember(ext, {'tif','tiff'})
    writer = TiffStackWriter(allargs{:});
    return
end

if ismember(ext, {'gif'})
    writer = AnimatedGifWriter(allargs{:});
    return
end

writer = ImSeqWriter(allargs{:});

end

