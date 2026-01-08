clear; clc; close all;

% Target sampling frequency
fs_target = 16000;

% Your 3 classes (folders in ../data/)
classes = {'dog', 'cat', 'crow'};   % adjust if your third is 'hen' or 'bird'

X = [];   % feature matrix (num_samples x 6)
y = [];   % labels (num_samples x 1)

for c = 1:numel(classes)
    class_name = classes{c};
    fprintf('Processing class: %s\n', class_name);

    % List all WAV files for that class
    files = dir(fullfile('..', 'data', class_name, '*.wav'));

    for k = 1:numel(files)
        file = fullfile(files(k).folder, files(k).name);

        % --- Load audio ---
        [x, fs] = audioread(file);

        % Make mono if stereo
        if size(x, 2) > 1
            x = mean(x, 2);
        end

        % Resample to common fs
        if fs ~= fs_target
            x = resample(x, fs_target, fs);
            fs = fs_target;
        end

        % Normalise
        x = x / max(abs(x) + eps);

        % Extract features (your function)
        feat = extract_features(x, fs);

        % Append
        X = [X; feat];      % one row per file
        y = [y; c];         % label: 1=dog, 2=cat, 3=crow
    end
end

% Save everything for later
save('features.mat', 'X', 'y', 'classes');
fprintf('Done. Total samples: %d\n', size(X,1));