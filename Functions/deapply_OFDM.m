function output_complex = deapply_OFDM(inputstream)

output_complex=[];
for i = 0:80:length(inputstream)-80
    output = OFDM_deformatter(inputstream(i+17 : i+80));
    output_complex=[output_complex output];
    
end 

end