classdef ImageScalerGUI < mygui.GUItemplatePlay
    %ImageScalerGUI Summary of this class goes here
    %   Detailed explanation goes here
    
    properties%describe current state of GUI
        imr = [];
        imw = [];
        logExponent = 0;
        inMin = 0;
        inMax = 255;
        outChoice = 1;
        outClass = @uint8;
        outMin = 0;
        outMax = 255;
        bkgnd = zeros(1, 1, 3);
        frgnd = ones(1, 1, 3);
        pixelcounts = []; 
        pixelbins = [];
        normfn = @(x) obj.outClass(x);
        doHist = false;
        doWrite = false;
    end
    
    properties%describe possible states of GUI
        col = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250]};
        outTypes = {'24 bit RGB', '8 bit greyscale', '16 bit greyscale', '32 bit greyscale', '64 bit greyscale'};
        intypes = {'uint8','uint8','uint16','uint32','uint64'};
        outGrey = [false true true true true];
        outColourNames = {'K','R','G','B','C','M','Y','W'};
        outColours = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 1 1 1];
        lowhi = {'1','1','1','1','8','8','8','8'};
    end
    
    methods
        %
        function ChangeImages(obj)
            imin = obj.imr.readFrame(obj.frameno);
            if ~ismatrix(imin)
                imin = imin(:, :, 1);
            end
            imout = obj.normfn(double(imin));
            if obj.outGrey(obj.outChoice)
                imout = imout(:, :, 1);
            end
            obj.img(1).CData = imin;
            obj.img(2).CData = imout;
        end
        %
        function ChangeClip(obj)
            obj.area.XData = obj.pixelbins;
            obj.area.YData = log(obj.pixelcounts);
            yl = ylim(obj.axes(3));
            obj.line(1).XData = obj.inMin * [1, 1];
            obj.line(1).YData = yl;
            obj.line(2).XData = obj.inMax * [1, 1];
            obj.line(2).YData = yl;
        end
        %
        function ChangeNonlin(obj)
            x = obj.line(3).XData;
            obj.line(3).YData = x .^ exp(obj.logExponent);
        end
        %
        function nfn = CalcNorm(obj)
        %nfn = obj.CALCNORM() compute anonymous normalisation function.
        %   Requires extant ImageScalerGUI
            nfn = @(x) obj.outClass(obj.outMin + (obj.outMax - obj.outMin) * ...
                (obj.bkgnd + (obj.frgnd - obj.bkgnd) .* ...
                clip((x - obj.inMin) / (obj.inMax - obj.inMin)) .^ ...
                exp(obj.logExponent)));
        end
    end
    
    methods
        Update(obj, src)
        Create(obj)
        %
        function Play(obj)
            while obj.play && obj.frameno < obj.lastfr
                obj.play_sl.Value = obj.frameno + 1;
                mygui.helpers.exectuteCallback(obj.play_sl, []);
                drawnow;
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
            %
            obj.Create();
        end
    end%constructor
end

