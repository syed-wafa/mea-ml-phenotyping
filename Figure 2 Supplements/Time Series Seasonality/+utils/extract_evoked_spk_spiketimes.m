function fdf = extract_evoked_spk_spiketimes(os, dirname, nstimulations,...
    num_well_rows, num_well_cols, num_elec_rows, num_elec_cols)

% Function to extract evoked electrode spike times from evoked .spk files.
% Inputs:
%   os: operating system.
%   dirname: name of directory containing evoked .spk files.
%   nstimulations: # of stimulations
%   num_well_rows: # of wells in a row of MEA plate.
%   num_well_cols: # of wells in a column of MEA plate.
%   num_elec_rows: # of rows of electrodes in a well of MEA plate.
%   num_elec_cols: # of columns of electrodes in a well of MEA plate.
% Outputs:
%   fdf.df: electrode x well x time data frame of evoked spiketimes.
%   fdf.filenames: filenames (order of files loaded).
%   fdf.stimulations: time x # of stimulations data frame of stimulation
%   tags.

if strcmp(os, 'Mac OS')
    delim = '/';
elseif strcmp(os, 'Windows')
    delim = '\';
end

currentdir = pwd; % current directory
cd(dirname); % change directory

files = dir('*.spk'); % .spk files in current folder
nfiles = size(files, 1); % # of .spk files

nwells = num_well_rows * num_well_cols; % total # of wells
nelecs = num_elec_rows * num_elec_cols; % total # of electrodes per well

% Pre-allocate for speed
time = num2cell(NaN(1, nfiles));
filenames = num2cell(NaN(nfiles, 1));
df = num2cell(NaN(nelecs, nwells, nfiles));
stimulations = NaN(nfiles, nstimulations);

for file = 1:nfiles % for each evoked .spk file

    % Get timestamps of each individual .spk file
    current_file = files(file).date;
    time(:, file) = cellstr(current_file);

    % Get names of each individual .spk file
    current_file = files(file).name;
    filenames(file, :) = cellstr(current_file);

    % Read data
    file_data = AxisFile(strcat(pwd, delim, current_file));

    % Get stimulation tags
    stimulations(file, :) = sort([file_data.StimulationEvents(:).EventTime]);

    % Extract all spike data
    spike_data = file_data.SpikeData.LoadData;
    spike_data = [spike_data{:, :, :, :}];

    % Get channel mapping information for each spike (well row, well
    % column, electrode column, and electrode row)
    
    n = size(spike_data, 2); % number of spikes
    channel_map = NaN(n, 1);
    for spike = 1:n
        channel_map(spike, 1) = spike_data(spike).Channel.WellRow;
        channel_map(spike, 2) = spike_data(spike).Channel.WellColumn;
        channel_map(spike, 3) = spike_data(spike).Channel.ElectrodeColumn;
        channel_map(spike, 4) = spike_data(spike).Channel.ElectrodeRow;
    end

    % Format evoked spiketimes into electrode x well x time data frame.
    w = 0;
    for well_row = 1:num_well_rows % for each well row
        for well_col = 1:num_well_cols % for each well column
            w = w + 1;
            e = 0;
            for elec_col = 1:num_elec_cols % for each electrode column
                for elec_row = 1:num_elec_rows % for each electrode row
                    e = e + 1;
                    template = [well_row, well_col, elec_col, elec_row];
                    template_match = any(all(bsxfun(@eq, channel_map, permute(template, [3 2 1])), 2), 3);
                    template_match = find(template_match);
                    if ~isempty(template_match)
                        t = horzcat(spike_data(template_match).GetTimeVector);
                        t = t(1, :);
                        if ~isempty(t) == 1
                            df{e, w, file} = t;
                        end
                    end
                end
            end
        end
    end
end

% % Sort time-points in ascending order
% [~, timeorder_index] = ...
%     sort(datenum(time, 'dd-mmm-yyyy hh:MM:ss'), 1, 'ascend');
% fdf.df = df(:, :, timeorder_index);
% fdf.filenames = filenames(timeorder_index);
% fdf.stimulations = stimulations(timeorder_index, :);

fdf.df = df;
fdf.filenames = filenames;
fdf.stimulations = stimulations;

cd(currentdir); % change directory