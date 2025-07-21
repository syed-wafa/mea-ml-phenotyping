function [df] = active_elec_exclusion(df, nelecs, feature_idx)

% Function to exclude wells based on active electrode criterion.
% Inputs:
%   df: wells x features x time data frame.
%   div: required timepoint.
%   nelecs: minimum number of active electrodes required.
%   feature_idx: feature index of the number of active electrodes.
% Outputs:
%   df: processed wells x features x time data frame.

% Initialize variables
remove_idx = [];

nwells = size(df, 1); % number of wells
ntimepoints = size(df, 3); % number of timepoints

for well = 1:nwells % for each well
    if df(well, feature_idx, ntimepoints) < nelecs
        remove_idx = [remove_idx; well]; % index of well to exclude
    end
end

% Remove wells from data frame
df(remove_idx, :, :) = [];