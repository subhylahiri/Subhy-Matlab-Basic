function ScaleFluorescentImages( imr, varargin )
%ScaleFluorescentImages(imr,imw) Scale fluorescent image (grayscale) to
%make it easier to see on slides etc.
%   imr: ImageReader object or image (numeric matrix)
%   imr: ImageWriter object for output (optional)

%-------------------------------------------------------------------------

%initial params
persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='ScaleFluorescentImages';
    p.StructExpand=true;
    p.KeepUnmatched=false;
    p.addOptional('imw',[])
    p.addParameter('FontSize',16);
    p.addParameter('BtFontSize',16);
    p.addParameter('LineWidth',2);
end
p.parse(varargin{:});
r=p.Results;

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
S.bkgnd = zeros(1,1,3);
S.frgnd = ones(1,1,3);


slpos = [0, 0, 1, 0.1];
slpos2 = [0, 0, 1, 0.2];
edpos = {0, 0, 1, 0.1};
col = {[0    0.4470    0.7410],    [0.8500    0.3250    0.0980], [0.9290    0.6940    0.1250]};
outTypes = {'24 bit RGB', '8 bit greyscale', '16 bit greyscale', '32 bit greyscale', '64 bit greyscale'};
intypes = {'uint8','uint8','uint16','uint32','uint64'};
outGrey = [false true true true true];
outColourNames ={'K','R','G','B','C','M','Y','W'};
outColours = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 1 1 0; 1 1 1];
lowhi = {'1','1','1','1','8','8','8','8'};
%-------------------------------------------------------------------------
%Create figure
figure1 = figure('Units','normalized');

%Create panels

ph(1) = uipanel(figure1, 'Units','normalized',...
                'Position',[0 0.1 0.5 0.9]);%left bottom width height
        set(ph(1),'Title','Images','FontSize',r.FontSize);

ph(2) = uipanel(figure1, 'Units','normalized',...
                'Position',[0.50 0.4 0.25 0.6]);%left bottom width height
        set(ph(2),'Title','Clipping','FontSize',r.FontSize);

ph(3) = uipanel(figure1, 'Units','normalized',...
                'Position',[0.75 0.4 0.25 0.6]);%left bottom width height
        set(ph(3),'Title','Nonlinearity','FontSize',r.FontSize);

ph(4) = uipanel(figure1, 'Units','normalized',...
                'Position',[0.5 0.25 0.4 0.15]);%left bottom width height
        set(ph(4),'Title','Background','FontSize',r.FontSize);

ph(5) = uipanel(figure1, 'Units','normalized',...
                'Position',[0.5 0.10 0.4 0.15]);%left bottom width height
        set(ph(5),'Title','Foreground','FontSize',r.FontSize);

ph(6) = uipanel(figure1, 'Units','normalized',...
                'Position',[0.9 0.25 0.1 0.15]);%left bottom width height
        set(ph(6),'Title','Pixel type','FontSize',r.FontSize);

ph(7) = uipanel(figure1, 'Units','normalized',...
                'Position',[0.9 0.10 0.1 0.15]);%left bottom width height
        set(ph(7),'Title','Output','FontSize',r.FontSize);



%Create axes
ax(1) = axes('Parent',ph(1), 'OuterPosition',[0 0.5 1 0.5]);%left bottom width height
ax(2) = axes('Parent',ph(1), 'OuterPosition',[0 0.0 1 0.5]);%left bottom width height

ax(3) = axes('Parent',ph(2), 'OuterPosition',[0 0.2 1 0.8]);%left bottom width height
ax(4) = axes('Parent',ph(3), 'OuterPosition',[0 0.2 1 0.8]);%left bottom width height
%-------------------------------------------------------------------------
Play = false;
slh = matlab.ui.control.UIControl.empty;
edh = matlab.ui.control.UIControl.empty;
edslh = matlab.ui.control.UIControl.empty;
bgh = matlab.ui.container.ButtonGroup.empty;
rdh = matlab.ui.control.UIControl.empty;
pbh = matlab.ui.control.UIControl.empty;
imh = matlab.graphics.primitive.Image.empty;
lnh = matlab.graphics.chart.primitive.Line.empty;
histh = matlab.graphics.chart.primitive.Area.empty;


im = imr.readFrame(imr.firstfr);
[pixelcounts, pixelbins] = histcounts(im(:));
pixelcounts(end+1) = pixelcounts(end);
S.inMin = pixelbins(1);
S.inMax = pixelbins(end);
normfn = CalcNorm(S);

MakeSliderPlay(figure1, 1, slpos);
% imh(1) = imshow(im, 'Parent', ax(1));
% imh(2) = imshow(normfn(double(im)), 'Parent', ax(2));

