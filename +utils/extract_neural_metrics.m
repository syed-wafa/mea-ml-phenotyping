function fdf = extract_neural_metrics(os, dirname, nwells, nfeatures)

% Function to extract neural metrics from neural metrics .mat files.
% Inputs:
%   os: operating system.
%   dirname: name of directory containing .mat files.
%   nwells: number of wells.
%   nfeatures: number of neural metric features.
% Outputs:
%   fdf.df: wells x features x time data frame.
%   fdf.filenames: filenames (order of files loaded).

if strcmp(os, 'Mac OS')
    delim = '/';
elseif strcmp(os, 'Windows')
    delim = '\';
end

currentdir = pwd; % current directory
cd(dirname); % change directory
files = dir('*.mat'); % .mat files in current folder
nfiles = size(files, 1); % # of .mat files

% Pre-allocate for speed
time = num2cell(NaN(1, nfiles));
filenames = num2cell(NaN(nfiles, 1));
df = NaN(nwells, nfeatures, nfiles);

for file = 1:nfiles % for each .mat file

    % Get timestamps of each individual .mat file
    current_file = files(file).date;
    time(:, file) = cellstr(current_file);

    % Get names of each individual .mat file
    current_file = files(file).name;
    filenames(file, :) = cellstr(current_file);

    % Read data
    file_data = load(strcat(pwd, delim, current_file));

    % Format data frame
    df(:, :, file) = (cell2mat(struct2cell(file_data.wellMetrics)))';

end

% % Sort time-points in ascending order
% [~, timeorder_index] = ...
%     sort(datenum(time, 'dd-mmm-yyyy hh:MM:ss'), 1, 'ascend');
% fdf.df = df(:, :, timeorder_index);
% fdf.filenames = filenames(timeorder_index);

fdf.df = df;
fdf.filenames = filenames;

cd(currentdir); % change directory