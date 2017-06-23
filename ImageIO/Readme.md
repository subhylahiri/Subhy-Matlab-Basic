# Image I/O

The classes in this folder can be used for input/output of sequences of images, usually a video.

* ImageReader and ImageWriter are abstract base classes. You can't use them directly.
* ImageSequence, TiffStackReader, AnimatedGifReader, VideoFileReader ans SingleImage are for input.
* ImSeqWriter, TiffStackWriter, AnimatedGifWriter, VideoFileWriter and FigSeqPrinter are for output.
* VideoFileWriter, VideoFileReader ans SingleImage are only needed to provide a common interface.

* ImageSequence / ImSeqWriter are for dealing with a set of separate image files, numbered by filenames.
* TiffStackReader / TiffStackWriter are for dealing with multi-page TIFF files.
* AnimatedGifReader / AnimatedGifWriter are for dealing with animated GIF files.
* VideoFileReader / VideoFileWriter are for dealing with video files via VideReader / VideoWriter objects.
* SingleImage is for dealing with a single image.
* FigSeqPrinter uses print, rather than imwrite, so it can output vector images.

# Scaling images

ScaleFluorescentImages is a GUI for adjusting contrast and/or changing fore/background colours in mages.
It is especially useful for displaying fluorescent images on projectors.
It takes a subclass of ImageReader and an optional subclass of ImageWriter as inputs.








