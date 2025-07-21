function [metric, struct_out] = metrics_from_confmat(nTP, nFP, nFN, nTN)
% Function to calculate performance metrics from confusion matrix.
% Inputs:
% nTP: number of true positives.
% nFP: number of false positives.
% nFN: number of false negatives.
% nTN: number of true negatives.
% Outputs:
% metric: metric names.
% struct_out: structure array of the following performance metrics -
% TPR (true positive rate or sensitivity or recall or hit rate or
% probability of detection)
% TNR (true negative rate or specificity)
% FPR (false positive rate or fall-out or (1 - specificity))
% FNR (false negative rate or miss rate)
% FDR (false discovery rate)
% FOR (false omission rate)
% NPV (negative predictive value)
% PPV (positive predictive value or precision)
% PCC (percent correctly classified or accuracy)
% ER (error rate (1 - accuracy))
% F1 (F-1 score)
nobservations = nTP + nFP + nFN + nTN; % number of observations
struct_out.TPR = nTP / (nTP + nFN); % true positive rate
struct_out.TNR = nTN / (nTN + nFP); % true negative rate
struct_out.FPR = nFP / (nFP + nTN); % false positive rate
struct_out.FNR = nFN / (nFN + nTP); % false negative rate
struct_out.FDR = nFP / (nFP + nTP); % false discovery rate
struct_out.FOR = nFN / (nFN + nTN); % false omission rate
struct_out.NPV = nTN / (nTN + nFN); % negative predictive value
struct_out.PPV = nTP / (nTP + nFP); % positive predictive value
struct_out.PCC = (nTP + nTN) / nobservations; % accuracy
struct_out.ER = (nFP + nFN) / nobservations; % error rate
struct_out.F1 = (2 * struct_out.PPV * struct_out.TPR) /...
    (struct_out.PPV + struct_out.TPR); % F-1 score
% Define metric names
metric = {'True positive rate (recall or sensitivity)';...
    'True negative rate (specificity)';...
    'False positive rate (fall-out)';...
    'False negative rate (miss rate)';...
    'False discovery rate';...
    'False omission rate';...
    'Negative predictive value';...
    'Positive predictive value (precision)';...
    'Accuracy (% correctly classified)';...
    'Error rate';...
    'F-1 score'};
end