function ratio = apply_no_save(data, L, R, codeRate, modulation_type, rep_type,snr, equalization_method)
% Transmitter
% setPreamble("double");
transmitted_frames = Wifi_Transmitter(data, L, R, codeRate, modulation_type, rep_type);
% Channel
rxed_frames = apply_channel(transmitted_frames, snr);
% Receiver
[decoded_data, ~, ~] = Wifi_Receiver(rxed_frames, equalization_method, rep_type, snr);
[~, ratio] = biterr(decoded_data',data);
end