numed=2;
MakeEditBox(ph(2), 1, 'inMin');
MakeEditBox(ph(2), 2, 'inMax');

MakeSlider(ph(3), 2, 'logExponent', -4, 4, slpos2);

MakeRadio(ph(4), 1, 'bkgnd', 1);
MakeRadio(ph(5), 2, 'frgnd', 8);

pmh = uicontrol(ph(6), 'Style', 'popupmenu',...
    'Units','normalized','FontSize',r.BtFontSize, 'Position', [0 0 1 1],...
    'String', outTypes,'CallBack', @pm_callback);

tgh = uicontrol(ph(7),'Style', 'togglebutton',...
    'Units','normalized','FontSize',r.BtFontSize, 'Position', [0 0 1 1],...
    'String', 'Write?', 'Min', false, 'Max', true, 'Value', false);
    
ShowImages
DrawClip;
PlotNonlin;


%-------------------------------------------------------------------------

%  Callbacks for Gui

    function sl_callback(source,~,which,varname)
    %SL_CALLBACK(source,~,which,varname) callback for sliders
    %   source: handle of object that called back
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
        S.(varname)=get(source,'Value');
        switch which
            case 1
                S.(varname)=floor(S.(varname));
                ShowImages;
            case 2
                normfn = CalcNorm(S);
                PlotNonlin;
                ShowImages;
        end
        set(edslh(which),'String',num2str(S.(varname)));
    end 

    function pb_callback(~,~,which,varname,val)
    %PB_CALLBACK(source,event,which,varname,val) callback for push-buttons in slider panels
    %   which: index for handle arrays
    %   varname: name of field of struct S to update
    %   val: value to set S.varname to
        set(slh(which),'Value',val);
        sl_callback(slh(which),0,which,varname);
    end

    function edsl_callback(source,~,which,varname)
    %EDSL_CALLBACK(source,~,which,varname) callback for edit-boxes in slider panels
    %   source: handle of object that called back
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
        val=str2double(get(source,'String'));
        set(slh(which),'Value',val);
        sl_callback(slh(which),0,which,varname);
    end

    function ed_callback(source,~,varname)
    %ED_CALLBACK(source,~,varname) callback for edit-boxes
    %   varname: name of field of struct S to update.
        S.(varname)=str2double(get(source,'String'));
%         S.(varname)=floor(str2double(get(source,'String')));
        DrawClip;
        normfn = CalcNorm(S);
        ShowImages;
    end

    function play_callback(source,~)
    %PLAY_CALLBACK(source,~) callback for play button
    %   source: handle of object that called back
        Play=~Play;
        if Play
            set(source,'String','Pause');
            DoPlay;
        else
            set(source,'String','Play');
        end %if
    end %sl1_callback

    function ln_callback(~,~,which,varname)
    %EDSL_CALLBACK(source,~,which,varname) callback for edit-boxes in slider panels
    %   source: handle of object that called back
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
        [x,y]=ginput(1);
        if which < 3
            S.(varname) = x;
            set(edh(which), 'String', num2str(x));
            DrawClip;
        else
            S.(varname) = log(log(y) / log(x));
            set(slh(2),'Value',S.(varname));
            sl_callback(slh(2),0,2,varname);
            PlotNonlin;
        end
        normfn = CalcNorm(S);
        ShowImages;
    end

    function bg_callback(~,event, varname)
    %BG_CALLBACK(~,event, varname) callback for radio button group
    %   event: struct with fields NewValue/OldValue: handles of radio buttons.
    %   varname: name of field of struct S to update.
        S.(varname) = event.NewValue.UserData;
        normfn = CalcNorm(S);
        ShowImages;
    end

    function pm_callback(source,~)
    %PM_CALLBACK(source,~) callback for popup menu
    %   source: handle of object that called back
        which=get(source,'Value');
        changeOutType(intypes{which}, outGrey(which));
        normfn = CalcNorm(S);
        ShowImages;
    end

%-------------------------------------------------------------------------

%  Utility functions

 
%     function pos=CalcPosVert(which,maxwhich,left,bottom,width,height)
%     %pos=CALCPOSVERT(which,maxwhich,left,bottom,width,height)
%     %Calculate position for panel in vertical grid of size [left bottom width height]
%         pos=[left bottom+height/maxwhich*(maxwhich-which) width height/maxwhich];
%     end

    function pos=CalcPosHorz(which,maxwhich,left,bottom,width,height)
    %pos=CALCPOSHORZ(which,maxwhich,left,bottom,width,height)
    %Calculate position for panel in horizontal grid of size [left bottom width height]
       pos=[left+width/maxwhich*(which-1) bottom width/maxwhich height];
    end

    function nfn = CalcNorm(Str)
    %nfn = CALCNORM(Str) recompute normalisation function handle
        nfn = @(x) Str.outClass(Str.outMin + (Str.outMax - Str.outMin) * ...
            (Str.bkgnd + (Str.frgnd - Str.bkgnd) .* ...
            min(max((x - Str.inMin) / (Str.inMax - Str.inMin), 0), 1) .^ ...
            exp(Str.logExponent)));
    end

    function WriteIm(im,framenumber)
    %WRITEIM(im,framenumber) write output image, if necessary
        if ~isempty(r.imw) && tgh.Value
            r.imw.writeFrame(im,framenumber)
        end
    end

