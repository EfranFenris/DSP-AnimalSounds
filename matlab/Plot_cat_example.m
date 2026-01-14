clear; clc; close all;

% 1) We pick one example file (here: first cat file)
files = dir('../data/cat/*.wav');
file  = fullfile(files(1).folder, files(1).name);

[x, fs] = audioread(file);

% Convert to mono
if size(x,2) > 1
    x = mean(x, 2);  % convert to mono
end

% Resample to 16 kHz if needed
fs_target = 16000;
if fs ~= fs_target
    x  = resample(x, fs_target, fs);  
    fs = fs_target;
end

% there is no need for chopping because all clips are 5 seconds long
N = length(x);

% normalize the amplitude so we can make clips comparable
x = x / max(abs(x));

% ---- Time domain representation ----
 t = (0:N-1)/fs;  

figure;
plot(t, x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Cat audio signal');
grid on;
exportgraphics(gcf, fullfile('../figures', 'cat_time.pdf'));

% ---- Frequency domain representation ----
X = fft(x);
X = X / N;                      % Normalize the amplitude

% one-sided spectrum
N_half = floor(N/2);
f = (0:N_half) * fs / N;        
X_mag = abs(X(1:N_half+1));     % Take positive frequencies

figure;
plot(f, X_mag);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum of Cat audio signal');
grid on;
exportgraphics(gcf, fullfile('../figures', 'cat_frequency.pdf'));