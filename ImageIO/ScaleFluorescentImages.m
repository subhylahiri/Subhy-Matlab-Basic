function ScaleFluorescentImages( imr, varargin )
%ScaleFluorescentImages(imr,imw) Scale fluorescent image (grayscale) to
%make it easier to see on slides etc.
%   imr: ImageReader object or image (numeric matrix)
%   imr: ImageWriter object for output (optional)

%-------------------------------------------------------------------------

%initial params
persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'ScaleFluorescentImages';
    p.StructExpand = true;
    p.KeepUnmatched = false;
    p.addOptional('imw', [])
    p.addParameter('FontSize', 16);
    p.addParameter('BtFontSize', 16);
    p.addParameter('LineWidth', 2);
    p.addParameter('HistTotal', false);
end
p.parse(varargin{:});
r = p.Results;

if isnumeric(imr)
    imr = SingleImage(imr);
end

%Initialise data (put them in a global struct)
S.frameno = imr.firstfr;
S.logExponent = 0;
S.inMin = 0;
S.inMax = 255;
S.outClass = @uint8;
S.outMin = double(intmin(func2str(S.outClass)));
S.outMax = double(intmax(func2str(S.outClass)));
% S.bkgnd = zeros(1, 1, 3);
% S.frgnd = ones(1, 1, 3);
S.clr = cat(2, zeros(1, 1, 3), ones(1, 1, 3));

slpos = [0, 0, 1, 0.1];
slpos2 = [0, 0, 1, 0.2];
edpos = [0, 0, 1, 0.2];
col = {[0    0.4470    0.7410],    [0.8500    0.3250    0.0980], [0.9290    0.6940    0.1250]};
outTypes = {'24 bit RGB', '8 bit greyscale', '16 bit greyscale', '32 bit greyscale', '64 bit greyscale'};
intypes = {'uint8','uint8','uint16','uint32','uint64'};
outGrey = [false true true true true];
outColourNames = {'K','R','G','B','C','M','Y','W'};
outColours = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 1 1 1];
lowhi = {'1','1','1','1','8','8','8','8'};
%-------------------------------------------------------------------------
topts = {'Units', 'normalized', 'FontSize', r.FontSize, 'TitlePosition', 'centertop'};
bopts = {'Units', 'normalized', 'FontSize', r.BtFontSize};
%-------------------------------------------------------------------------
%Create figure
figure1 = figure('Units', 'normalized');

%Create panels

ph(1) = uipanel(figure1, topts{:},...
                'Position', [0 0.1 0.5 0.9],...
                'Title', 'Images');

ph(2) = uipanel(figure1, topts{:},...
                'Position', [0.50 0.4 0.25 0.6],...
                'Title', 'Clipping');

ph(3) = uipanel(figure1, topts{:},...
                'Position', [0.75 0.4 0.25 0.6],...
                'Title', 'Nonlinearity');

ph(4) = uipanel(figure1, topts{:},...
                'Position', [0.5 0.25 0.4 0.15],...
                'Title', 'Background');

ph(5) = uipanel(figure1, topts{:},...
                'Position', [0.5 0.10 0.4 0.15],...
                'Title', 'Foreground');

ph(6) = uipanel(figure1, topts{:},...
                'Position', [0.9 0.25 0.1 0.15],...
                'Title', 'Pixel type');

ph(7) = uipanel(figure1, topts{:},...
                'Position', [0.9 0.10 0.1 0.15],...
                'Title', 'Output');



%Create axes
ax(1) = axes('Parent', ph(1), 'OuterPosition', [0 0.5 1 0.5]);%left bottom width height
ax(2) = axes('Parent', ph(1), 'OuterPosition', [0 0.0 1 0.5]);%left bottom width height

ax(3) = axes('Parent', ph(2), 'OuterPosition', [0 0.2 1 0.8]);%left bottom width height
ax(4) = axes('Parent', ph(3), 'OuterPosition', [0 0.2 1 0.8]);%left bottom width height
%-------------------------------------------------------------------------
Play = false;
doHist = r.HistTotal;
slh = matlab.ui.control.UIControl.empty;
edh = matlab.ui.control.UIControl.empty;
edslh = matlab.ui.control.UIControl.empty;
bgh = matlab.ui.container.ButtonGroup.empty;
rdh = matlab.ui.control.UIControl.empty;
edrdh = matlab.ui.control.UIControl.empty;
pbh = matlab.ui.control.UIControl.empty;
imh = matlab.graphics.primitive.Image.empty;
lnh = matlab.graphics.chart.primitive.Line.empty;
histh = matlab.graphics.chart.primitive.Area.empty;
pixelcounts = []; 
pixelbins = [];

