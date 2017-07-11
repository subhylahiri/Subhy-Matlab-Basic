function GUItemplate( varargin )
%GUITEMPLATE(...) template for GUIs
%   arg: explanation

%-------------------------------------------------------------------------

%initial params
persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'ScaleFluorescentImages';
    p.StructExpand = true;
    p.KeepUnmatched = false;
    p.addParameter('FontSize', 16);
    p.addParameter('BtFontSize', 16);
    p.addParameter('LineWidth', 2);
end
p.parse(varargin{:});
r = p.Results;

firstfr = 1;
lastfr = 100;

%Initialise data (put them in a global struct)
S.frameno = 1;
S.param = 0;
S.xMin = 0;
S.xMax = 255;
S.outClass = @uint8;
S.colour = ones(1,1,3);
S.nColours = 2^8;

slpos = [0, 0, 1, 0.1];
slpos2 = [0, 0, 1, 0.2];
edpos = [0, 0, 1, 0.2];
togpos = [0, 0, 1, 1];
%-------------------------------------------------------------------------
col = {[0    0.4470    0.7410],    [0.8500    0.3250    0.0980], [0.9290    0.6940    0.1250]};
outTypes = {'24 bit RGB', '8 bit greyscale', '16 bit greyscale'};
intypes = {'uint8','uint8','uint16'};
outGrey = [false true true];
nColours = [2^8 2^8 2^16];
outColourNames = {'K','R','G','B','C','M','Y','W'};
outColours = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 1 1 1];
lowhi = {'1','1','1','1','8','8','8','8'};
tgnames = {'R', 'G', 'B'};
%-------------------------------------------------------------------------
topts = {'Units', 'normalized', 'FontSize', r.FontSize, 'TitlePosition', 'centertop'};
bopts = {'Units', 'normalized', 'FontSize', r.BtFontSize};
%-------------------------------------------------------------------------

%Create figure
figure1 = figure('Units', 'normalized');

%-------------------------------------------------------------------------

%Create panels

ph(1) = uipanel(figure1, topts{:},...
                'Position', [0.00 0.2 0.45 0.8],...
                'Title', 'Image');

ph(2) = uipanel(figure1, topts{:},...
                'Position', [0.45 0.2 0.45 0.8],...
                'Title', 'Plot');
ph(3) = uipanel(figure1, topts{:},...
                'Position', [0.00 0.1 0.45 0.1],...
                'Title', 'Colour');

ph(4) = uipanel(figure1, topts{:},...
                'Position', [0.45 0.1 0.45 0.1],...
                'Title', 'Bit depth');

ph(5) = uipanel(figure1, topts{:},...
                'Position', [0.90 0.1 0.10 0.9],...
                'Title', 'Invert');

%-------------------------------------------------------------------------

%Create axes
ax(1) = axes('Parent', ph(1), 'OuterPosition', [0 0.2 1 0.8]);%left bottom width height
ax(2) = axes('Parent', ph(2), 'OuterPosition', [0 0.2 1 0.8]);%left bottom width height

%-------------------------------------------------------------------------

Play = false;
%Handle arrays:
% sliders
slh = matlab.ui.control.UIControl.empty;
% edit boxes
edh = matlab.ui.control.UIControl.empty;
% edit boxes in slider panels
edslh = matlab.ui.control.UIControl.empty;
% button groups (for radio buttons)
bgh = matlab.ui.container.ButtonGroup.empty;
% radio buttons
rdh = matlab.ui.control.UIControl.empty;
% push buttons
pbh = matlab.ui.control.UIControl.empty;
% toggle buttons
tgh = matlab.ui.control.UIControl.empty;
% displayed images
imh = matlab.graphics.primitive.Image.empty;
% chart lines
lnh = matlab.graphics.chart.primitive.Line.empty;
% area plots
arh = matlab.graphics.chart.primitive.Area.empty;

im = rand(100);
pixelcounts = []; 
pixelbins = [];
CalcHist(im);
S.xMin = pixelbins(1);
S.xMax = pixelbins(end);

MakeSliderPlay(figure1, 1, slpos);

MakeSlider(ph(1), 2, 'param', -4, 4, slpos2);

numed = 2;
MakeEditBox(ph(2), 1, 'xMin');
MakeEditBox(ph(2), 2, 'xMax');


MakeRadio(ph(3), 1, 'colour', 1);

uicontrol(ph(4), 'Style', 'popupmenu', bopts{:},...
    'Position', [0 0 1 1],...
    'String', outTypes,'CallBack', @pm_callback);

numtog = 3;
for k = 1:3
    MakeToggle(ph(5), k, tgnames{k});
end

    
ShowImage
DrawHist;


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
                changeFrameNumber(floor(S.(varname)));
                ShowImage;
            case 2
                ShowImage;
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
        DrawClip;
        ShowImage;
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
        [x, ~] = ginput(1);
        S.(varname) = x;
        edh(which).String = num2str(x);
        DrawHist;
        ShowImage;
    end

    function bg_callback(~, event, varname)
    %BG_CALLBACK(~,event, varname) callback for radio button group
    %   event: struct with fields NewValue/OldValue: handles of radio buttons.
    %   varname: name of field of struct S to update.
        S.(varname) = event.NewValue.UserData;
        ShowImage;
    end

    function pm_callback(source, ~)
    %PM_CALLBACK(source,~) callback for popup menu
    %   source: handle of object that called back
        which = source.Value;
        changeOutType(intypes{which}, outGrey(which));
        S.nColours = nColours(which);
        ShowImage;
    end

    function tg_callback(~, ~)
    %TG_CALLBACK(source,~) callback for popup menu
    %   source: handle of object that called back
        ShowImage;
    end

