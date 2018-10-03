function [bgh, rdh] = radio(parent, data, varname, labels, vals, default)
%[bgh,rdh]=RADIO(parent,data,varname,labels,vals,default) make set of radio buttons
%   parent: parent figure/uipanel
%   data: object that carries GUI state (subclass of handle)
%   varname: name of property of DATA to update.
%   labels: 2D cell array of labels for radio buttons
%   vals: 2D cell array of values to assign to DATA.VARNAME
%   default: [i j] indices of default choice
%
%   DATA must have properties {opts_pnl, opts_btn}
%   DATA must have a method called Update with signature Update(OBJ,SRC)

bgh = uibuttongroup(parent, 'Position', [0 0 1 1],...
    'DeleteFcn', {@mygui.helpers.circDeleteFcn, 'SelectionChangedFcn'},...
    'SelectionChangedFcn', {@mygui.callback.btng, data, varname});
%control
siz = size(labels);
rdh(siz(1),siz(2)) = matlab.ui.control.UIControl;

for i = 1:siz(1)
    for j = 1:siz(2)
        rdh(i,j) = uicontrol(bgh, 'Style', 'radiobutton', data.opts_btn{:},...
            'String', labels{i,j}, 'UserData', vals{i,j},...
            'Position', mygui.helpers.CalcPos([i j], siz, [0, 0, 1, 1]));
    end
end

bgh.SelectedObject = rdh(default(1), default(2));

end%function MakeRadio
