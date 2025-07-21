function struct_out = mea_drug_preprocess_pipeline(os,...
    nm_directory, nb_directory, spk_directory, evoked_spk_directory,...
    nwells, nfeatures, nactive_elecs, active_elecs_idx,...
    num_well_rows, num_well_cols, num_elec_rows, num_elec_cols,...
    si_threshold, sttc_window, nsimulations, nstimulations,...
    evoked_response_start, evoked_response_end, div, div_first, div_final,...
    control_wells, disease_wells, genotype, diff_id)

% Function to extract and pre-process MEA data.
% Inputs:
%   os: operating system ('Windows' or 'Mac OS').
%   nm_directory: name of directory containing neural metrics .mat files.
%   nb_directory: name of directory containing network burst lists .csv files.
%   spk_directory: name of directory containing spontaneous .spk files.
%   evoked_spk_directory: name of directory containing evoked .spk files.
%   nwells: total # of wells in MEA plate.
%   nfeatures: original # of neural metric features in .mat files.
%   nactive_elecs: minimum # of active electrodes for inclusion.
%   active_elecs_idx: active electrode feature index in neural metrics .mat files.
%   num_well_rows: # of wells in a row of MEA plate.
%   num_well_cols: # of wells in a column of MEA plate.
%   num_elec_rows: # of rows of electrodes in a well of MEA plate.
%   num_elec_cols: # of columns of electrodes in a well of MEA plate.
%   si_threshold: burst surprise index threshold.
%   sttc_window: window (in seconds) for spike time tiling coefficient.
%   nsimulations: # of monte carlo simulations.
%   nstimulations: # of stimulations.
%   evoked_response_start: post-stimulation start time to calculate response.
%   evoked_response_end: post-stimulation end time to calculate response.
%   div: day in vitro timepoints.
%   div_first: first day in vitro.
%   div_final: final day in vitro.
%   control_wells: control well indices.
%   disease_wells: disease well indices.
%   genotype: numeric genotype identifier.
%   diff_id: numeric plate number or differentiation identifier.

% Extract neural metrics data from neural metrics .mat files
neural_metrics = utils.extract_neural_metrics(os, nm_directory, nwells, nfeatures);

% Extract and calculate mean inter-network burst interval from network 
% burst list .csv files
network_bursts = utils.extract_nb_metrics(os, nb_directory, nwells);

% Extract spiketimes for each electrode from .spk files
struct_out.spk = utils.extract_spk_spiketimes(os, spk_directory, network_bursts.recording_times,...
    num_well_rows, num_well_cols, num_elec_rows, num_elec_cols);

% Extract burst metrics for each electrode from .spk files
bursts = utils.extract_burst_metrics(struct_out.spk.df, si_threshold);

% Calculate mean inter-spike interval and graph theory metrics
spk_features = utils.calculate_spiketime_features(...
    struct_out.spk.df, network_bursts.recording_times, sttc_window, nsimulations);

if ~isnan(evoked_spk_directory)

    % Extract evoked spiketimes for each electrode from evoked .spk files
    evoked_spk = utils.extract_evoked_spk_spiketimes(...
        os, evoked_spk_directory, nstimulations,...
        num_well_rows, num_well_cols, num_elec_rows, num_elec_cols);

    % Calculate evoked metrics
    evoked_spk_features = utils.calculate_evoked_spiketime_features(evoked_spk.df,...
        evoked_spk.stimulations, evoked_response_start, evoked_response_end,...
        num_well_rows, num_well_cols, num_elec_rows, num_elec_cols);

    % Display order of files loaded
    disp(table(char(neural_metrics.filenames),...
        char(network_bursts.filenames),...
        char(struct_out.spk.filenames),...
        char(evoked_spk.filenames),...
        'variablenames', {...
        'Neural metrics .mat files loaded',...
        'Network burst lists .csv files loaded',...
        '.spk files loaded',...
        'Evoked .spk files loaded'...
        }));

else

    % Define dummy evoked metrics
    evoked_spk_features.df = NaN(num_well_rows * num_well_cols, 4,...
        size(neural_metrics.df, 3));

    % Display order of files loaded
    disp(table(char(neural_metrics.filenames),...
        char(network_bursts.filenames),...
        char(struct_out.spk.filenames),...
        'variablenames', {...
        'Neural metrics .mat files loaded',...
        'Network burst lists .csv files loaded',...
        '.spk files loaded'...
        }));

end

% Concatenate features
struct_out.df = cat(2, neural_metrics.df, bursts.df, network_bursts.df,...
    spk_features.features, evoked_spk_features.df);