%-------------------------------------------------------------------------

%  Utility functions

 
    function pos = CalcPos(which, maxwhich, parentpos)
    %pos=CALCPOS(which,maxwhich,left,bottom,width,height)
    %Calculate position for panel in grid of size [left bottom width height]
    %   which = [row, column]
        pos = parentpos;
        %note that [row col] is opposite order to [left bot] & [wdth hght]
        pos(3:4) = pos(3:4) ./ wrev(maxwhich);
        num = wrev(which) .* [1, 1];
        %num is [col row]
        num(end) = maxwhich(1) - num(end);
        num(1) = num(1) - 1;
        pos(1:2) = pos(1:2) + pos(3:4) .* num;
    end

    function pos = CalcPosVert(which, maxwhich, parentpos)
    %pos=CALCPOSVERT(which,maxwhich,left,bottom,width,height)
    %Calculate position for panel in vertical grid of size [left bottom width height]
        pos = CalcPos([which, 1], [maxwhich, 1], parentpos);
    end

    function pos = CalcPosHorz(which, maxwhich, parentpos)
    %pos=CALCPOSHORZ(which,maxwhich,left,bottom,width,height)
    %Calculate position for panel in horizontal grid of size [left bottom width height]
        pos = CalcPos([1, which], [1, maxwhich], parentpos);
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
                        'Max', lastfr, 'Min', firstfr,...
                        'Value', S.frameno,...
                        'SliderStep', [1 10],...
                        'Position', [0.1 0.25 0.8 0.7],...
                        'Callback', {@sl_callback, which, 'frameno'});
        %slider labels
        uicontrol(phs, 'Style', 'text', bopts{:},...
                        'String', firstfr,...
                        'Position', [0.1 0.05 0.08 0.2]);
        uicontrol(phs, 'Style', 'text', bopts{:},...
                        'String', lastfr,...
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
            'SelectionChangedFcn', {@bg_callback, varname});
        %control
        for i = 1:length(outColourNames)
            rdh(which, i) = uicontrol(bgh(which), 'Style', 'radiobutton', bopts{:},...
                'String', outColourNames{i},...
                'UserData', reshape(outColours(i, :), [1, 1, 3]),...
                'Tag', lowhi{i},...
                'Position', CalcPosHorz(i, length(outColourNames), [0, 0, 1, 1]));
        end
        bgh(which).SelectedObject = rdh(which, default);
    end%function MakeRadio

    function MakeToggle(parent, which, varname)
    %MAKETOGGLE(parent,which,varname) make toggles
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   needs global vaiables: 
    %       numtog: number of toggles 
    %       togpos: position of toggles area [left bottom width height]
       tgh(which) = uicontrol(parent,'Style', 'togglebutton', bopts{:},...
           'Position', CalcPosVert(which, numtog, togpos),...
           'Callback', @tg_callback,...
           'String', varname, 'Min', false, 'Max', true, 'Value', false);
    end%function MakeEditBox

%-------------------------------------------------------------------------
%Functions that update plots

    function ShowImage
        delete(imh);
        imout = im .^ exp(S.param);
        imout = imout .* S.colour;
        for i = 1:3
            if tgh(i).Value
                imout(:,:,i) = 1 - imout(:,:,i);
            end
        end
        imout = S.outClass(imout * (S.nColours - 1));
        imh(1) = imshow(imout, 'Parent', ax(1));
    end

    function DrawHist
        delete(arh)
        delete(lnh)
        arh = area(ax(2), pixelbins, log(pixelcounts));
        hold(ax(2), 'on');
        xlabel(ax(2), 'Pixel value', 'FontSize', r.FontSize);
        ylabel(ax(2), 'log count', 'FontSize', r.FontSize);
        xlim(ax(2), [pixelbins(1) - 0.01, pixelbins(end) + 0.01]);
        yl = ylim(ax(2));
        lnh(1) = plot(ax(2), S.xMin * [1, 1], yl, 'LineWidth', r.LineWidth,...
            'ButtonDownFcn', {@ln_callback, 1, 'xMin'}, 'Color', col{1});
        lnh(2) = plot(ax(2), S.xMax * [1, 1], yl, 'LineWidth', r.LineWidth,...
            'ButtonDownFcn', {@ln_callback, 2, 'xMax'}, 'Color', col{2});
        im = (im - S.xMin) / (S.xMax - S.xMin);
    end

%-------------------------------------------------------------------------
%Functions that help with callbacks

    function DoPlay
       while Play && S.frameno < lastfr
           changeFrameNumber(S.frameno + 1);
       end %while Play
       Play = true;
       play_callback(pbh);
    end %function DoPlay

    function changeFrameNumber(frameNumber)
    %CHANGEFRAMENUMBER(frameNumber)
        S.frameno = frameNumber;
        edslh(1).String = num2str(frameNumber);
        slh(1).Value = frameNumber;
        NewImage;
        ShowImage;
        drawnow;
    end

    function NewImage
        im = rand(100);
    end

    function changeOutType(inttype, isgrey)
    %CHANGEOUTTYPE(inttype, isgrey)
        S.outClass = str2func(inttype);
        if isgrey
            MakeGrey(1);
        else
            MakeRGB(1);
        end
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


end

