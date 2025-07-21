function [idf, timepoints] = interpolate_data(df, div)

% Function to interpolate multi-unit array data.
% Inputs:
%   df: wells x features x time data frame.
%   div: day in vitro timepoints.
% Outputs:
%   idf: wells x features x time interpolated data frame.
%   timepoints: linear spacing of required timepoints.

nwells = size(df, 1); % number of wells
nfeatures = size(df, 2); % number of features
timepoints = min(div):1:max(div); % required query points

% Pre-allocate for speed
idf = NaN(nwells, nfeatures, size(timepoints, 2));

for feature = 1:nfeatures % for each feature
    for well = 1:nwells % for each well
        v = permute(df(well, feature, :), [1, 3, 2]); % corresponding values
        v(isnan(v)) = 0; % convert NaNs to zeros
        v(isinf(v)) = 0; % convert Infs to zeros
        vq = permute(interp1(div, v, timepoints, 'linear'), [1, 3, 2]); % required corresponding values
        idf(well, feature, :) = vq; % map onto data frame
    end
end