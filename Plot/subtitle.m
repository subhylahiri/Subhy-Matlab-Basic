function [ax,h]=subtitle(fig, text, varargin)
%[ax,h]=SUBTITLE(text) Centers a title over a group of subplots.
%   Returns a handle to the title and the handle to an axis.
%   [ax,h]=subtitle(text)
%           returns handles to both the axis and the title.
%   ax=subtitle(text)
%           returns a handle to the axis only.
ax=axes(fig,'Units','Normal','Position',[.075 .075 .85 .85],'Visible','off');
ax.Title.Visible = 'on';
title(ax,text,varargin{:});
if (nargout < 2)
    return
end
h=ax.Title;

end

