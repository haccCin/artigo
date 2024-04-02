function [ respos ] = deterAlt( max, min, half )
%DETERALT Summary of this function goes here
%   Detailed explanation goes here


%% Função para determinação da altura do retângulos dados o início e fim 

% Função para determinação da altura do retângulo dados o início e fim de
% uma partição. Recebe como parâmetros de entrada os valores de início e
% fim de uma partição, o meio desses valores e retorna como resposta os
% valores da posição da altura desse retângulo, o parâmetro 'pos' que
% indica se essa altura está acima ou abaixo da metade e os percentuais que
% comparam a altura atual com a metade e os percentuais que indicam a que
% distância esse retângulo deve ser construido.


heigRet = 0;
compMeta = 0;
parou = false;
while ~(parou)
    c1 = (max / half);
    c2 = (min / half);
    height = c2+rand(1,1)*(c1 - c2);
    if height > 1
        heigRet = half * height;
        compMeta = abs((half / heigRet));
        pos = 1;
    else
        heigRet = half * height; 
        compMeta = abs((half / heigRet));
        pos = 0;
    end
    if (min < heigRet) && (heigRet < max )
        parou = true;
    end
end
respos = struct('height',height,'pos', pos, 'heighRet',heigRet,'compMeta',...
    compMeta, 'max', max, 'min', min, 'half', half,'posVarAlt',-1 );

end

