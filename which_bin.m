function [ bin_num ] = which_bin( vals, edges )
%bin_num=WHICH_BIN(vals, edges) which_bin is each value in
%   Detailed explanation goes here

if iscolumn(vals)
    vals = vals';
end
if isrow(edges)
    edges= edges';
end


[bin_num, ~] = find(diff(vals < edges, 1, 1));

end

