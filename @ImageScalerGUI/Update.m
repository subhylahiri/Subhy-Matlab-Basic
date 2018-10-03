function Update( obj, src )
%UPDATE Summary of this function goes here
%   Detailed explanation goes here

if isa(src, 'matlab.graphics.chart.primitive.Line')
    if src == obj.line(3)
        if isvector(obj.logExponent)
            obj.logExponent = log(log(obj.logExponent(2)) / log(obj.logExponent(1)));
        end
        obj.ChangeNonlin;
    else
        obj.ChangeClip;
    end
    obj.normfn = obj.CalcNorm();
    obj.ChangeImages;
    return;
end

if isa(src, 'matlab.ui.container.ButtonGroup')
    obj.normfn = obj.CalcNorm();
    obj.ChangeImages;
    return;
end

switch src.Style
    case 'slider'
        if src == obj.play_sl
            obj.ChangeImages;
            %
            im = obj.img(1).CData;
            prev = obj.pixelcounts * obj.doHist * obj.play;  % accumulate?
            obj.pixelcounts = prev + [histcounts(im(:), obj.pixelbins), 0];
            obj.pixelcounts(end) = obj.pixelcounts(end-1);
            obj.ChangeClip;
            %
            if ~isempty(obj.imw) && obj.doWrite
                obj.imw.writeFrame(obj.img(2).CData, obj.frameno)
            end
        else
            obj.ChangeNonlin;
            obj.normfn = obj.CalcNorm();
            obj.ChangeImages;
        end
    case 'edit'
        obj.ChangeClip;
        obj.normfn = obj.CalcNorm();
        obj.ChangeImages;
    case 'popupmenu'
        inttype = obj.intypes{obj.outChoice};
        S.outClass = str2func(inttype);
        S.outMin = double(intmin(inttype));
        S.outMax = double(intmax(inttype));
        if obj.outGrey(obj.outChoice)
            obj.btng(1).SelectedObject = obj.radio(1, str2double(obj.btng(1).SelectedObject.Tag));
            obj.btng(2).SelectedObject = obj.radio(2, str2double(obj.btng(2).SelectedObject.Tag));
            [obj.radio(1,2:7).Enable] = deal('off');
            [obj.radio(2,2:7).Enable] = deal('off');
        else
            [obj.radio(1,2:7).Enable] = deal('on');
            [obj.radio(2,2:7).Enable] = deal('on');
        end
        obj.normfn = obj.CalcNorm();
end

end

