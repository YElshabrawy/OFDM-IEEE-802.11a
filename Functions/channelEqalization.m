function equalized_data = channelEqalization(data, gains, equalization_method, rep_type, M, SNR)
pilots_indecies = [32, 45, 7, 21];
data_indecies = setdiff((1:52), pilots_indecies);
data_channel_gains = gains(data_indecies);

if strcmpi(equalization_method,'ZF')
    % Zero-Forcing (divide by channel response)
    if strcmpi(rep_type,'Fixed')
        for i = 1:48:length(data)
            equalized_data(i:i+47) = divide(numerictype(data_channel_gains),data(i:i+47),data_channel_gains);
        end
    else
        for i = 1:48:length(data)
            equalized_data(i:i+47) = data(i:i+47)./data_channel_gains;
        end
    end
else
    % Weiner (H*/(|H|^2*1/snr))
    if strcmpi(rep_type,'Fixed')
        W = divide(numerictype(data_channel_gains),conj(data_channel_gains),((abs(data_channel_gains)).^2+(log2(M)/SNR)));
        for i = 1:48:length(data)
            equalized_data(i:i+47) = data(i:i+47).*W;
        end
    else
        W = conj(data_channel_gains)./((abs(data_channel_gains)).^2 + (log2(M)/SNR));
        for i = 1:48:length(data)
            equalized_data(i:i+47) = data(i:i+47).*W;
        end
    end

end


end

