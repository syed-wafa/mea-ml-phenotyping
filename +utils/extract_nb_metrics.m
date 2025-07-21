function fdf = extract_nb_metrics(os, dirname, nwells)

% Function to extract network burst features from network burst lists.
% Inputs:
%   os: operating system.
%   dirname: name of directory containing network burst list .csv files.
%   nwells: number of wells.
% Outputs:
%   fdf.df: wells x 1 x time data frame of network burst features.
%       features include - mean inter-NB interval
%   fdf.filenames: filenames (order of files loaded).
%   fdf.recording_times: time x 2 array of recording start and end times.

if strcmp(os, 'Mac OS')
    delim = '/';
elseif strcmp(os, 'Windows')
    delim = '\';
end

currentdir = pwd; % current directory
cd(dirname); % change directory
files = dir('*.csv'); % .csv files in current folder
nfiles = size(files, 1); % # of .csv files

% Pre-allocate for speed
time = num2cell(NaN(1, nfiles));
filenames = num2cell(NaN(nfiles, 1));
df = NaN(nwells, 1, nfiles);
recording_times = NaN(nfiles, 2);

for file = 1:nfiles % for each .csv file

    % Get timestamps of each individual .csv file
    current_file = files(file).date;
    time(:, file) = cellstr(current_file);

    % Get names of each individual .csv file
    current_file = files(file).name;
    filenames(file, :) = cellstr(current_file);

    % Read data
    file_data = readcell(strcat(pwd, delim, current_file));

    % Get recording start and end times
    recording_times(file, 1) = cell2mat(file_data(3, 2));
    recording_times(file, 2) = cell2mat(file_data(4, 2));

    % Get network bursts and format data frame
    file_data = file_data(25:end, 1:3); % limit region to be searched
    file_rows = size(file_data, 1);
    [~, well_idx] = unique(file_data(:, 1), 'stable');

    % Calculate the mean inter-network burst interval for each well
    for well = 1:nwells % for each well

        % Calculate start and end rows of network bursts
        row_start = well_idx(well);
        if well ~= nwells
            row_end = well_idx(well + 1) - 1;
        else
            row_end = file_rows;
        end

        % Calculate network burst features and format data frame
        if row_end - row_start >= 1
            nb_times = cell2mat(file_data(row_start:row_end, 2));
            nb_diff = diff(nb_times);
            nb_dur = cell2mat(file_data(row_start:row_end, 3));
            nb_dur_delta = abs(diff(nb_dur));
            df(well, 1, file) = mean(nb_diff, 'omitnan'); % Inter-NB interval
        else
            df(well, 1, file) = NaN;
        end

    end

end

fdf.df = df;
fdf.filenames = filenames;
fdf.recording_times = recording_times;

cd(currentdir); % change directory