function feat = extract_features(x, fs)
%EXTRACT_FEATURES  Simple DSP features from one mono clip x
%   Returns a row vector: [RMS, ZCR, Centroid, E_low, E_mid, E_high]

    N = length(x);

    % --- 1) RMS energy ---
    rms_val = sqrt( mean( x.^2 ) );

    % --- 2) Zero-crossing rate (per second) ---
    s = sign(x);
    s(s == 0) = 1;  % avoid zeros stuck at 0
    zc = sum( s(1:end-1) .* s(2:end) < 0 );   % number of sign changes
    zcr = zc / (N / fs);    % crossings per second

    % --- 3) Spectrum and spectral centroid ---
    X    = fft(x);
    X    = X(1:N/2+1);
    Xmag = abs(X);
    f    = (0:N/2) * fs / N;

    % Spectral centroid (Hz)
    centroid = sum(f(:) .* Xmag(:)) / sum(Xmag(:) + eps);

    % --- 4) Band energies (low, mid, high) ---
    % define bands: 0–1k, 1k–4k, 4k–8k Hz
    low_band  = [0,    1000];
    mid_band  = [1000, 4000];
    high_band = [4000, fs/2];

    % indices for each band
    idx_low  = (f >= low_band(1)  & f < low_band(2));
    idx_mid  = (f >= mid_band(1)  & f < mid_band(2));
    idx_high = (f >= high_band(1) & f <= high_band(2));

    % use squared magnitude as "energy"
    X2 = Xmag.^2;
    E_low  = sum( X2(idx_low)  );
    E_mid  = sum( X2(idx_mid)  );
    E_high = sum( X2(idx_high) );

    % collect features into one row vector
    feat = [rms_val, zcr, centroid, E_low, E_mid, E_high];
    
end