function outputStream = conv_decode(inputStream,codeRate,L, forceConv)
if nargin<4
    forceConv= false;
end
G_CODING = getCoding();
if(G_CODING == "REP" && ~forceConv)
    outputStream = inputStream(1:3:numel(inputStream));
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
    maxnumiter = 10;
    pcmatrix = ldpcQuasiCyclicMatrix(blockSize,P);
    cfgLDPCDec = ldpcDecoderConfig(pcmatrix);

    outputStream = ldpcDecode(inputStream,cfgLDPCDec,maxnumiter);
    outputStream = uint8(outputStream);

else
    trellis = poly2trellis(7,[133 171]);
    switch codeRate
        case 1/2
            outputStream = vitdec(inputStream,trellis,1,'trunc','hard');
        case 2/3
            puncpat = [1;1;1;0];
            while mod(length(inputStream),3) ~= 0
                inputStream = [inputStream 0] ;
            end
            outputStream = vitdec(inputStream,trellis,1,'trunc','hard',puncpat);
        case 3/4
            puncpat = [1;1;1;0;0;1];
            while mod(length(inputStream),4) ~= 0
                inputStream = [inputStream 0] ;
            end
            outputStream = vitdec(inputStream,trellis,1,'trunc','hard',puncpat);

    end
    outputStream = outputStream(1:L); % to cancel the zero-padding effect that happend in the encoder


end
end