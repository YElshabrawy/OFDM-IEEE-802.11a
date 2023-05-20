function OFDM_symbols = apply_OFDM(complex_symbols)
OFDM_symbols=[];
CycPref = 16;
% Loop over every 48 data bits, format them (map to right index and add
% pilots) then rerturn all symbols each 80x1 (64 + 16 cp)
for i = 0:48:length(complex_symbols)-48
    % Serial to parallel & position pilots
    OFDM_symbol = OFDM_formatter(complex_symbols(i+1:i+48));
    % Add Cyclic prefex
    OFDM_symbol=[OFDM_symbol(end-CycPref+1:end)  OFDM_symbol];

    OFDM_symbols=[OFDM_symbols OFDM_symbol];
end 
end

