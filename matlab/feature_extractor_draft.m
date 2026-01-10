function feat = extract_features(x, fs)
% EXTRACT_FEATURES  Simple DSP features from one mono clip x (fs Hz)
% Returns a row vector:
%   [RMS, ZCR, Centroid, E_low, E_mid, E_high]

    % length of signal
    N = length(x);

    % --- 1) RMS energy ---
    % sqrt of mean of squared samples
    rms_val = sqrt( mean( x.^2 ) );

    % --- 2) Zero-crossing rate (per second) ---
    % count how many times the signal changes sign
    s = sign(x);
    % avoid zeros staying at 0
    s(s == 0) = 1;
    % sign change if product of neighbours is negative
    zc  = sum( s(1:end-1) .* s(2:end) < 0 );
    % divide by duration (in seconds) to get "per second"
    duration_sec = N / fs;
    zcr = zc / duration_sec;

    % --- 3) Spectrum and spectral centroid ---
    % FFT
    X = fft(x);
    % keep only positive frequencies
    X = X(1:floor(N/2)+1);
    Xmag = abs(X);

    % frequency axis for these bins (in Hz)
    f = (0:floor(N/2)) * fs / N;

    % spectral centroid: weighted average of frequencies
    denom = sum(Xmag) + eps;   % avoid division by zero
    centroid = sum(f .* Xmag.') / denom;

    % --- 4) Band energies (low, mid, high) ---
    % Define three bands (you can tweak these)
    low_band  = [0,    1000];        % 0–1 kHz
    mid_band  = [1000, 4000];        % 1–4 kHz
    high_band = [4000, fs/2];        % 4 kHz–Nyquist

    % indices for each band
    idx_low  = (f >= low_band(1)  & f <  low_band(2));
    idx_mid  = (f >= mid_band(1)  & f <  mid_band(2));
    idx_high = (f >= high_band(1) & f <= high_band(2));

    % use squared magnitude as "energy"
    X2 = Xmag.^2;
    E_low  = sum( X2(idx_low)  );
    E_mid  = sum( X2(idx_mid)  );
    E_high = sum( X2(idx_high) );

    % --- 5) Collect features into one row vector ---
    feat = [rms_val, zcr, centroid, E_low, E_mid, E_high];
end