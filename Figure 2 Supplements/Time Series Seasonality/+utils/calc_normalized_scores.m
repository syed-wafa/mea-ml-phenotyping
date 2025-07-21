function [baseline_ndf, signal_ndf] = calc_normalized_scores(...
    baseline_df, signal_df)

% Function to normalize multi-unit array data.
% Inputs:
%   baseline_df: wells x features x time data frame of baseline.
%   signal_df: wells x features x time data frame of signal.
% Outputs:
%   baseline_ndf: wells x features x time normalized scores of baseline.
%   signal_ndf: wells x features x time normalized scores of signal.

nfeatures = size(baseline_df, 2); % number of features
ntimepoints = size(baseline_df, 3); % number of timepoints

% Pre-allocate for speed
baseline_ndf = NaN(size(baseline_df, 1), nfeatures, ntimepoints);
signal_ndf = NaN(size(signal_df, 1), nfeatures, ntimepoints);

% Caculate normalized scores
for feature = 1:nfeatures % for each feature

    % Get the mean of the baseline
    baseline_mu = mean(permute(baseline_df(:, feature, :), [1, 3, 2]));

    % Normalize baseline data frame
    baseline_ndf(:, feature, :) = permute(...
        permute(baseline_df(:, feature, :), [1, 3, 2]) - baseline_mu,...
        [1, 3, 2]);

    % Normalize signal data frame
    signal_ndf(:, feature, :) = permute(...
        permute(signal_df(:, feature, :), [1, 3, 2]) - baseline_mu,...
        [1, 3, 2]);

end