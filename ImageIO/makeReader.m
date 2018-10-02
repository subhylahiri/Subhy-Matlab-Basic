function [ reader ] = makeReader( mainarg, varargin )
%MAKEREADER Summary of this function goes here
%   Detailed explanation goes here

if isnumeric(mainarg)
    reader = SingleImage(mainarg, varargin{:});
    return
end

if isa(mainarg, VideoReader)
    reader = VideoFileReader(mainarg, varargin{:});
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
    reader = VideoFileReader(allargs{:});
    return
end

if any(contains(strargs, '%'))
    reader = ImageSequence(allargs{:});
    return
end

if ismember(ext, {'tif','tiff'})
    reader = TiffStackReader(allargs{:});
    return
end

if ismember(ext, {'gif'})
    reader = AnimatedGifReader(allargs{:});
    return
end

reader = SingleImage(allargs{:});

end

