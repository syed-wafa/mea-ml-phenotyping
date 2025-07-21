function fdf = calculate_spiketime_features(...
    spk_df, recording_times, sttc_window, nsimulations)

% Function to extract inter-spike interval and graph theory metrics from
% electrode spiketimes.
% Inputs:
%   spk_df: electrode x well x time data frame of spiketimes.
%   recording_times: time x 2 array of recording start and end times.
%   sttc_window: window for spike time tiling coefficient.
%   nsimulations: # of monte carlo simulations.
% Outputs:
%   fdf.features: wells x features x time data frame.
%       Order of features: (1) mean inter-spike interval, (2) STTC
%   fdf.elec_sttc: wells x time cell array, where each cell contains the
%   weighted adjacency matrix for all electrodes in that well.

nelecs = size(spk_df, 1); % # of electrodes in a well
nwells = size(spk_df, 2); % # of wells in a plate
ntime = size(spk_df, 3); % # of timepoints

nfeatures = 2; % total # of features
fdf.features = NaN(nwells, nfeatures, ntime);
fdf.elec_sttc = num2cell(NaN(nwells, ntime));

% Pre-allocate for speed
well_sttc = zeros(nwells, ntime);
well_node_degree = zeros(nwells, ntime);
well_path_length = zeros(nwells, ntime);

for time = 1:ntime % for each timepoint

    for well = 1:nwells % for each well

        % Pre-allocate for speed and initialize variables
        wdf = zeros(nelecs, nelecs);
        isi_vec = [];
        source = []; target = []; weight = [];
        elec_idx = [];

        for eleci = 1:nelecs % for electrode i

            dfi = (cell2mat(spk_df(eleci, well, time)))'; % spiketimes at electrode i
            ni = size(dfi, 1); % # of spikes at electrode i

            % Get vector of inter-spike intervals
            if isnan(dfi) | ni == 1
                isi_vec = [isi_vec; NaN];
            else
                isi_vec = [isi_vec; mean(diff(dfi), 'omitnan')];
            end

            for elecj = 1:nelecs % for electrode j

                elec_idx = [elec_idx; [eleci, elecj]];

                dfj = (cell2mat(spk_df(elecj, well, time)))'; % spiketimes at electrode j
                nj = size(dfj, 1); % # of spikes at electrode j

                % Define STTC to be 0 if there are no spikes
                if (any(isnan(dfi)) | any(isnan(dfj))) ||...
                        (any(isnan(dfi)) & any(isnan(dfj)))
                    wdf(eleci, elecj) = 0;
                elseif eleci == elecj % prevent self-connection
                    wdf(eleci, elecj) = 0;
                else

                    % Pre-allocate for speed
                    sig = zeros(nsimulations);

                    for sim = 1:nsimulations % for each monte carlo simulation

                        % Perform circular shift of spikes for significance
                        % testing
                        dfj_sigtest = circshift(dfj, sim);

                        % Calculate STTC for significance testing
                        sig(sim) = utils.sttc(ni, nj, sttc_window,...
                            (recording_times(time, :))', dfi, dfj_sigtest);

                    end
                    sig = prctile(sig, 95); % 95% significance threshold for STTC

                    % Calculate STTC between electrode i and j
                    fc = utils.sttc(ni, nj, sttc_window,...
                        (recording_times(time, :))', dfi, dfj);

                    % Only get significant connections
                    if abs(fc) > abs(sig)
                        if fc < 0
                            fc = 0;
                        end
                        wdf(eleci, elecj) = fc;
                    end

                end

                % Vectors for generating graphs for calculating average
                % path length
                source = [source; eleci];
                target = [target; elecj];
                weight = [weight; 1 - wdf(eleci, elecj)];

            end
        end

        fdf.elec_sttc{well, time} = num2cell(wdf);

        % Calculate average path length
        % idx = weight==0;
        % source(idx) = []; target(idx) = []; weight(idx) = [];
        [~, unique_nodes_idx] = unique(sort([source, target], 2, 'ascend'), 'rows', 'stable');
        g = graph(source(unique_nodes_idx), target(unique_nodes_idx), weight(unique_nodes_idx));
        sz = size(g.Nodes, 1);
        if sz < nelecs
            g = addnode(g, nelecs - sz);
        end
        d = distances(g, 'method', 'positive');
        % d(isinf(d)) = 0; d(isnan(d)) = 0;
        well_path_length(well, time) = mean(mean(d, 'omitnan'), 'omitnan');

        % Remove self-connections
        sz = size(elec_idx, 1);
        idx = [];
        for i = 1:sz
            if elec_idx(i, 1) == elec_idx(i, 2)
                idx = [idx; i];
            end
        end
        elec_idx(idx, :) = [];

        % Get unique connections so you don't count edges twice
        a = sort(elec_idx, 2);
        elec_idx = unique(a, 'rows', 'stable');

        sz = size(elec_idx, 1);
        vals = [];
        for i = 1:sz
            vals = [vals; wdf(elec_idx(i, 1), elec_idx(i, 2))];
        end

        fdf.features(well, 1, time) = mean(isi_vec, 'omitnan'); % calculate average ISI

        well_sttc(well, time) = mean(vals, 'omitnan'); % calculate STTC

        % Calculate average node degree
        nd = [];
        for elec = 1:nelecs
            ndvals = vals(elec_idx(:, 1)==elec);
            ndvals(ndvals~=0) = 1;
            nd = [nd; sum(ndvals)];
        end
        well_node_degree(well, time) = mean(nd, 'omitnan');

        % Calculate additional graph theory metrics
        gtbl = utils.calculate_graph_metrics(wdf);
        fdf.features(well, 5, time) = gtbl.FinalTableNetworkData.numberModules; % average # of modules
        fdf.features(well, 6, time) = gtbl.FinalTableNetworkData.Modularity; % average modularity
        fdf.features(well, 7, time) = gtbl.FinalTableNetworkData.net_clus; % average clustering coefficient

    end

    fdf.features(:, 2, time) = well_sttc(:, time); % average STTC
    fdf.features(:, 3, time) = well_node_degree(:, time); % node degree
    fdf.features(:, 4, time) = well_path_length(:, time); % average path length

end