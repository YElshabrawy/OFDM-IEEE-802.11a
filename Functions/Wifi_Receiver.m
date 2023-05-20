function [decoded_data, rec_frames1, eq_rec_fremaes1 ] = Wifi_Receiver(Frames, equalization_method, rep_type, snr)
% Fixed to floating
if strcmpi(rep_type,'Fixed')
    Frames = Frames.data;
end
% Initialization & Consts
decoded_data = [];
rec_frames1 = [];
eq_rec_fremaes1 = [];
SIZE_PREAMBLE = 322;
SIZE_SIGNAL = 80;
SIZE_SIGNAL_PURE = 32;
CycPref = 16;

n = 1;
while n < length(Frames)
    % 1. Extract preamble & signal
    % Preamble
    preamble = Frames(n:n+SIZE_PREAMBLE-1); 
    % Signal
    preamble_and_signal = Frames(n:n+SIZE_SIGNAL+SIZE_PREAMBLE-1);
    signal = preamble_and_signal(SIZE_PREAMBLE+1:end);
    signal = signal(CycPref+1:end); % Remove Cyclic prefix

    % 2. Handle Signal
    % FFT
    signal_fft = fft(signal);
    signal_fft = reshape(signal_fft, 1, length(signal_fft));
    % Demapper
    signal_demap = symbolDemapper(signal_fft, 'BPSK');
    signal_demap = reshape(signal_demap, 1, length(signal_demap));
    % Channel Decode
    signal_decode = conv_decode(signal_demap,1/2,SIZE_SIGNAL_PURE);
    [rec_R , rec_L , M ,C ,P, m]= decode_signal(signal_decode);

    
end
end

