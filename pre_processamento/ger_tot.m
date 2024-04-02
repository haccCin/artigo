function tot = ger_tot(dat, perc_bck)
%função para gerar o espectro total a partir das bibliotecas de entrada.
%Para gerar o total nessa função, assume-se que as biblitecas foram
%multiplicadas pelos frações de peso percentuais.


tamDat = size(dat);
temp = zeros(tamDat(1,1),1);
for i = 1 : tamDat(1,1)
    for j = 2 : tamDat(1,2)
        temp(i,1) = temp(i,1) + dat(i,j);
    end
end
tot = perc_bck * temp;
end

