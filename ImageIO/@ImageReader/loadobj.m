function [ h ] = loadobj( a )
%LOADOBJ replace tracker struct with TrackerData object
%   Detailed explanation goes here

h=a;
h.tracker=TrackerData(a.tracker);

end

