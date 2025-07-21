function array_out = confusionmatrix(actual_class, predicted_class,...
    class_type, classnames)
% Function to calculate confusion matrix values.
% Inputs:
% actual_class: column vector of actual classes.
% predicted_class: column vector of predicted classes.
% class_type: 0 (strings) or 1 (numeric).
% classnames: row vector of unique class names.
% Outputs:
% array_out: row vector of number of true positives, false positives,
% false negatives, and true negatives.
nclasses = size(classnames, 1); % number of classes
nobservations = size(actual_class, 1); % number of observations
% Initialize variables
nTP = 0; nFP = 0; nFN = 0; nTN = 0;
% For binary classification
if class_type == 0 % if classes are strings
    for class = 1:nclasses % for each class convert strings to numbers
        for n = 1:nobservations
            if strcmp(actual_class{n}, classnames{class})==1
                actual_class(n) = num2cell(class);
            end
            if strcmp(predicted_class{n}, classnames{class})==1
                predicted_class(n) = num2cell(class);
            end
        end
    end
    actual_class = cell2mat(actual_class);
    actual_class(actual_class ~= 1) = 0; % substitute twos with zeros
    predicted_class = cell2mat(predicted_class);
    predicted_class(predicted_class ~= 1) = 0; % substitute twos with zeros
end
% Calculate number of true positives, false positives, false negatives, and
% true negatives
for n = 1:nobservations
    if actual_class(n) == 1 && predicted_class(n) == 1
        nTP = nTP + 1; % number of true positives
    elseif actual_class(n) == 0 && predicted_class(n) == 1
        nFP = nFP + 1; % number of false positives
    elseif actual_class(n) == 1 && predicted_class(n) == 0
        nFN = nFN + 1; % number of false negatives
    elseif actual_class(n) == 0 && predicted_class(n) == 0
        nTN = nTN + 1; % number of true negatives
    end
end
array_out = [nTP, nFP, nFN, nTN]; % array_out
end