classdef ImageScalerGUI < mygui.GUItemplatePlay
    %ImageScalerGUI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        imr = [];
        imw = [];
        frameno = 1;
        logExponent = 0;
        inMin = 0;
        inMax = 255;
        outClass = @uint8;
        outMin = double(intmin(func2str(S.outClass)));
        outMax = double(intmax(func2str(S.outClass)));
        % bkgnd = zeros(1, 1, 3);
        % frgnd = ones(1, 1, 3);
        clr = cat(2, zeros(1, 1, 3), ones(1, 1, 3));
        pixelcounts = []; 
        pixelbins = [];
        im = [];
        normfn = @(x) obj.outClass(x);
    end
    
    properties
        col = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250]};
        outTypes = {'24 bit RGB', '8 bit greyscale', '16 bit greyscale', '32 bit greyscale', '64 bit greyscale'};
        intypes = {'uint8','uint8','uint16','uint32','uint64'};
        outGrey = [false true true true true];
        outColourNames = {'K','R','G','B','C','M','Y','W'};
        outColours = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 1 1 1];
        lowhi = {'1','1','1','1','8','8','8','8'};
    end
    
    methods
        Update(obj, src)
        function Create(obj)
            if isempty(obj.figure) || ~obj.figure.isvalid
                obj.figure = figure;
            end
        end
        function Play(obj)
            while obj.play && obj.frameno < obj.lastfr
               changeFrameNumber(obj.frameno + 1);
               WriteIm(imh(2).CData, S.frameno);
               AccumulateHist(imh(2).CData);
            end %while Play
            obj.play = false;
            obj.play_pb.String = 'Play';
            end
    end
    
    methods (Access=private)%for constructiuon
        %called by constructor
        copy = CopyProps(original,copy)
        copy = CopyStruct(strct,copy)
        [s,x] = assignToObject(s, x)
    end%methods for constructiuon

    methods%constructor
        function obj=ImageScalerGUI(varargin)
            [obj.imr, varargin] = extractArgOfType(varargin, 'ImageReader');
            [obj.imw, varargin] = extractArgOfType(varargin, 'ImageWriter');
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
        end
    end%constructor
end

