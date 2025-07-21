function [baseline_ndf, signal_ndf, baseline_df, signal_df] = normalize_data(...
    baseline_df, signal_df, timepoints, div_first, div_final)

% Function to normalize multi-unit array data.
% Inputs:
%   baseline_df: wells x features x time data frame of baseline.
%   signal_df: wells x features x time data frame of signal.
%   timepoints: list of days in vitro.
%   div_first: first required timepoint.
%   div_final: final required timepoint.
% Outputs:
%   baseline_ndf: wells x features x time normalized data frame of baseline.
%   signal_ndf: wells x features x time normalized data frame of signal.

% Limit data to defined timepoints
% idx_first = find(timepoints==div_first);
% idx_final = find(timepoints==div_final);
% baseline_df = baseline_df(:, :, idx_first:idx_final);
% signal_df = signal_df(:, :, idx_first:idx_final);

nfeatures = size(baseline_df, 2); % number of features
ntimepoints = size(baseline_df, 3); % number of timepoints

% Pre-allocate for speed
baseline_ndf = NaN(size(baseline_df, 1), nfeatures, ntimepoints);
signal_ndf = NaN(size(signal_df, 1), nfeatures, ntimepoints);

% Normalize data
for feature = 1:nfeatures % for each feature

    c = 0; % define constant for normalization

    % Get the mean of the final timepoint
    baseline_mu = mean(baseline_df(:, feature, end), 'omitnan');

    % Update constant
    if baseline_mu == 0
        c = 1;
    end

    % Normalize baseline data frame
    baseline_ndf(:, feature, :) = ((baseline_df(:, feature, :) + c) - (baseline_mu + c)) /...
        (baseline_mu + c);

    % Normalize signal data frame
    signal_ndf(:, feature, :) = ((signal_df(:, feature, :) + c) - (baseline_mu + c)) /...
        (baseline_mu + c);

end