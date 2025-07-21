function fdf = extract_burst_metrics(spk_df, si_threshold)

% Function to extract burst metrics from electrode spiketimes.
% Inputs:
%   spk_df: electrode x well x time data frame of spiketimes.
%   si_threshold: surprise index threshold.
% Outputs:
%   fdf.df: wells x 2 x time data frame of burst features.
%       features include - ISI CV within bursts, Burst spike count fano factor.

nelecs = size(spk_df, 1); % # of electrodes in a well
nwells = size(spk_df, 2); % # of wells in a plate
ntime = size(spk_df, 3); % # of timepoints

% Pre-allocate for speed
fdf.df = NaN(nwells, 2, ntime);

for time = 1:ntime % for each timepoint

    for well = 1:nwells % for each well

        isi = []; spike_count = [];
        for elec = 1:nelecs % for each electrode

            df = spk_df{elec, well, time};

            if ~isnan(df) & size(df, 2) >= 2

                [burstctr, burstind, burstSurprise, surprise] = utils.burstNE(df, si_threshold, 1);
                [bts, bns, burst] = utils.PSconvert(df, burstind);
                nbursts = size(bns, 1);

                if ~isnan(bns) & nbursts >= 1
                    spike_count = [spike_count; bns];

                    for n = 1:nbursts
                        burst_start = burst(n).strt;
                        burst_end = burst(n).stp;
                        spike_idx = find(df >= burst_start & df <= burst_end);
                        spike_times = df(1, spike_idx);
                        isi = [isi; diff(spike_times')];
                    end

                end

            end

        end

        %ISI CV within bursts
        if size(isi, 1) > 1
            fdf.df(well, 1, time) = std(isi) / mean(isi);
        end

        % Burst spike count fano factor
        if size(spike_count, 1) > 1
            fdf.df(well, 2, time) = var(spike_count) / mean(spike_count);
        end

    end

end