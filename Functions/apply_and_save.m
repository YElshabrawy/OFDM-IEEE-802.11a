function [decoded_data,ratio] = apply_and_save(data, L, R, codeRate, modulation_type, rep_type,snr, equalization_method, fileName)
% Transmitter
% setPreamble("double");
transmitted_frames = Wifi_Transmitter(data, L, R, codeRate, modulation_type, rep_type);
% Channel
rxed_frames = apply_channel(transmitted_frames, snr);
% Receiver
[decoded_data, ~, ~] = Wifi_Receiver(rxed_frames, equalization_method, rep_type, snr);
output_fileID = fopen(fileName,'w');
fwrite(output_fileID, decoded_data,'*ubit1', 'ieee-le');
[~, ratio] = biterr(decoded_data',data);
end