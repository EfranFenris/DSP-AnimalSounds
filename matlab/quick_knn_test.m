clear; clc; close all;

load('features.mat');   % loads X, y, classes

% Optional: normalise features (z-score)
Xz = zscore(X);

% k-NN classifier, k=5
Mdl = fitcknn(Xz, y, ...
    'NumNeighbors', 5, ...
    'Standardize', false);

% 5-fold cross-validation
cv = crossval(Mdl, 'KFold', 5);

loss = kfoldLoss(cv);
acc  = 1 - loss;

fprintf('5-fold CV accuracy: %.2f %%\n', acc * 100);

% Confusion matrix
yhat = kfoldPredict(cv);
cm = confusionmat(y, yhat);

disp('Confusion matrix (rows = true, cols = predicted):');
disp(cm);

% Optional: show per-class accuracy
class_acc = diag(cm) ./ sum(cm, 2);
for i = 1:numel(classes)
    fprintf('%s accuracy: %.2f %%\n', classes{i}, class_acc(i) * 100);
end