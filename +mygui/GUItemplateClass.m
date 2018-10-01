classdef GUItemplateClass < handle
    %GUITEMPLATECLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Handle arrays:
        figure = matlab.ui.Figure.empty;
        axes = matlab.graphics.axis.Axes
        panels = matlab.ui.container.Panel;
        btng = matlab.ui.container.ButtonGroup.empty;
        radio = matlab.ui.control.UIControl.empty;
        editbox = matlab.ui.control.UIControl.empty;
        push = matlab.ui.control.UIControl.empty;
        tog = matlab.ui.control.UIControl.empty;
        slider = matlab.ui.control.UIControl.empty;
        slider_ed = matlab.ui.control.UIControl.empty;
        slider_pb = matlab.ui.control.UIControl.empty;
        img = matlab.graphics.primitive.Image.empty;
        line = matlab.graphics.chart.primitive.Line.empty;
        area = matlab.graphics.chart.primitive.Area.empty;
    end

    properties
        opts = struct('FontSize', 16, 'BtFontSize', 16, 'LineWidth', 2,...
            'TitlePosition', 'centertop', 'Units', 'normalized');
    end
    
    properties (SetObservable)
        FontSize = 16;
        BtnFontSize = 16;
        LineWidth = 2;
        TitlePosition = 'centertop';
        Units = 'normalized';
    end
    
    methods
        function setupListeners(obj)
            %obj.setupListeners create listeners for changes to properties
            props = [obj.findprop('FontSize'),...
                obj.findprop('BtnFontSize'),...
                obj.findprop('LineWidth'),...
                obj.findprop('TitlePosition'),...
                obj.findprop('Units')];
            obj.addlistener(props, 'PostSet', @GUItemplateClass.handleEvents);
        end
    end
    
    methods (Static)
        function handleEvents(src, event)
            obj = event.AffectedObject;
            switch src.Name
                case 'FontSize'
                    [obj.axes.FontSize] = deal(obj.FontSize);
                    [obj.panels.FontSize] = deal(obj.FontSize);
                case 'BtnFontSize'
                    [obj.editbox.FontSize] = deal(obj.BtnFontSize);
                    [obj.push.FontSize] = deal(obj.BtnFontSize);
                    [obj.tog.FontSize] = deal(obj.BtnFontSize);
                    [obj.slider_ed.FontSize] = deal(obj.BtnFontSize);
                    [obj.slider_pb.FontSize] = deal(obj.BtnFontSize);
                    [obj.radio.FontSize] = deal(obj.BtnFontSize);
                case 'LineWidth'
                    [obj.lines.LineWidth] = deal(obj.LineWidth);
                case 'TitlePosition'
                    [obj.panels.TitlePosition] = deal(obj.TitlePosition);
            end
        end
    end
    
    properties (Dependent)
        opts_pnl
        opts_btn
    end
    
    methods%get dependent properties
        %
        function val = get.opts_pnl(obj)
            val = {'FontSize', obj.opts.FontSize, 'TitlePosition', obj.TitlePosition,...
                'Units', obj.Units};
        end
        %
        function val = get.opts_btn(obj)
            val = {'FontSize', obj.opts.BtnFontSize, 'Units', obj.Units};
        end
    end
    
    methods (Abstract)
        Update(obj, src)
        Create(obj)
    end
    
end