im = imr.readFrame(imr.firstfr);
CalcHist(im);
S.inMin = pixelbins(1);
S.inMax = pixelbins(end);
normfn = CalcNorm(S);

MakeSliderPlay(figure1, 1, slpos);

numed = 2;
MakeEditBox(ph(2), 1, 'inMin');
MakeEditBox(ph(2), 2, 'inMax');

MakeSlider(ph(3), 2, 'logExponent', -4, 4, slpos2);

MakeRadio(ph(4), 1, 'clr', 1);
MakeRadio(ph(5), 2, 'clr', 8);

pmh = uicontrol(ph(6), 'Style', 'popupmenu', bopts{:},...
    'Position', [0 0 1 1],...
    'String', outTypes,'CallBack', @pm_callback);

tgh = uicontrol(ph(7),'Style', 'togglebutton', bopts{:},...
    'Position', [0 0 1 1],...
    'String', 'Write?', 'Min', false, 'Max', true, 'Value', false);
    
ShowImages
DrawClip;
PlotNonlin;


%-------------------------------------------------------------------------

%  Callbacks for Gui

    function sl_callback(source, ~, which, varname)
    %SL_CALLBACK(source,~,which,varname) callback for sliders
    %   source: handle of object that called back
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
        S.(varname) = source.Value;
        switch which
            case 1
                S.(varname) = floor(S.(varname));
                ChangeImages;
            case 2
                normfn = CalcNorm(S);
                ChangeNonlin;
                ChangeImages;
        end
        edslh(which).String = num2str(S.(varname));
    end 

    function pbsl_callback(~, ~, which, varname, val)
    %PB_CALLBACK(source,event,which,varname,val) callback for push-buttons in slider panels
    %   which: index for handle arrays
    %   varname: name of field of struct S to update
    %   val: value to set S.varname to
        slh(which).Value = val;
        sl_callback(slh(which), 0, which, varname);
    end

    function edsl_callback(source, ~, which, varname)
    %EDSL_CALLBACK(source,~,which,varname) callback for edit-boxes in slider panels
    %   source: handle of object that called back
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
        val = str2double(source.String);
        slh(which).Value = val;
        sl_callback(slh(which), 0, which, varname);
    end

    function ed_callback(source, ~, varname)
    %ED_CALLBACK(source,~,varname) callback for edit-boxes
    %   varname: name of field of struct S to update.
        S.(varname) = str2double(source.String);
%         S.(varname) = floor(str2double(source.String));
        ChangeClip;
        normfn = CalcNorm(S);
        ChangeImages;
    end

    function play_callback(source, ~)
    %PLAY_CALLBACK(source,~) callback for play button
    %   source: handle of object that called back
        Play = ~Play;
        if Play
            source.String = 'Pause';
            DoPlay;
        else
            source.String = 'Play';
        end %if
    end %sl1_callback

    function ln_callback(~, ~, which, varname)
    %EDSL_CALLBACK(source,~,which,varname) callback for edit-boxes in slider panels
    %   source: handle of object that called back
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
        [x, y] = ginput(1);
        if which < 3
            S.(varname) = x;
            edh(which).String = num2str(x);
            ChangeClip;
        else
            S.(varname) = log(log(y) / log(x));
            slh(2).Value = S.(varname);
            sl_callback(slh(2), 0, 2, varname);
            ChangeNonlin;
        end
        normfn = CalcNorm(S);
        ChangeImages;
    end

    function bg_callback(~, event, varname, which)
    %BG_CALLBACK(~,event, varname) callback for radio button group
    %   event: struct with fields NewValue/OldValue: handles of radio buttons.
    %   varname: name of field of struct S to update.
        if isempty(event.NewValue.UserData)
            for i = 1:3
                edrd_callback(edrdh(which,i), 1, varname, which, i);
            end
        else
            S.(varname)(:,which,:) = event.NewValue.UserData;
            for i = 1:3
                edrdh(which,i).String = num2str(event.NewValue.UserData(i));
            end
        end
        normfn = CalcNorm(S);
        ChangeImages;
    end

    function edrd_callback(source, ~, varname, which, ind)
    %ED_CALLBACK(source,~,varname) callback for edit-boxes
    %   varname: name of field of struct S to update.
        bgh(which).SelectedObject = rdh(which, end);
        S.(varname)(:,which,ind) = str2double(source.String);
        normfn = CalcNorm(S);
        ChangeImages;
    end

    function pm_callback(source, ~)
    %PM_CALLBACK(source,~) callback for popup menu
    %   source: handle of object that called back
        which = source.Value;
        changeOutType(intypes{which}, outGrey(which));
        normfn = CalcNorm(S);
        ChangeImages;
    end

