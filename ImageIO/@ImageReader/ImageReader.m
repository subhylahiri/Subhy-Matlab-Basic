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
%            liobj=liobj@larvaimages(args{:});
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
       %Tracker data
       tracker=[];
    end% properties
    
%     methods
%         function obj=set.firstfr(obj,value)
%             if ~isa(value,'integer')
%                 error('firstfr must be an integer')
%             end %if
%             obj.firstfr=value;
%         end %set.firstfr
% 
%         function obj=set.lastfr(obj,value)
%             if ~isa(value,'integer')
%                 error('lastfr must be an integer')
%             end %if
%             obj.lastfr=value;
%         end %set.firstfr
%         
%     end %set methods
    
    methods
       %
       function ftitle=frameTitle(irobj,n)
           ftitle=[int2str(n),' of ',int2str(irobj.firstfr),...
        ' to ',int2str(irobj.lastfr)];
       end %frametitle
       %
       % display etc 
       %
       function disp(irobj)
           % displays frames included.
           disp(['Frames: ',int2str([irobj.firstfr]),' to ',int2str([irobj.lastfr])]);
       end %disp
       %
       function display(irobj)
           disp(irobj);
       end %display   
       %
       play(irobj,varargin)
       time=frame2time(irobj,frame)
       frame=time2frame(irobj,time)
       [CM,sc]=Cam2Stage(irobj)
     end %methods
     
     methods (Access=private)
         copy=CopyConstruct(original,copy)
     end %methods
        
   methods (Abstract=true)
       %This method must be defined in a derived class. It takes a frame
       %number, FRAMENUMBER, and returns an image (matrix of integers), IM.
       im=readFrame(liobj,framenumber)
   end %Abstract methods
   
   methods (Static=true)
       function [ h ] = loadobj( a )
        %LOADOBJ replace tracker struct with TrackerData object
        h=a;
        h.tracker=TrackerData(a.tracker);
       end
   end
   
   methods
       %constructor
       function irobj=ImageReader(varargin)
           switch nargin
               case 0
                   %do nothing
               case 1
                   if isa(varargin{1},'ImageReader')
                       irobj=CopyConstruct(varargin{1},irobj); %copy constructor
                   else
                       error('Unknown inputs');
                   end %if
               case 2
                   if isa(varargin{1},'double') && isa(varargin{2},'double')
                       irobj.firstfr=varargin{1};
                       irobj.lastfr=varargin{2};
                   else
                       error('Unknown inputs');
                   end %if
               case 3
                   if isa(varargin{1},'double') && isa(varargin{2},'double')...
                           && isa(varargin{3},'char')
                       irobj.firstfr=varargin{1};
                       irobj.lastfr=varargin{2};
                       irobj.tracker=TrackerData(varargin{3});
                   else
                       error('Unknown inputs');
                   end %if
               otherwise
                   error('Unknown inputs');
           end %switch
       end %constructor
   end %methods
   

end %classdef

