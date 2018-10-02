function Update( obj, src )
%UPDATE Summary of this function goes here
%   Detailed explanation goes here

switch src.Style
    case 'slider'
        if src == obj.play_sl
            changeFrameNumber(obj.frameno);
        end
end

end

