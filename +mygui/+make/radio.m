function [bgh, rdh] = radio(parent, data, varname, labels, vals, default, varargin)
%[bgh,rdh]=RADIO(parent,which,varname,default) make set of radio buttons
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   labels: 2D cell array of labels for radio buttons
%   vals: 2D cell array of values to assign to DATA.VARNAME
%   default: [i j] indices of default choice
%   DATA must have a method called Update with signature Update(OBJ,SRC)

bgh = uibuttongroup(parent, 'Position', [0 0 1 1],...
    'SelectionChangedFcn', {@bg_callback, data, varname});
%control
siz = size(labels);
rdh(siz(1),siz(2)) = matlab.ui.control.UIControl;

for i = 1:siz(1)
    for j = 1:siz(2)
        rdh(i,j) = uicontrol(bgh, 'Style', 'radiobutton', varargin{:},...
            'String', labels{i,j}, 'UserData', vals{i,j},...
            'Position', mygui.CalcPos([i j], siz, [0, 0, 1, 1]));
    end
end
bgh.SelectedObject = rdh(which, default(1), default(2));
end%function MakeRadio
