function channel_gains = channelEstimation(preamble, rep_type)
G_PREAMBLE_TYPE = getPreamble();
data_loc = setdiff(1:53,27); %remove index 27
L = [1, 1,-1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];
L = L(data_loc);

if strcmp(rep_type,'Fixed')
    pp = preamble.data;
else
    pp = preamble;
end
if G_PREAMBLE_TYPE == "half"
    % First Symbol (only one)
    shortLen = 81;
    gapLen = 16;
    startIdx = shortLen + gapLen +1;
    symbolLen = 64;
    endIdx = startIdx + symbolLen -1;
    long_train_symbol_1 = fft(pp(startIdx : endIdx));
    long_train_symbol_1 = rec_64fft(long_train_symbol_1);
    long_train_symbol_1 = long_train_symbol_1(data_loc);
    long_train_symbol_1 = reshape(long_train_symbol_1, 1, length(long_train_symbol_1));
    h1 = long_train_symbol_1./L;
    channel_gains = h1;
elseif G_PREAMBLE_TYPE == "double"
    % (4 Symbols)
    shortLen = 321;
    gapLen = 64;
    startIdx = shortLen + gapLen +1;
    symbolLen = 64;
    endIdx = startIdx + symbolLen -1;
    % First Symbol
    long_train_symbol_1 = fft(pp(startIdx : endIdx));
    long_train_symbol_1 = rec_64fft(long_train_symbol_1);
    long_train_symbol_1 = long_train_symbol_1(data_loc);
    long_train_symbol_1 = reshape(long_train_symbol_1, 1, length(long_train_symbol_1));

    % Second Symbol
    startIdx = endIdx + 1;
    endIdx = startIdx + symbolLen -1;
    long_train_symbol_2 = fft(pp(startIdx:endIdx));
    long_train_symbol_2 = rec_64fft(long_train_symbol_2);
    long_train_symbol_2 = long_train_symbol_2(data_loc);
    long_train_symbol_2 = reshape(long_train_symbol_2, 1, length(long_train_symbol_2));

    % Third Symbol
    startIdx = endIdx + 1;
    endIdx = startIdx + symbolLen -1;
    long_train_symbol_3 = fft(pp(startIdx:endIdx));
    long_train_symbol_3 = rec_64fft(long_train_symbol_3);
    long_train_symbol_3 = long_train_symbol_3(data_loc);
    long_train_symbol_3 = reshape(long_train_symbol_3, 1, length(long_train_symbol_3));

    % Fourth Symbol
    startIdx = endIdx + 1;
    endIdx = startIdx + symbolLen -1;
    long_train_symbol_4 = fft(pp(startIdx:endIdx));
    long_train_symbol_4 = rec_64fft(long_train_symbol_4);
    long_train_symbol_4 = long_train_symbol_4(data_loc);
    long_train_symbol_4 = reshape(long_train_symbol_4, 1, length(long_train_symbol_4));

    h1 = long_train_symbol_1./L;
    h2 = long_train_symbol_2./L;
    h3 = long_train_symbol_3./L;
    h4 = long_train_symbol_4./L;

    % Take avg
    channel_gains = (h1+h2+h3+h4)./4;
else
    % Default preamble (2 Symbols)
    shortLen = 161;
    gapLen = 32;
    startIdx = shortLen + gapLen +1;
    symbolLen = 64;
    endIdx = startIdx + symbolLen -1;
    % First Symbol
    long_train_symbol_1 = fft(pp(startIdx : endIdx));
    long_train_symbol_1 = rec_64fft(long_train_symbol_1);
    long_train_symbol_1 = long_train_symbol_1(data_loc);
    long_train_symbol_1 = reshape(long_train_symbol_1, 1, length(long_train_symbol_1));

    % Second Symbol
    long_train_symbol_2 = fft(pp(endIdx+1:endIdx+1+symbolLen-1));
    long_train_symbol_2 = rec_64fft(long_train_symbol_2);
    long_train_symbol_2 = long_train_symbol_2(data_loc);
    long_train_symbol_2 = reshape(long_train_symbol_2, 1, length(long_train_symbol_2));

    h1 = long_train_symbol_1./L;
    h2 = long_train_symbol_2./L;

    % Take avg
    channel_gains = (h1+h2)./2;

end

if strcmp(rep_type,'Fixed')
    %Floating to Fixed
    channel_gains= fi(channel_gains,1,16,12);
end

end

function out=rec_64fft(input)
out =zeros(53,1);
out(1:26)=input(39:64);
out(28:53)=input(2:27);
end