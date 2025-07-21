function fdf = calculate_evoked_spiketime_features(...
    evoked_spk_df, stimulations, evoked_response_start, evoked_response_end,...
    num_well_rows, num_well_cols, num_elec_rows, num_elec_cols)

% Function to bin evoked multi-unit array data.
% Inputs:
%   evoked_spk_df: electrodes x wells x time data frame of evoked spiketimes.
%   stimulations: stimulation tags.
%   evoked_response_start: post-stimulation start time to calculate response.
%   evoked_response_end: post-stimulation end time to calculate response.
%   num_well_rows: # of wells in a row of MEA plate.
%   num_well_cols: # of wells in a column of MEA plate.
%   num_elec_rows: # of rows of electrodes in a well of MEA plate.
%   num_elec_cols: # of columns of electrodes in a well of MEA plate.
% Outputs:
%   fdf.df: wells x 4 x time data frame of evoked features.
%       Features: evoked mean firing rate (Hz),
%                 time to peak response (s),
%                 evoked mean firing rate (% maximum),
%                 evoked spike count (% maximum) fano factor.

nwells = num_well_rows * num_well_cols; % total # of wells
nelecs = num_elec_rows * num_elec_cols; % total # of electrodes per well
nstimulations = size(stimulations, 2); % # of stimulations
ntime = size(evoked_spk_df, 3); % number of timepoints

% Post-stimulation time period
time_period = evoked_response_end - evoked_response_start;

bins = [0.005:0.02:2, 2]; % bins
nbins = size(bins, 2); % # of bins

% Pre-allocate for speed
df = zeros(nwells, 4, ntime);

for time = 1:ntime % for each timepoint

    for well = 1:nwells % for each well

        well_spikes = evoked_spk_df(:, well, time); % get spikes

        % Initialize variables and pre-allocate for speed
        nspikes = []; evoked_mfr = []; peak_time = [];
        stim_spikes = zeros(nelecs, nstimulations);

        for elec = 1:nelecs % for each electrode

            elec_spikes = well_spikes{elec}; % get spikes

            for stimulation = 1:nstimulations % for each stimulation

                % Calculate evoked responses
                spikes = elec_spikes(...
                    elec_spikes > stimulations(time, stimulation) + evoked_response_start &...
                    elec_spikes <= stimulations(time, stimulation) + evoked_response_end...
                    );
                sz = size(spikes, 2);
                if isempty(sz)
                    sz = 0;
                end
                nspikes = [nspikes; sz];
                evoked_mfr = [evoked_mfr; sz / time_period];
                stim_spikes(elec, stimulation) = sz;

                % Bin spikes
                count = zeros(nstimulations, nbins - 1); % initiate count
                for bin = 1:nbins - 1
                    spikes = elec_spikes(...
                        elec_spikes > stimulations(time, stimulation) + bins(1, bin) &...
                        elec_spikes <= stimulations(time, stimulation) + bins(1, bin + 1)...
                        );
                    sz = size(spikes, 2);
                    if isempty(sz)
                        sz = 0;
                    end
                    count(stimulation, bin) = sz;
                end

            end

            [~, peak] = max((mean(count, 'omitnan'))');
            peak_time = [peak_time; (bins(peak) + bins(peak + 1)) / 2];

        end

        % Format data
        mu = max(mean(stim_spikes)) / time_period; % maximum evoked response in well
        norm_mfr = (nspikes / mu) * 100; % normalized response
        df(well, 1, time) = mean(evoked_mfr, 'omitnan'); % evoked MFR (Hz)
        df(well, 2, time) = mean(peak_time, 'omitnan'); % time to peak response (s)
        df(well, 3, time) = mean(norm_mfr, 'omitnan'); % evoked MFR (% max.)
        df(well, 4, time) = var(norm_mfr, 'omitnan') / mean(norm_mfr, 'omitnan'); % evoked spike count (% max.) fano factor 
        
    end
end

fdf.df = df;