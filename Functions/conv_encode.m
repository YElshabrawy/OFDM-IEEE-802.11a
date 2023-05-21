function outputStream = conv_encode(input,codeRate, forceConv)
if nargin<3
    forceConv= false;
end
G_CODING = getCoding();
if(G_CODING == "REP" && ~forceConv)
    outputStream = reshape(repmat(input,3,1),1,[]);
elseif (G_CODING == "LDPC" && ~forceConv)
    P = [
        16 17 22 24  9  3 14 -1  4  2  7 -1 26 -1  2 -1 21 -1  1  0 -1 -1 -1 -1
        25 12 12  3  3 26  6 21 -1 15 22 -1 15 -1  4 -1 -1 16 -1  0  0 -1 -1 -1
        25 18 26 16 22 23  9 -1  0 -1  4 -1  4 -1  8 23 11 -1 -1 -1  0  0 -1 -1
        9  7  0  1 17 -1 -1  7  3 -1  3 23 -1 16 -1 -1 21 -1  0 -1 -1  0  0 -1
        24  5 26  7  1 -1 -1 15 24 15 -1  8 -1 13 -1 13 -1 11 -1 -1 -1 -1  0  0
        2  2 19 14 24  1 15 19 -1 21 -1  2 -1 24 -1  3 -1  2  1 -1 -1 -1 -1  0
        ];
    blockSize = 27;
    pcmatrix = ldpcQuasiCyclicMatrix(blockSize,P);
    cfgLDPCEnc = ldpcEncoderConfig(pcmatrix);
    outputStream = ldpcEncode(int8(input),cfgLDPCEnc);
else
    trellis = poly2trellis(7,[133 171]); % g0=[1011011]=133 in octal,g1=[1111001]=171, constraint Length =7
    switch codeRate
        case 1/2
            outputStream = convenc(input,trellis);
        case 2/3
            puncpat = [1;1;1;0];
            while mod(length(input),4) ~= 0
                input = [input 0] ;
            end
            outputStream = convenc(input,trellis,puncpat);
            c = length(input ) + ceil(length(input)/2); % for example: if outputStream = 8000 , and coderate 3/4 : ceil(8000/4)= 2667 , 8000+2667 = 10667... =
            outputStream = outputStream (1:c);

        case 3/4
            while mod(length(input),6) ~= 0
                input = [input 0] ;
            end

            puncpat = [1;1;1;0;0;1];
            outputStream = convenc(input,trellis,puncpat);
            c = length(input) + ceil(length(input)/3); % for example: if inputStream = 8000 , and coderate 3/4 : ceil(8000/4)= 2667 , 8000+2667 = 10667... =
            outputStream = outputStream (1:c);
    end
end
end