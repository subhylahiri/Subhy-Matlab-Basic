function [ reader ] = makeReader( mainarg, varargin )
%reader=MAKEREADER(...) make an appropriate image reader object.
%   input: a numeric array, VideoReader object, or a filename with extension.
%   output: SingleImage, VideoFileReader, ImageSequence, TiffStackReader or AnimatedGifReader

if isnumeric(mainarg)
    reader = imageIO.SingleImage(mainarg, varargin{:});
    return
end

if isa(mainarg, 'VideoReader')
    reader = imageIO.VideoFileReader(mainarg, varargin{:});
    return
end

allargs = [{mainarg}, varargin];
charargs = cellfun(@ischar, allargs) | cellfun(@isstring, allargs);
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
    reader = imageIO.VideoFileReader(allargs{:});
    return
end

if any(contains(strargs, '%'))
    reader = imageIO.ImageSequence(allargs{:});
    return
end

if ismember(ext, {'tif','tiff'})
    reader = imageIO.TiffStackReader(allargs{:});
    return
end

if ismember(ext, {'gif'})
    reader = imageIO.AnimatedGifReader(allargs{:});
    return
end

reader = imageIO.SingleImage(allargs{:});

end