%-------------------------------------------------------------------------

%  Utility functions

 
%     function pos = CalcPosVert(which, maxwhich, parentpos)
%     %pos=CALCPOSVERT(which,maxwhich,left,bottom,width,height)
%     %Calculate position for panel in vertical grid of size [left bottom width height]
%         parentpos = num2cell(parentpos);
%         [left,bottom,width,height] = deal(parentpos{:});
%         height = height / maxwhich;
%         bottom = bottom + height * (maxwhich - which);
%         pos = [left bottom width height];
%     end

    function pos = CalcPosHorz(which, maxwhich, parentpos)
    %pos=CALCPOSHORZ(which,maxwhich,left,bottom,width,height)
    %Calculate position for panel in horizontal grid of size [left bottom width height]
        parentpos = num2cell(parentpos);
        [left,bottom,width,height] = deal(parentpos{:});
        width = width / maxwhich;
        left = left + width * (which - 1);
        pos = [left bottom width height];
    end

    function nfn = CalcNorm(Str)
    %nfn = CALCNORM(Str) recompute normalisation function handle
        bkgnd = Str.clr(:,1,:);
        frgnd = Str.clr(:,2,:);
        nfn = @(x) Str.outClass(Str.outMin + (Str.outMax - Str.outMin) * ...
            (bkgnd + (frgnd - bkgnd) .* ...
            clip((x - Str.inMin) / (Str.inMax - Str.inMin)) .^ ...
            exp(Str.logExponent)));
    end

    function WriteIm(im, framenumber)
    %WRITEIM(im,framenumber) write output image, if necessary
        if ~isempty(r.imw) && tgh.Value
            r.imw.writeFrame(im, framenumber)
        end
    end

    function AccumulateHist(im)
    %ACCUMULATEHIST(im) add im to pixel histogram
        if doHist
            RecalcHist(im);
        else
            CalcHist(im);
        end
        ChangeClip;
        drawnow;
    end

