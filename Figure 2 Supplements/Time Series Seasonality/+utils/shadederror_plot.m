function [mu_handle, mu] = shadederror_plot(array_in, time, mu_color, error_color, line_width, marker_size)

% Function to generate shaded error plots for timeseries data.
% Inputs:
%   array_in: array of observations (rows) x time (columns).
%   time: row vector of timepoints.
%   mu_color: color of mean line.
%   error_color: color of shaded error region.
%   line_width: width of line.
%   marker_size: size of line marker.
% Outputs:
%   mu_handle: handle of mean line.
%   mu: mean of array.
%   shaded error plot of timeseries data.

mu = mean(array_in, 'omitnan'); % mean

sem = std(array_in, 'omitnan') ./ sqrt(size(array_in, 1) - 1); % standard error of mean
sem(isnan(sem)) = 0; sem(isinf(sem)) = 0; % update standard error of mean

mu(isnan(mu)) = 0;
upper_limit = mu + sem; % upper_limit
lower_limit = mu - sem; % lower_limit

hold on

% Plot limits and shade in the region
plot(time, lower_limit, 'color', error_color, 'linewidth', 0.00001);
plot(time, upper_limit, 'color', error_color, 'linewidth', 0.00001);
fill([time, fliplr(time)], [lower_limit, fliplr(upper_limit)], error_color,...
    'linewidth', 0.00001, 'edgecolor', error_color, 'facealpha', 0.5);

% Plot mean line
mu_handle = plot(time, mu, 'color', mu_color,...
    'linestyle', '-', 'linewidth', line_width,...
    'marker', '.', 'markersize', marker_size,...
    'markerfacecolor', mu_color, 'markeredgecolor', mu_color);

end