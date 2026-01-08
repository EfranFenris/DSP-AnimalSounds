clear; clc; close all;

% 1) Pick one example file (here: first cat file)
files = dir('../data/cat/*.wav');   % or '../data/dog/*.wav'
file  = fullfile(files(1).folder, files(1).name);

[x, fs] = audioread(file);

% 2) Make mono if stereo
if size(x, 2) > 1
    x = mean(x, 2);
end

% 3) Resample to common sampling frequency
fs_target = 16000;       
if fs ~= fs_target
    x = resample(x, fs_target, fs);
    fs = fs_target;
end

% 4) Normalize amplitude
x = x / max(abs(x));

% 5) No cropping needed here, all clips are 5 seconds long
N = length(x);

% Time axis
t = (0:N-1) / fs;

% 6) Plot time-domain
figure;
plot(t, x);
grid on;
xlabel('Time [s]');
ylabel('Amplitude');
title('Example - time domain');

% 7) Frequency-domain (FFT)
X    = fft(x);
X    = X(1:N/2+1);          % single-sided
Xmag = abs(X);
f    = (0:N/2) * fs / N;

figure;
plot(f, Xmag);
grid on;
xlabel('Frequency [Hz]');
ylabel('|X(f)|');
title('Example - magnitude spectrum');