%-------------------------------------------------------------------------
%Functions that build interface elements
 
    function MakeSlider(parent,which,varname,minval,maxval,slpos)
    %MAKESLIDER(parent,which,varname,minval,maxval,slpos)
    %make slider panel
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   slpos: position of slider panel [left bottom width height]
        midval=S.(varname);
        %make panel
        phs=uipanel(parent,'Units','normalized',...
                'Position',slpos);%left bottom width height
        set(phs,'Title',varname,'FontSize',r.FontSize);
        %slider
        slh(which)=uicontrol(phs,'Style','slider',...
                        'Max',maxval,'Min',minval,'Value',S.(varname),...
                        'SliderStep',[0.002 0.1],...
                        'Units','normalized',...
                        'Position',[0.1 0.25 0.8 0.7],...
                        'Callback',{@sl_callback,which,varname});
        %slider labels
        uicontrol(phs,'Style','text',...
                        'String',num2str(minval),...
                        'Units','normalized',...
                        'FontSize',r.FontSize,...
                        'Position',[0.1 0.05 0.08 0.2]);
        uicontrol(phs,'Style','text',...
                        'String',num2str(midval),...
                        'Units','normalized',...
                        'FontSize',r.FontSize,...
                        'Position',[0.1+0.75*(midval-minval)/(maxval-minval) 0.05 0.05 0.2]);
        uicontrol(phs,'Style','text',...
                        'String',num2str(maxval),...
                        'Units','normalized',...
                        'FontSize',r.FontSize,...
                        'Position',[0.85 0.05 0.05 0.2]);
        %button to set slider to middle value
        uicontrol(phs,'Style','pushbutton',...
                        'String',num2str(midval),...
                        'Units','normalized',...
                        'FontSize',r.FontSize,...
                        'Position',[0.0 0.25 0.1 0.7],...
                        'Callback',{@pb_callback,which,varname,midval});
        %display value of slider
        edslh(which)=uicontrol(phs,'Style','edit',...
                        'String',num2str(get(slh(which),'Value')),...
                        'Units','normalized',...
                        'FontSize',r.FontSize,...
                        'Position',[0.9 0.25 0.1 0.7],...
                        'Callback',{@edsl_callback,which,varname});
    end%function MakeSlider

    function MakeSliderPlay(parent,which,slpos)
    %MAKESLIDERPLAY(parent,which,varname,minval,maxval,slpos)
    %make slider panel for frame number & Play button
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   slpos: position of slider panel [left bottom width height]

        %make panel
        phs=uipanel(parent,'Units','normalized',...
                'Position',[slpos]);%left bottom width height
        set(phs,'Title','Frame','FontSize',r.FontSize);
        %slider
        slh(which)=uicontrol(phs,'Style','slider',...
                        'Max',imr.lastfr,'Min',imr.firstfr,...
                        'Value',S.frameno,...
                        'SliderStep',[1 10],...
                        'Units','normalized',...
                        'Position',[0.1 0.25 0.8 0.7],...
                        'Callback',{@sl_callback,which,'frameno'});
        %slider labels
        uicontrol(phs,'Style','text',...
                        'String',imr.firstfr,...
                        'Units','normalized',...
                        'FontSize',r.BtFontSize,...
                        'Position',[0.1 0.05 0.08 0.2]);
        uicontrol(phs,'Style','text',...
                        'String',imr.lastfr,...
                        'Units','normalized',...
                        'FontSize',r.BtFontSize,...
                        'Position',[0.85 0.05 0.05 0.2]);
        %Play button
        pbh=...
        uicontrol(phs,'Style','pushbutton',...
                        'String','Play',...
                        'Units','normalized',...
                        'Position',[0.0 0.25 0.1 0.7],...
                        'FontSize',r.BtFontSize,...
                        'Callback',{@play_callback});
        %display value of slider
        edslh(which)=uicontrol(phs,'Style','edit',...
                        'String',num2str(S.frameno),...
                        'Units','normalized',...
                        'Position',[0.9 0.6 0.1 0.35],...
                        'FontSize',r.BtFontSize,...
                        'Callback',{@edsl_callback,which,'frameno'});
    end%function MakeSliderPlay

    function MakeEditBox(parent,which,varname)
    %MAKEEDITBOX(parent,which,varname) make edit box
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   needs global vaiables: 
    %       numed: number of edit boxes
    %       edpos: position of edit boxes area [left bottom width height]
        phe=uipanel(parent,'Units','normalized',...
                'Position',CalcPosHorz(which,numed,edpos{:}));%left bottom width height
        set(phe,'Title',varname,'FontSize',r.FontSize);
        %control
        edh(which)=uicontrol(phe,'Style','edit',...
            'String',num2str(S.(varname)),...
            'Max',1,'Min',0,...
            'Units','normalized',...
            'FontSize',r.FontSize,...
            'Position',[0.05 0.05 0.9 0.9],...
            'Callback',{@ed_callback,varname});
    end%function MakeEditBox

    function MakeRadio(parent,which,varname,default)
    %MAKERADIO(parent,which,varname,default) make set of radio buttons
    %   which: index for handle arrays
    %   varname: name of field of struct S to update.
    %   default: choice of initial selection
    %   needs global vaiables: 
    %       outColourNames: 1 x N cell of strings of names
    %       outColours: N x 3 array of RGB values
        bgh(which) = uibuttongroup(parent, 'Position', [0 0 1 1],...
            'SelectionChangedFcn',{@bg_callback, varname});
        %control
        for i = 1:length(outColourNames)
            rdh(which,i) = uicontrol(bgh(which),'Style','radiobutton',...
                'String',outColourNames{i},...
                'UserData',reshape(outColours(i,:), [1,1,3]),...
                'Tag',lowhi{i},...
                'Units','normalized',...
                'FontSize',r.FontSize,...
                'Position',CalcPosHorz(i,length(outColourNames),0,0,1,1));
        end
        bgh(which).SelectedObject = rdh(which,default);
    end%function MakeRadio

