clc; clear; close all;
%% Parameters
filename='Test/test_file.txt';
fileID = fopen(filename,'r');
data = fread(fileID, '*ubit1', 'ieee-le');

SNR_DB_Arr = 10:30;
L = 1000;
R = 54;
codeRate = 3/4;
modulation_type = '64QAM';
rep_type = 'Float';
equalization_method = 'Weiner';

%% Default
setPreamble("");
BER_Vals_default_preamble = [];
for snr = SNR_DB_Arr
    % Transmitter
    transmitted_frames = Wifi_Transmitter(data, L, R, codeRate, modulation_type, rep_type);
    % Channel
    rxed_frames = apply_channel(transmitted_frames, snr);
    % Receiver
    equalization_method = 'Weiner';
    [decoded_data, rec_frames, eq_rec_fremaes] = Wifi_Receiver(rxed_frames, equalization_method, rep_type, snr);
    [BER, ratio] = biterr(decoded_data',data);
    BER_Vals_default_preamble = [BER_Vals_default_preamble ratio];
end

%% Half
setPreamble("half");
BER_Vals_half_preamble = [];
for snr = SNR_DB_Arr
    % Transmitter
    transmitted_frames = Wifi_Transmitter(data, L, R, codeRate, modulation_type, rep_type);
    % Channel
    rxed_frames = apply_channel(transmitted_frames, snr);
    % Receiver
    equalization_method = 'Weiner';
    [decoded_data, rec_frames, eq_rec_fremaes] = Wifi_Receiver(rxed_frames, equalization_method, rep_type, snr);
    [BER, ratio] = biterr(decoded_data',data);
    BER_Vals_half_preamble = [BER_Vals_half_preamble ratio];
end

%% Double
setPreamble("double");
BER_Vals_double_preamble = [];
for snr = SNR_DB_Arr
    % Transmitter
    transmitted_frames = Wifi_Transmitter(data, L, R, codeRate, modulation_type, rep_type);
    % Channel
    rxed_frames = apply_channel(transmitted_frames, snr);
    % Receiver
    equalization_method = 'Weiner';
    [decoded_data, rec_frames, eq_rec_fremaes] = Wifi_Receiver(rxed_frames, equalization_method, rep_type, snr);
    [BER, ratio] = biterr(decoded_data',data);
    BER_Vals_double_preamble = [BER_Vals_double_preamble ratio];
end

%% Plot
figure();
semilogy(SNR_DB_Arr, BER_Vals_default_preamble,'r-o', ...
    SNR_DB_Arr, BER_Vals_half_preamble,'g-*', ...
    SNR_DB_Arr, BER_Vals_double_preamble, 'b-*');
title('Investigating the effect of Preamble Length');
xlabel('SNR (dB)'); ylabel('BER');
legend('Standard field length', 'Half size', 'Double the size');
grid on;