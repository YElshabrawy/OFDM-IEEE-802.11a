function preamble=create_preamble()
G_PREAMBLE_TYPE = getPreamble();

% Define symbols
short = sqrt(13/6) .* [0, 0, 1 + 1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, -1-1i, 0, 0, 0,-1-1i, 0, 0, 0, 1 + 1i, 0, 0, 0, 0, 0, 0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0,1+1i, 0, 0, 0, 1+1i, 0, 0, 0, 1 + 1i, 0, 0];
long = [1, 1,-1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];

% Create short train
vec=pad64fft(short);
Vs_ifft= ifft(vec);
% Apply w(t)
% Vs_ifft(1) = 0.5 * Vs_ifft(1);
% Vs_ifft(61) = 0.5 * Vs_ifft(61);

short_train=[Vs_ifft;Vs_ifft;Vs_ifft(1:33)];
if G_PREAMBLE_TYPE == "half" % Take only one symbol
    short_train=[Vs_ifft;Vs_ifft(1:16+1)];
elseif G_PREAMBLE_TYPE == "double"
    short_train=[Vs_ifft;Vs_ifft;Vs_ifft;Vs_ifft;Vs_ifft;Vs_ifft(1)];
end
short_train=round(short_train,3);

% Divide 1st and last by 2 (weight)
short_train(1) = short_train(1)/2;
short_train(end) = short_train(end)/2;

% Crate long train
vec2=pad64fft(long);
Vl_ifft= ifft(vec2);

long_time=[Vl_ifft;Vl_ifft];
GI2= long_time(end-31:end);
if G_PREAMBLE_TYPE == "half" % Take only one symbol
    long_time=Vl_ifft;
    GI2= long_time(end-16+1:end);
elseif G_PREAMBLE_TYPE == "double"
long_time=[Vl_ifft;Vl_ifft;Vl_ifft;Vl_ifft];
    GI2= long_time(end-64+1:end);
end

long_train= [GI2 ; long_time; GI2(1)];
long_train= round(long_train,3);

% Divide 1st and last by 2 (weight)
long_train(1) = long_train(1)/2;
long_train(end) = -long_train(end)/2;

% Adjust preamble length according to the input parameter
%     if G_PREAMBLE_TYPE == "half"
%         short_train = short_train(1:ceil(end/2));
%     elseif G_PREAMBLE_TYPE == "double"
%         short_train = [short_train; short_train];
%         long_train = [long_train; long_train];
%     end

preamble=[short_train; long_train];



end

