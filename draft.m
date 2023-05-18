clc; clear;
% Params
filename='Test/test_file.txt';
fileID = fopen(filename,'r');
data_ = fread(fileID, '*ubit1', 'ieee-le');
L = 1000; 
R = 6; 
codeRate = 1/2; 
modulation_type = 'BPSK'; 
rep_type = 'Float'; 
equalization_method = 'WE';

x = data_;

% Peramble
preamble = create_preamble();
preamble = transpose(preamble);

all_frames = [];

for i=0:8*L:length(x)
    if i+8*L >length(x)
        % Handle last bits
        data = x(i+1:end);
        data = transpose(data);

        if isempty(data)
            break
        end
        % create a signal field
        signal = create_sig(R,(length(x)-i)/8);
    else
       
    data = x(i+1:i+8*L);
    data = transpose(data);
    % create a signal field
    signal = create_sig(R,L);
    end

    out_signal = convEncoder(signal,1/2);
    compledatasignal = mapping(out_signal ,'BPSK');
    signal_ifft_without_cp= ifft(compledatasignal);
    signal_ifft=[signal_ifft_without_cp(end-15:end) signal_ifft_without_cp];

    % data creation: 
    out_data = convEncoder(data,codeRate);
    output_data = padding(out_data,mod_type);
    compledatadata = mapping(output_data ,mod_type);
    All_OFDM_data = convert_OFDM_symbol(compledatadata);
    frame = create_frame(preamble,signal_ifft,All_OFDM_data);
    
    all_frames = [all_frames frame];
 
end