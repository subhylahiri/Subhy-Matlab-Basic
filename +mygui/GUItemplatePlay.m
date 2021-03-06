classdef GUItemplatePlay < mygui.GUItemplateClass
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        frameno = 1;
        firstfr = 1;
        lastfr = 1;
        play = false;
    end

    properties
        play_sl = matlab.ui.control.UIControl.empty;
        play_pb = matlab.ui.control.UIControl.empty;
        play_ed = matlab.ui.control.UIControl.empty;
    end
    methods
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
    
end

