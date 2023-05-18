function preamble=create_preamble()
% Define symbols
short = sqrt(13/6) .* [0, 0, 1 + 1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, -1-1i, 0, 0, 0,-1-1i, 0, 0, 0, 1 + 1i, 0, 0, 0, 0, 0, 0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0,1+1i, 0, 0, 0, 1+1i, 0, 0, 0, 1 + 1i, 0, 0];
long = [1, 1,-1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];

% Create short train
vec=pad64fft(short);
Vs_ifft= ifft(vec);

short_train=[Vs_ifft;Vs_ifft;Vs_ifft(1:33)];
short_train=round(short_train,3);
% Divide 1st and last by 2 (weight)
short_train(1) = short_train(1)/2;
short_train(end) = short_train(end)/2;

% Crate long train
vec2=pad64fft(long);
Vl_ifft= ifft(vec2);

long_time=[Vl_ifft;Vl_ifft];
GI2= long_time(end-31:end);

long_train= [GI2 ; long_time; GI2(1)];
long_train= round(long_train,3);

% Divide 1st and last by 2 (weight)
long_train(1) = long_train(1)/2;
long_train(end) = long_train(end)/2;

preamble=[short_train; long_train];

end

