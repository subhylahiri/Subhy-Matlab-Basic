function [ c ] = struct2pv( s )
%STRUCT2PV Summary of this function goes here
%   Detailed explanation goes here

c=[fields(s) struct2cell(s)]';

c=c(:)';

end

