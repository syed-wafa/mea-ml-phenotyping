function array_out = sankey_format(array_in, target_classes)

% Function to format an array to draw a Sankey diagram.
% Inputs:
%   array_in: n x 2 array of observations x [source, target].
%   target_classes: row vector of unique target classes.
% Outputs:
%   array_out: n x 5 array of observations x [source, target, value,
%   IDsource, IDtarget].

array_out = []; % initialize variable

nunique_targets = size(target_classes, 1); % # of unique targets

unique_sources = unique(array_in(:, 1)); % unique sources
nunique_sources = size(unique_sources, 1); % # of unique sources

% Hardcode sources and targets
unique_sources = {'WT';...
    'KCNQ2';...
    'WT+XE991';...
    'KCNQ2+retigabine'};

% Calculate the fraction of target classes for each unique source
for n = 1:nunique_sources % for each unique source

    % Limit array to source
    idx = strcmp(array_in(:, 1), unique_sources(n));
    source_array = array_in(idx, :);

    for t = 1:nunique_targets % for each unique target

        % Calculate fraction
        f = sum(strcmp(source_array(:, 2), target_classes{t})) / size(source_array, 1);

        % Define array out
        array_out = [array_out; [...
            unique_sources(n),...
            target_classes{t},...
            num2cell(f),...
            num2cell(n - 1),...
            num2cell(nunique_sources - 1 + t)]];
    end

end

array_out = array2table(array_out,...
    'variablenames', {'source', 'target', 'value', 'IDsource', 'IDtarget'});

end