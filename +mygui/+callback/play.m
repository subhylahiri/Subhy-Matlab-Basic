function play(source, ~, data)
%PLAY(source,~,data) callback for play button
%   source: handle of object that called back
%   data: object that carries GUI state (subclass of handle)
%   DATA must have properties {frameno, firstfr, lastfr, play} and methods {Play}

data.play = ~data.play;
if data.play
    source.String = 'Pause';
    data.Play();
else
    source.String = 'Play';
end %if


end %sl1_callback