%-------------------------------------------------------------------------
%Functions that update plots

    function ShowImages
        delete(imh);
        imin = imr.readFrame(S.frameno);
        if ~ismatrix(imin)
            imin = imin(:,:,1);
        end
        imout = S.outClass(normfn(double(imin)));
        if outGrey(pmh.Value)
            imout = imout(:,:,1);
        end
        imh(1) = imshow(imin, 'Parent', ax(1));
        imh(2) = imshow(imout, 'Parent', ax(2));
        title(ax(1), 'Input', 'FontSize', r.FontSize);
        title(ax(2), 'Output', 'FontSize', r.FontSize);
    end

    function DrawClip
        delete(histh)
        delete(lnh)
        histh = area(ax(3), pixelbins, log(pixelcounts));
        hold(ax(3),'on');
        xlabel(ax(3), 'Pixel value', 'FontSize', r.FontSize);
        ylabel(ax(3), 'log count', 'FontSize', r.FontSize);
        yl = ylim(ax(3));
        lnh(1) = plot(ax(3), S.inMin * [1, 1], yl, 'LineWidth', r.LineWidth,...
            'ButtonDownFcn', {@ln_callback, 1, 'inMin'}, 'Color', col{1});
        lnh(2) = plot(ax(3), S.inMax * [1, 1], yl, 'LineWidth', r.LineWidth,...
            'ButtonDownFcn', {@ln_callback, 2, 'inMax'}, 'Color', col{2});
    end

    function PlotNonlin
        x = 0:0.02:1;
        y = x .^ exp(S.logExponent);
        plot(ax(4), x, y, 'LineWidth', r.LineWidth, 'Color', col{3},...
            'ButtonDownFcn', {@ln_callback, 3, 'logExponent'});
        xlabel(ax(4), 'Input', 'FontSize', r.FontSize);
        ylabel(ax(4), 'Output', 'FontSize', r.FontSize);
    end

%-------------------------------------------------------------------------
%Functions that help with callbacks

    function DoPlay
       while Play && S.frameno < imr.lastfr
           changeFrameNumber(S.frameno + 1);
           WriteIm(imh(2).CData, S.frameno + 1);
       end %while Play
       Play=true;
       play_callback(pbh);
    end %function DoPlay

    function changeFrameNumber(frameNumber)
        S.frameno=frameNumber;
        set(edslh(1),'String',num2str(frameNumber));
        set(slh(1),'Value',frameNumber);
        ShowImages;
        drawnow;
    end

    function changeOutType(inttype,isgrey)
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
    end

    function MakeGrey(which)
        bgh(which).SelectedObject = rdh(which,str2double(bgh(which).SelectedObject.Tag));
        [rdh(which,2:7).Enable] = deal('off');
    end

    function MakeRGB(which)
        [rdh(which,2:7).Enable] = deal('on');
    end


end

