function [control_df, disease_df, timebins] = bin_and_normalize_spikes(tdf,...
    control_wells, disease_wells,...
    stimulations, normalize, bin,...
    pre_stimulus, post_stimulus,...
    num_well_rows, num_well_cols,...
    num_elec_rows, num_elec_cols)

% Function to bin evoked multi-unit array data.
% Inputs:
%   tdf: electrodes x wells x time data frame.
%   control_wells: wells for control.
%   disease_wells: wells for disease.
%   stimulations: stimulation times.
%   normalize: 0 (no) or 1 (yes). 
%   bin: time bins (in seconds).
%   pre_stimulus: time (in seconds) before first stimulus.
%   post_stimulus: time (in seconds) after last stimulus.
%   num_well_rows: # of rows in MEA plate.
%   num_well_cols: # of columns in MEA plate.
%   num_elec_rows: # of electrode rows per well.
%   num_elec_cols: # of electrode columns per well.
% Outputs:
%   control_df: electrodes x bins x wells data frame for control.
%   disease_df: electrodes x bins x wells data frame for disease.
%   timebins: number of days in vitro x timebins array.

nwells = num_well_rows * num_well_cols; % total # of wells
nelecs = num_elec_rows * num_elec_cols; % total # of electrodes per well
nstimulations = size(stimulations, 2); % # of stimulations
ndiv = size(tdf, 3); % number of days in vitro

% Total recording time
total_time = (stimulations(1, nstimulations) - stimulations(1, 1)) +...
    (pre_stimulus + post_stimulus);

time_bins = bin:bin:total_time; % vector of binned time periods
nbins = size(time_bins, 2); % number of bins

% Pre-allocate for speed
df = zeros(nelecs, nbins, nwells, ndiv);
timebins = zeros(ndiv, nbins);

% Bin spikes
for div = 1:ndiv % for each day in vitro

    % Required time bins
    timebins(div, :) = time_bins + stimulations(div, 1) - pre_stimulus;

    for well = 1:nwells % for each well

        well_spikes = tdf(:, well, div); % get spikes

        for elec = 1:nelecs % for each electrode

            elec_spikes = well_spikes{elec}; % get spikes

            % Limit spikes to required epoch
            elec_spikes = elec_spikes(...
                elec_spikes >= stimulations(div, 1) - pre_stimulus &...
                elec_spikes <= stimulations(div, nstimulations) + post_stimulus);

            count = 0; % initiate count
            for b = 1:nbins % for each bin

                % Calculate # of spikes
                count = count + 1;
                if count == 1
                    df(elec, b, well, div) = sum(elec_spikes <= timebins(div, b));
                else
                    df(elec, b, well, div) = sum(elec_spikes <= timebins(div, b) &...
                        elec_spikes > timebins(div, b - 1));
                end
            end
        end
    end
end

% Normalize spike counts
if normalize == 1
    for div = 1:ndiv % for each day in vitro
        for well = 1:nwells % for each well
            df(:, :, well, div) = ...
                df(:, :, well, div) / max(mean(df(:, :, well, div))) * 100;
        end
    end
end

control_df = df(:, :, control_wells, :);
disease_df = df(:, :, disease_wells, :);