%-------------------------------------------------------------------------
%Functions that build interface elements
 
    function MakeSlider(parent, which, varname, minval, maxval, slpos)
    %MAKESLIDER(parent,which,varname,minval,maxval,slpos)
    %make slider panel
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   slpos: position of slider panel [left bottom width height]
        midval = S.(varname);
        %make panel
        phs = uipanel(parent, topts{:},...
                'Position', slpos, 'Title', varname);
        %slider
        slh(which) = uicontrol(phs, 'Style', 'slider', bopts{:},...
                        'Max', maxval, 'Min', minval, 'Value', S.(varname),...
                        'SliderStep', [0.002 0.1],...
                        'Position', [0.1 0.25 0.8 0.7],...
                        'Callback', {@sl_callback, which, varname});
        %slider labels
        uicontrol(phs, 'Style', 'text', bopts{:},...
                        'String', num2str(minval),...
                        'Position', [0.1 0.05 0.08 0.2]);
        uicontrol(phs, 'Style', 'text', bopts{:},...
                        'String', num2str(midval),...
                        'Position', [0.1+0.75*(midval-minval)/(maxval-minval) 0.05 0.05 0.2]);
        uicontrol(phs, 'Style', 'text', bopts{:},...
                        'String', num2str(maxval),...
                        'Position', [0.85 0.05 0.05 0.2]);
        %button to set slider to middle value
        uicontrol(phs, 'Style', 'pushbutton', bopts{:},...
                        'String', num2str(midval),...
                        'Position', [0.0 0.25 0.1 0.7],...
                        'Callback', {@pbsl_callback, which, varname, midval});
        %display value of slider
        edslh(which) = uicontrol(phs, 'Style', 'edit', bopts{:},...
                        'String', num2str(slh(which).Value),...
                        'Position', [0.9 0.25 0.1 0.7],...
                        'Callback', {@edsl_callback, which, varname});
    end%function MakeSlider

    function MakeSliderPlay(parent, which, slpos)
    %MAKESLIDERPLAY(parent,which,varname,minval,maxval,slpos)
    %make slider panel for frame number & Play button
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   slpos: position of slider panel [left bottom width height]

        %make panel
        phs = uipanel(parent, topts{:},...
                'Position', slpos, 'Title', 'Frame');
        %slider
        slh(which) = uicontrol(phs, 'Style', 'slider', bopts{:},...
                        'Max', imr.lastfr, 'Min', imr.firstfr,...
                        'Value', S.frameno,...
                        'SliderStep', [1 10] / (imr.lastfr - imr.firstfr),...
                        'Position', [0.1 0.25 0.8 0.7],...
                        'Callback', {@sl_callback, which, 'frameno'});
        %slider labels
        uicontrol(phs, 'Style', 'text', bopts{:},...
                        'String', imr.firstfr,...
                        'Position', [0.1 0.05 0.08 0.2]);
        uicontrol(phs, 'Style', 'text', bopts{:},...
                        'String', imr.lastfr,...
                        'Position', [0.85 0.05 0.05 0.2]);
        %Play button
        pbh = uicontrol(phs, 'Style', 'pushbutton', bopts{:},...
                        'String', 'Play',...
                        'Position', [0.0 0.25 0.1 0.7],...
                        'Callback', {@play_callback});
        %display value of slider
        edslh(which) = uicontrol(phs, 'Style', 'edit', bopts{:},...
                        'String', num2str(S.frameno),...
                        'Position', [0.9 0.6 0.1 0.35],...
                        'Callback', {@edsl_callback, which, 'frameno'});
    end%function MakeSliderPlay

    function MakeEditBox(parent, which, varname)
    %MAKEEDITBOX(parent,which,varname) make edit box
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   needs global vaiables: 
    %       numed: number of edit boxes
    %       edpos: position of edit boxes area [left bottom width height]
        phe = uipanel(parent, topts{:},...
                'Position', CalcPosHorz(which, numed, edpos),...
                'Title', varname);
        %control
        edh(which) = uicontrol(phe, 'Style', 'edit', bopts{:},...
            'String', num2str(S.(varname)),...
            'Max', 1, 'Min', 0,...
            'Position', [0.05 0.05 0.9 0.9],...
            'Callback', {@ed_callback, varname});
    end%function MakeEditBox

    function MakeRadio(parent, which, varname, default)
    %MAKERADIO(parent,which,varname,default) make set of radio buttons
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   default: choice of initial selection
    %   needs global vaiables: 
    %       outColourNames: 1 x N cell of strings of names
    %       outColours: N x 3 array of RGB values
        bgh(which) = uibuttongroup(parent, 'Position', [0 0 1 1],...
            'SelectionChangedFcn', {@bg_callback, varname, which});
        n = length(outColourNames);
        %radio buttons for default colours
        for i = 1:length(outColourNames)
            rdh(which, i) = uicontrol(bgh(which), 'Style', 'radiobutton', bopts{:},...
                'String', outColourNames{i},...
                'UserData', reshape(outColours(i, :), [1, 1, 3]),...
                'Tag', lowhi{i},...
                'Position', CalcPosHorz(i, n+4, [0, 0, 1, 1]));
        end
        %radio button for custom colour
        rdh(which, n+1) = uicontrol(bgh(which), 'Style', 'radiobutton', bopts{:},...
            'String', 'cust.',...
            'UserData', [],...
            'Tag', lowhi{default},...
            'Position', CalcPosHorz(n+1, n+4, [0, 0, 1, 1]));
        bgh(which).SelectedObject = rdh(which, default);
        %edit boxes for custom colour
        for i = 1:3
            edrdh(which, i) = uicontrol(bgh(which), 'Style', 'edit', bopts{:},...
                'String', num2str(S.clr(1, which, i)),...
                'UserData', [],...
                'Position', CalcPosHorz(n+i+1, n+4, [0, 0, 1, 1]),...
                'Callback', {@edrd_callback, varname, which, i});
        end
    end%function MakeRadio

