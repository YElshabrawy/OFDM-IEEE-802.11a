function channel_gains = channelEstimation(preamble, rep_type)
data_loc = setdiff(1:53,27); %remove index 27
L = [1, 1,-1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];
L = L(data_loc);

if strcmp(rep_type,'Fixed')
    pp = preamble.data;      
else
    pp = preamble;
end
% First Symbol
long_train_symbol_1 = fft(pp(194:257));
long_train_symbol_1 = rec_64fft(long_train_symbol_1);
long_train_symbol_1 = long_train_symbol_1(data_loc);
long_train_symbol_1 = reshape(long_train_symbol_1, 1, length(long_train_symbol_1));

% Second Symbol
long_train_symbol_2 = fft(pp(258:321));
long_train_symbol_2 = rec_64fft(long_train_symbol_2);
long_train_symbol_2 = long_train_symbol_2(data_loc);
long_train_symbol_2 = reshape(long_train_symbol_2, 1, length(long_train_symbol_2));

h1 = long_train_symbol_1./L; 
h2 = long_train_symbol_2./L;

channel_gains = (h1+h2)./2;

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