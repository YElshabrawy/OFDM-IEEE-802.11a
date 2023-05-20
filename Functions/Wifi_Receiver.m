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
    [~, L , M ,C ,P, m]= decode_signal(signal_decode);

    % 3. Handle Data
    % Calculate the frame size
    bits = 8*L;
    coded_bits = ceil(bits / C);
    all_no_bits = coded_bits+P;
    no_ofdm_sympols = all_no_bits/(48*m);
    end_frame = no_ofdm_sympols*80;

    % Get the frame
    rec_data =Frames(n+402:n+401+end_frame);
    rec_data = reshape(rec_data, 1, length(rec_data));

    % From OFDM format to original bits
    rec_frames= deapply_OFDM(rec_data);
    
    % Floating to Fixed 
    if strcmp(rep_type,'Fixed')
        rec_frames= fi(rec_frames,1,16,12);
        preamble= fi(preamble,1,16,12);
    end

    % Channel Estimation
    gains = channelEstimation(preamble, rep_type);

    % Channel Equalization
    switch(M)
        case 'BPSK'
            mm = 2;
        case 'QPSK'
            mm = 4;
        case '16QAM'
            mm = 16;
        case '64QAM'
            mm = 64;
        otherwise
            mm = 0;
    end
    equalized_frames = channelEqalization(rec_frames,gains,equalization_method, rep_type, mm, 10.^(snr/10));
    equalized_frames = reshape(equalized_frames, 1, length(equalized_frames));

    % Demap
    if strcmp(rep_type,'Fixed')
        out_data = symbolDemapper(equalized_frames.data, M);    
    else
        out_data = symbolDemapper(equalized_frames, M);
    end

    % Remove padding
    out_data=out_data(1:end-P);
    out_data =reshape(out_data, 1, length(out_data));

    % Channel Decode
    outputStream_data = conv_decode(out_data,C,bits);
    decoded_data = [decoded_data outputStream_data];

    % Before and After Equalization
    rec_frames1 = [rec_frames1 rec_frames];
    eq_rec_fremaes1 = [eq_rec_fremaes1  equalized_frames];

    n = n+402+end_frame;
end
end

