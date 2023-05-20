function originalbits = symbolDemapper(complexsymbol, modtype)
    originalbits = lteSymbolDemodulate(complexsymbol,modtype,'Hard');
end

