function output = symbolMapper(inputbits,modtype)

switch modtype
    case 'BPSK'
        output = lteSymbolModulate(inputbits,'BPSK');
    case 'QPSK'
        while mod(length(inputbits),2) ~= 0
            inputbits = [inputbits 0] ;
        end
        output = lteSymbolModulate(inputbits,'QPSK');
    case '16QAM'
        output = lteSymbolModulate(inputbits,'16QAM');
    case '64QAM'
        while mod(length(inputbits),6) ~= 0
            inputbits = [inputbits 0] ;
        end
        output = lteSymbolModulate(inputbits,'64QAM');

end
output = transpose(output);
end