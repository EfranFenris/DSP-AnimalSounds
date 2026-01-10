clear; clc; close all;

% Classes = folders under ../data/
classes = {'dog', 'cat', 'crow'};
fs_target = 16000;

% We'll store features in a normal MATLAB matrix first
X = [];              % numeric features
labels_str = {};     % cell array of strings with class names

for c = 1:length(classes)
    class_name = classes{c};
    fprintf('Processing class: %s\n', class_name);

    folder = ['../data/' class_name];
    files  = dir([folder '/*.wav']);

    for k = 1:length(files)
        file_path = fullfile(files(k).folder, files(k).name);

        % --- Load audio ---
        [x, fs] = audioread(file_path);

        % --- Convert to mono (if stereo) ---
        if size(x,2) > 1
            x = mean(x, 2);
        end

        % --- Resample to 16 kHz ---
        if fs ~= fs_target
            x = resample(x, fs_target, fs);
            fs = fs_target;
        end

        % --- Normalize amplitude ---
        x = x / (max(abs(x)) + eps);

        % --- Extract DSP features (your function) ---
        feat = extract_features(x, fs);   % 1x6 vector

        % --- Save features and label ---
        X = [X; feat];                     % add row to matrix
        labels_str{end+1,1} = class_name;  % add a new label (cell array)
    end
end

% Now create a table so it's easy to export to CSV
T = array2table(X, ...
    'VariableNames', {'RMS', 'ZCR', 'Centroid', 'E_low', 'E_mid', 'E_high'});

% Add the label column (first column)
T = addvars(T, labels_str, 'Before', 1, 'NewVariableNames', 'label');

% Save to CSV (Python will read this)
writetable(T, 'features.csv');

% Also save MATLAB version if you want
save('features.mat', 'X', 'labels_str', 'classes');

fprintf('Done. Total clips: %d\n', height(T));