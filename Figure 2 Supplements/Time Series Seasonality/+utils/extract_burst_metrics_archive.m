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

        isi_cv = []; spike_count = [];
        for elec = 1:nelecs % for each electrode

            df = spk_df{elec, well, time};

            if ~isnan(df) & size(df, 2) >= 3

                detect_bursts = utils.PS_method(df, si_threshold);

                if ~isnan(detect_bursts(1, 1))
                    nbursts = size(detect_bursts, 1);
                    for nb = 1:nbursts
                        spikes = df(1, detect_bursts(nb, 1):detect_bursts(nb, 2));
                        isi = diff(spikes');
                        isi_cv = [isi_cv; std(isi) / mean(isi)];
                        spike_count = [spike_count; detect_bursts(nb, 4)];
                    end
                end

            end

        end

        % Mean ISI CV within bursts
        if ~isempty(isi_cv)
            if size(isi_cv, 1) > 1
                fdf.df(well, 1, time) = mean(isi_cv);
            else
                fdf.df(well, 1, time) = isi_cv;
            end
        end

        % Burst spike count fano factor
        if ~isempty(spike_count)
            if size(spike_count, 1) > 1
                fdf.df(well, 2, time) = var(spike_count) / mean(spike_count);
            end
        end

    end

end