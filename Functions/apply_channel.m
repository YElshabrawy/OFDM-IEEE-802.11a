function transmitted_frames = apply_channel(transmitted_frames,SNR_dB)
% Channel
% Amplitude_h = sqrt(0.5) * randn(); % Amplitude from Rayleigh distribution
% Phase_h = 2 * pi * rand(); % Phase uniformly distributed over [0, 2pi]
% 
% h = Amplitude_h * exp(1i * Phase_h);

h = [0.8208 + 0.2052*1i, 0.4104 + 0.1026*1i, 0.2052 + 0.2052*1i, 0.1026 + 0.1026*1i];

% Apply
transmitted_frames = conv(transmitted_frames,conj(h));
transmitted_frames = transmitted_frames(1:end-length(h)+1);

% Add noise
transmitted_frames = awgn(transmitted_frames, SNR_dB,'measured');
end

