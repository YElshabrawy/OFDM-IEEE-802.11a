function all_frames = Wifi_Transmitter(x, L, R, codeRate, mod_type, rep_type)
CycPref = 16;
% create preamble
preamble =create_preamble();
preamble = reshape(preamble, 1, length(preamble));

all_frames = [];

for i=0:8*L:length(x)
    if i+8*L >length(x)
        % Handle last bits
        data = x(i+1:end);
        data = reshape(data, 1, length(data));

        if isempty(data)
            break
        end
        % create a signal field
        signal = create_sig(R,(length(x)-i)/8);
    else

        data = x(i+1:i+8*L);
        data = reshape(data, 1, length(data));
        % create a signal field
        signal = create_sig(R,L);
    end

    % Modulate Signal using 1/2 conv BPSK for reliable Tx
    out_signal = conv_encode(signal,1/2, true);
    compledatasignal = symbolMapper(out_signal ,'BPSK');
    signal_ifft_without_cp= ifft(compledatasignal);
    signal_ifft=[signal_ifft_without_cp(end-CycPref+1:end) signal_ifft_without_cp];

    % data creation:
    out_data = conv_encode(data,codeRate);
    output_data = padding(out_data,mod_type);
    modulatedData = symbolMapper(output_data ,mod_type);

    All_OFDM_data = apply_OFDM(modulatedData);

    frame = [preamble signal_ifft All_OFDM_data];
    all_frames = [all_frames frame];

end

%Fixed Point
if strcmpi(rep_type,'Fixed')
    all_frames = fi(all_frames,1,8,8);
    all_frames = all_frames;
end

end

