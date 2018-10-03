classdef ImageSequence < ImageReader
    %IMAGESEQUENCE ImageReader for a sequence of image files
    % Possible constructors:
    % IMSQ=IMAGESEQUENCE(OTHERIMSQ) - copy constructor 
    % IMSQ=IMAGESEQUENCE(FILEPRE,FIRSTFR,LASTFR)
    % IMSQ=IMAGESEQUENCE(FILEPRE,NUMBERFORMAT,FIRSTFR,LASTFR)
    % IMSQ=IMAGESEQUENCE(FILEPRE,NUMBERFORMAT,EXTENSION,FIRSTFR,LASTFR)
    %   where FILEPRE is a string with the file name prefix,
    %   [FIRSTFR,LASTFR] are the first and last frames, NUMBERFORMAT is a
    %   string describing the format of the numbers to append to the
    %   filenames (default '%04d') and EXTENSION is a string with the
    %   extension of the filenames (default '.tif'). 
    
   properties (SetAccess=private)
       % DATA:
       filepre = ''; %prefix of TIFF file names, e.g. 'im_' for 'im_00001.tif'
       numberformat = '%04d';
       extension = '.tif';
   end %properties: not editable
   
   properties 
       % DATA:
       path = ''; %path to files
   end %properties: editable
   
   
   methods 
       function im=readFrame(obj,framenumber)
           im = imread(obj.getFilename(framenumber));
       end
   end

    methods%utility functions
        function fname=getFilename(obj,framenumber)
            fname = [obj.path, obj.filepre, sprintf(obj.numberformat,framenumber), obj.extension];
        end
    end%methods: utility functions
   
    methods (Access=private)%for constructiuon
        %called by constructor
        copy = CopyProps(original,copy)
        copy = CopyStruct(strct,copy)
        [s,x] = assignToObject(s, x)
        obj = GetPath(obj,doext)
    end%methods for constructiuon

    methods
        %constructor
        function obj=ImageSequence(varargin)
            %
            %First: set up argument list for Superclass constructor
            %
            args = {};
            fileargs=varargin;
            for i=1:4
               if nargin >= i && ~isa(varargin{i},'char')
                   args = varargin(i:end);
                   fileargs = varargin(1:i-1);
                   break;
               end %if
            end %for
%            if numel(fileargs)<1
%                error('Unknown inputs');
%            end %if
           %
            %Second: call Superclass constructor
            %
            obj = obj@ImageReader(args{:});
            %
            % Third: set the images object
            %
            %
            %if we're copying another obj
            [tempobj, varargin] = extractArgOfType(varargin, 'ImageSequence');
            if ~isempty(tempobj)
                obj = CopyProps(tempobj, obj);
            end
            %
            %Extract data from struct:
            %
            [IMstruct, varargin] = extractArgOfType(varargin, 'struct');
            if ~isempty(IMstruct)
                obj = CopyStruct(IMstruct, obj);
            end
            %
            %set values manually:
            [obj, varargin] = assignToObject(obj, varargin);
            %
            if ~isempty(varargin)
%                     error('Unknown inputs');
            end
            if ~isempty(fileargs)
               obj.filepre = fileargs{1};
               doext = true;
               if numel(fileargs) > 1
                   obj.numberformat = fileargs{2};
                   doext = false;
               end %if
               if numel(fileargs) > 2
                   obj.extension = fileargs{3};
               end %if
               obj=GetPath(obj, doext);
            end %if
            %
        end %constructor
    end %methods

end %clasdef

