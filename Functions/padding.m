function outputStream = padding(bitStream,ModulationType)
switch ModulationType
    case 'BPSK'
        while mod(length(bitStream),48) ~=0
            bitStream = [bitStream 0];
        end
    case 'QPSK'
        while  mod(length(bitStream),48*2) ~=0
            bitStream = [bitStream 0];
        end
    case '16QAM'
        while  mod(length(bitStream),48*4) ~=0
            bitStream = [bitStream 0];
        end
    case '64QAM'
        while  mod(length(bitStream),48*6) ~=0
            bitStream = [bitStream 0];
        end
        
end
outputStream = bitStream;
end

