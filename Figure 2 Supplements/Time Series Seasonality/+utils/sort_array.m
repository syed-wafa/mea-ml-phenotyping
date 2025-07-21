function [array_out, leaforder] = sort_array(array_in, sorting_dimension)

% Function to sort observations of an array using hierarchical clustering.
% Inputs:
%   array_in: array of observations x features.
%   sorting_dimension: 1=sort based on rows, 2=sort based on columns.
% Outputs:
%   array_out: sorted array of observations x features.
%   leaforder: column vector of optimal leaf order for binary cluster tree.

% Transform dimensions
if sorting_dimension == 2
    array_in = array_in';
end

% Compute pairwise Euclidean distance between pairs of data points
distance = pdist(array_in, 'euclidean');

% Create a hierarchical binary cluster tree using the Ward linkage method
tree = linkage(array_in, 'complete');

% Compute optimal leaf order for hierarchical binary cluster tree
leaforder = (optimalleaforder(tree, distance))';

% Sort array
if sorting_dimension == 2
    array_out = (array_in(leaforder, :))'; % transform dimensions back
else
    array_out = array_in(leaforder, :);
end

end