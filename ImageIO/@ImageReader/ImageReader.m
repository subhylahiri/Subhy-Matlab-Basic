classdef ImageReader
    %IMAGEREADER Abstract base class for reading sequence of images
    %   Possible constructors:
    % IMRDR=LARVAIMAGES(OTHERIMRDR) - copy constructor
    % IMRDR=LARVAIMAGES(FIRSTFR,LASTFR)
    %   where  [FIRSTFR,LASTFR] are the first and last frames. 
    %   NOTE: Derived class must have a data-member for the image set, must
    %   define the IMRDR.READFRAME(FRAMENUMBER) method to read the n'th
    %   image, and must find the first and last frame in its constructor if
    %   they were not specified. The derived class constructor must pass
    %   [FIRSTFR,LASTFR] to the LARVAIMAGES constructor. 

%Scheme for derived class constructor:
%            %
%            %First: set up argument list for Superclass constructor
%            %
%            args=varagin(2:end);
%            %
%            %Second: call Superclass constructor
%            %
%            liobj=liobj@ImageReader(args{:});
%            %
%            % Third: set the images object
%            %
%            liobj.filename=varargin{1};
%            %

    properties
        % frames to include
        firstfr=1;
        lastfr=1;
        %for displaying
        multiplier=1;
        offset=0;
    end% properties
    
    methods
       %
       function ftitle=frameTitle(irobj,n)
           ftitle=[int2str(n),' of ',int2str(irobj.firstfr),...
                ' to ',int2str(irobj.lastfr)];
       end %frametitle
       %
       % display etc 
       %
       function ims=scaleIm(irobj,im)
           ims=(im-irobj.offset)*irobj.multiplier;
       end
       %
%        function disp(irobj)
%            % displays frames included.
%            disp(['Frames: ',int2str([irobj.firstfr]),' to ',int2str([irobj.lastfr])]);
%        end %disp
       %
       play(irobj,varargin)
     end %methods
     
       
    methods (Abstract=true)
        %This method must be defined in a derived class. It takes a frame
        %number, FRAMENUMBER, and returns an image (matrix of integers), IM.
        im=readFrame(irobj,framenumber)
    end %Abstract methods
   
    methods (Access=private)%for constructiuon
        %called by constructor
        copy=CopyProps(original,copy)
        copy=CopyStruct(strct,copy)
        [s,x] = assignToObject(s, x)
    end%methods
   
    methods
        %constructor
        function irobj=ImageReader(varargin)
            if nargin ~=0%false -> default constructor does nothing
                %
                %default parameters:
                %
                %if we're copying another obj
                [tempobj,varargin]=extractArgOfType(varargin,'ImageReader');
                if ~isempty(tempobj)
                    irobj = CopyProps(tempobj,irobj);
                end
                %
                %Extract data from struct:
                %
                [IMstruct,varargin]=extractArgOfType(varargin,'struct');
                if ~isempty(IMstruct)
                    [irobj, IMstruct] = outer_resize(irobj, IMstruct);
                    irobj = singletonexpand(@CopyStruct, IMstruct, irobj);
                end
                %
                %set values manually:
                [irobj,varargin]=assignToObject(irobj,varargin);
                %
                if length(varargin) >= 2
                   irobj.firstfr=varargin{1};
                   irobj.lastfr=varargin{2};
                end
            end%if nargin ~=0
        end %constructor
    end %methods
   

end %classdef

