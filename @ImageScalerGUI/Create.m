function Create( obj )
%CREATE Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(obj.figure) && obj.figure.isvalid
    return;
end

%Create figure
obj.figure = figure('Units', 'normalized', 'OuterPosition', [0 0.1 1 0.9]);

%Create panels

obj.panels(1) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0 0.1 0.5 0.9],...
                'Title', 'Images');

obj.panels(2) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.50 0.4 0.25 0.6],...
                'Title', 'Clipping');

obj.panels(3) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.75 0.4 0.25 0.6],...
                'Title', 'Nonlinearity');

obj.panels(4) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.5 0.25 0.4 0.15],...
                'Title', 'Background');

obj.panels(5) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.5 0.10 0.4 0.15],...
                'Title', 'Foreground');

obj.panels(6) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.9 0.25 0.1 0.15],...
                'Title', 'Pixel type');

obj.panels(7) = uipanel(obj.figure, obj.opts_pnl{:},...
                'Position', [0.9 0.10 0.1 0.15],...
                'Title', 'Output');
%Create axes
obj.axes(1) = axes(obj.panels(1), obj.opts_ax{:},...
    'OuterPosition', [0 0.5 1 0.5]);%left bottom width height
obj.axes(2) = axes(obj.panels(1), obj.opts_ax{:},...
    'OuterPosition', [0 0.0 1 0.5]);%left bottom width height

obj.axes(3) = axes(obj.panels(2), obj.opts_ax{:},...
    'OuterPosition', [0 0.2 1 0.8]);%left bottom width height
obj.axes(4) = axes(obj.panels(3), obj.opts_ax{:},...
    'OuterPosition', [0 0.2 1 0.8]);%left bottom width height

arrayfun(@(x) hold(x, 'on'), obj.axes);

obj.firstfr = obj.imr.firstfr;
obj.lastfr = obj.imr.lastfr;
obj.frameno = obj.firstfr;

obj.outMin = double(intmin(func2str(obj.outClass)));
obj.outMax = double(intmax(func2str(obj.outClass)));

obj.panels(8) = uipanel(obj.figure, obj.opts_pnl{:},...
    'Position', [0, 0, 1, 0.1], 'Title', 'Frame');
[obj.play_sl, obj.play_pb, obj.play_ed] = mygui.make.play(obj.panels(8), obj);

[obj.panels(9:10), obj.edit] = mygui.make.editbox(obj.panels(2), obj,...
    {'inMin', 'inMax'}, [0, 0, 1, 0.2]);

[obj.panels(11), obj.slider] = mygui.make.slider(obj.panels(3), obj,...
    'logExponent', [0, 0, 1, 0.2], -4, 4);

outColours = num2cell(obj.outColours, 2)';
outColours = cellfun(@(x) reshape(x, [1 1 3]), outColours, 'UniformOutput', false);

[obj.btng(1), obj.radio(1,1:8)] = mygui.make.radio(obj.panels(4), obj, 'bkgnd', obj.outColourNames, outColours, [1 1]);
[obj.btng(2), obj.radio(2,1:8)] = mygui.make.radio(obj.panels(5), obj, 'frgnd', obj.outColourNames, outColours, [1 8]);
[obj.radio(1,1:4).Tag] = deal('1');
[obj.radio(1,5:8).Tag] = deal('8');
[obj.radio(2,1:4).Tag] = deal('1');
[obj.radio(2,5:8).Tag] = deal('8');

obj.pmenu = uicontrol(obj.panels(6), 'Style', 'popupmenu', obj.opts_btn{:},...
    'Position', [0 0 1 1],'String', obj.outTypes,...
    'CallBack', {@mygui.callback.pmenu, obj, 'outChoice'});

obj.tog = mygui.make.toggle(obj.panels(7), obj, 'doWrite', [0 0 1 1]);
obj.tog.String = 'Write?';

imin = obj.imr.readFrame(obj.frameno);
if ~ismatrix(imin)
    imin = imin(:, :, 1);
end

[obj.pixelcounts, obj.pixelbins] = histcounts(imin(:));
obj.pixelcounts(end+1) = obj.pixelcounts(end);
obj.inMin = obj.pixelbins(1);
obj.inMax = obj.pixelbins(end);
obj.normfn = obj.CalcNorm();

imout = obj.normfn(double(imin));
if obj.outGrey(obj.outChoice)
    imout = imout(:, :, 1);
end
obj.img(1) = imshow(imin, 'Parent', obj.axes(1));
obj.img(2) = imshow(imout, 'Parent', obj.axes(2));
title(obj.axes(1), 'Input');
title(obj.axes(2), 'Output');

obj.area = area(obj.axes(3), obj.pixelbins, log(obj.pixelcounts));
hold(obj.axes(3), 'on');
xlabel(obj.axes(3), 'Pixel value');
ylabel(obj.axes(3), 'log count');
yl = ylim(obj.axes(3));
obj.line(1) = plot(obj.axes(3), obj.inMin * [1, 1], yl, 'LineWidth', obj.LineWidth,...
    'ButtonDownFcn', {@mygui.callback.line, obj, 'inMin', ''}, 'Color', obj.col{1});
obj.line(2) = plot(obj.axes(3), obj.inMax * [1, 1], yl, 'LineWidth', obj.LineWidth,...
    'ButtonDownFcn', {@mygui.callback.line, obj, 'inMax', ''}, 'Color', obj.col{2});

x = 0:0.02:1;
y = x .^ exp(obj.logExponent);
obj.line(3) = plot(obj.axes(4), x, y, 'LineWidth', obj.LineWidth, 'Color', obj.col{3},...
    'ButtonDownFcn', {@mygui.callback.line, obj, 'logExponent', 'logExponent'});
xlabel(obj.axes(4), 'Input');
ylabel(obj.axes(4), 'Output');
    
end