%-------------------------------------------------------------------------
%Functions that update plots

    function ShowImages
        imin = imr.readFrame(S.frameno);
        if ~ismatrix(imin)
            imin = imin(:, :, 1);
        end
        imout = normfn(double(imin));
        if outGrey(pmh.Value)
            imout = imout(:, :, 1);
        end
        imh(1) = imshow(imin, 'Parent', ax(1));
        imh(2) = imshow(imout, 'Parent', ax(2));
        title(ax(1), 'Input', 'FontSize', r.FontSize);
        title(ax(2), 'Output', 'FontSize', r.FontSize);
    end

    function ChangeImages
        imin = imr.readFrame(S.frameno);
        if ~ismatrix(imin)
            imin = imin(:, :, 1);
        end
        imout = normfn(double(imin));
        if outGrey(pmh.Value)
            imout = imout(:, :, 1);
        end
        imh(1).CData = imin;
        imh(2).CData = imout;
    end

    function DrawClip
        histh = area(ax(3), pixelbins, log(pixelcounts));
        hold(ax(3), 'on');
        xlabel(ax(3), 'Pixel value', 'FontSize', r.FontSize);
        ylabel(ax(3), 'log count', 'FontSize', r.FontSize);
        yl = ylim(ax(3));
        lnh(1) = plot(ax(3), S.inMin * [1, 1], yl, 'LineWidth', r.LineWidth,...
            'ButtonDownFcn', {@ln_callback, 1, 'inMin'}, 'Color', col{1});
        lnh(2) = plot(ax(3), S.inMax * [1, 1], yl, 'LineWidth', r.LineWidth,...
            'ButtonDownFcn', {@ln_callback, 2, 'inMax'}, 'Color', col{2});
    end

    function ChangeClip
        histh.XData = pixelbins;
        histh.YData = log(pixelcounts);
        yl = ylim(ax(3));
        lnh(1).XData = S.inMin * [1, 1];
        lnh(1).YData = yl;
        lnh(2).XData = S.inMax * [1, 1];
        lnh(2).YData = yl;
    end

    function PlotNonlin
        x = 0:0.02:1;
        y = x .^ exp(S.logExponent);
        lnh(3) = plot(ax(4), x, y, 'LineWidth', r.LineWidth, 'Color', col{3},...
            'ButtonDownFcn', {@ln_callback, 3, 'logExponent'});
        xlabel(ax(4), 'Input', 'FontSize', r.FontSize);
        ylabel(ax(4), 'Output', 'FontSize', r.FontSize);
    end

    function ChangeNonlin
        x = lnh(3).XData;
        lnh(3).YData = x .^ exp(S.logExponent);
    end

%-------------------------------------------------------------------------
%Functions that help with callbacks

    function DoPlay
       while Play && S.frameno < imr.lastfr
           changeFrameNumber(S.frameno + 1);
           WriteIm(imh(2).CData, S.frameno);
           AccumulateHist(imh(2).CData);
       end %while Play
       if doHist
           doHist = false;
           DrawClip;
       end
       Play = true;
       play_callback(pbh);
    end %function DoPlay

    function changeFrameNumber(frameNumber)
    %CHANGEFRAMENUMBER(frameNumber)
        S.frameno = frameNumber;
        edslh(1).String = num2str(frameNumber);
        slh(1).Value = frameNumber;
        ChangeImages;
        drawnow;
    end

    function changeOutType(inttype, isgrey)
    %CHANGEOUTTYPE(inttype, isgrey)
        S.outClass = str2func(inttype);
        S.outMin = double(intmin(inttype));
        S.outMax = double(intmax(inttype));
        if isgrey
            MakeGrey(1);
            MakeGrey(2);
        else
            MakeRGB(1);
            MakeRGB(2);
        end
        normfn = CalcNorm(S);
    end

    function MakeGrey(which)
    %MAKEGREY(which)
        bgh(which).SelectedObject = rdh(which, str2double(bgh(which).SelectedObject.Tag));
        [rdh(which, 2:7).Enable] = deal('off');
    end

    function MakeRGB(which)
    %MAKERGB(which)
        [rdh(which, 2:7).Enable] = deal('on');
    end

    function CalcHist(im)
    %CALCHIST(im)
        [pixelcounts, pixelbins] = histcounts(im(:));
        pixelcounts(end+1) = pixelcounts(end);
    end

    function RecalcHist(im)
    %RECALCHIST(im)
        pixelcounts = pixelcounts + [histcounts(im(:), pixelbins), 0];
        pixelcounts(end) = pixelcounts(end-1);
    end


end

