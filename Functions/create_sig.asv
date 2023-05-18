function signal = create_sig(R,L)

switch R
    case 6
        Rate = [1 1 0 1];
        M =log2(2); %BPSK
        C = 1/2;
    case 9
        Rate = [1 1 1 1] ;
        M = log2(2); %BPSK
        C = 3/4;
    case 12
        Rate = [0 1 0 1];
        M = log2(4); %QPSK
        C = 1/2;
    case 18
        Rate = [0 1 1 1] ;
        M = log2(4); %QPSK
        C = 3/4;
    case 24
        Rate = [1 0 0 1];
        M = log2(16); % 16 QAM
        C = 1/2;
    case 36
        Rate = [1 0 1 1];
        M = log2(16); % 16 QAM
        C = 3/4;
    case 48
        Rate = [0 0 0 1];
        M = log2(64); % 64 QAM
        C = 2/3;
    case 54
        Rate = [0 0 1 1];
        M = log2(64); % 64 QAM
        C = 3/4;
    otherwise 
        error('Invalid Rate')
end 

length = flip(de2bi(L,12)); % 12 bits 
parity =rem(sum([Rate length]),2); % 0 => even, 1 => odd
tail = [0 0 0 0 0 0]; % Tail bits are always set to zero 

% get the number of coded bits 
bits = 8*L;
coded_bits = ceil(bits / C);
rem_bits = rem(coded_bits,(48*M));


no_bits =rem((48*M)- rem_bits,(48*M));
pad = flip(de2bi(no_bits,9)); % 9 bits for padding
signal=[Rate length parity tail pad];
end