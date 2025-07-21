function classification_metrics = computeClassificationMetrics(...
    predictions, actual_class, predicted_class)

nPredictions = size(predictions, 1); % # of predictions

classification_metrics.TP = 0; % # of true positives (TP)
classification_metrics.TN = 0; % # of true negatives (TN)
classification_metrics.FP = 0; % # of false positives (FP)
classification_metrics.FN = 0; % # of false negatives (FN)

% Calculate # of TP, TN, FP, FN
for j = 1:nPredictions
    if actual_class(j, 1) == 1 && predicted_class(j, 1) == 1
        classification_metrics.TP = classification_metrics.TP + 1;
    elseif actual_class(j, 1) == 0 && predicted_class(j, 1) == 0
        classification_metrics.TN = classification_metrics.TN + 1;
    elseif actual_class(j, 1) == 0 && predicted_class(j, 1) == 1
        classification_metrics.FP = classification_metrics.FP + 1;
    elseif actual_class(j, 1) == 1 && predicted_class(j, 1) == 0
        classification_metrics.FN = classification_metrics.FN + 1;
    end
end

% Calculate precision, recall, and F-1 score
classification_metrics.precision = classification_metrics.TP /...
    (classification_metrics.TP + classification_metrics.FP);

classification_metrics.recall = classification_metrics.TP /...
    (classification_metrics.TP + classification_metrics.FN);

classification_metrics.F1 = (2 * classification_metrics.precision * classification_metrics.recall) /...
    (classification_metrics.precision + classification_metrics.recall);

end