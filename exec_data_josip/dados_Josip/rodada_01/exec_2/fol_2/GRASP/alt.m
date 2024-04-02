function [ retur ] = alt( resCons )
%ALT Summary of this function goes here
%   Detailed explanation goes here

%% função para determinar a variação de altura na busca por melhores soluç.

% função para determinar a variação na altura das soluções advindas do
% processo construtivo. Essa função recebe como parâmetro a solução advinda
% do processo construtivo, e retorna como saída uma estrutura contendo
% dados como os novos valores atuais de percentual de altura, o valor da
% metade da solução, variação na altura, valor da altura da solução atual,
% novo valor de altura. São pegos alguns dados atuais, como a altura
% percentual 'perceHeigh' presente, a metade presente no intervalo atual, 
% a variação na altura 'varHeig', se a variação da altura se dará acima ou
% abaixo do valor a metade do intervalo 'posVarAlt', a altura presente do
% retângulo 'altRet', os novos valores de altura do retângulo 'newHeig',
% 'newHeight'. A partir daí é construída a estrutura de retorno, 'retur'.
% Para a solução construida, se 'presPos' for igual a 1, a presente altura
% esta acima da metade. A partir daí, o vizinho pode ser construido como
% uma nova altura acima ou abaixo da presente altura. Se for acima da da
% presente altura, a variavel 'posVarAlt' será igual a 1, e essa nova
% altura sera definida como uma soma da altura presente com um percentual
% da distancia compreendida entre 'max' e 'altRet'. Senão, a nova altura
% sera definida como a presente altura menos um percentual da distancia
% compreendida entre 'presHalf' e 'altRet'. No caso de 'presPos' for igual
% a zero, a presente altura esta abaixo da 'presHalf'. Se nessa situação
% 'posVarAlt' for igual a ', a altura dor retangulo vizinho será construido
% como a altura do retangulo atual mais uma percentual da distancia
% compreedida entre 'presHalf' e 'altRet'. Senão, a altira do vizinho será
% definido como a 'altRet' menos um percentual da altura compreendida entre
% 'min' e 'altRet'.O percentual da altura do retangulo será definido sempre
% como uma distancia acima ou abaixo da metade. No caso da altura estar
% definida acima da metade, essa altura será definida como um percentual a
% menos da metade. No caso de estar abaixo da metade, essa altura sera
% definida como um percentual a mais da metade. 

% height: valor aleatorio que determina a variação desejada na altura. Essa
% variação pode ser realizada entre um valor mínimo (c2) e um valor máximo
% (c1). O resultado da operação será um fator que multiplicará a altura
% atual para fornecer um novo valor de altura. se 'height' for maior que 1,
% a altura do retângulo aumentará e a variável 'posVarAlt' assumirá o 
% valor 1. Se for menor do que 1, diminuirá e a variável 'posVarAlt' 
% assumirá um valor menor que 1. 

% newHeight: trará o valor do fator multiplicativo entre a nova altura
% 'newHeig' e a antiga altura 'altRet'. 

% varPerHeig: traduz o valor de 'newHeight' em termos de percentuais, para
% isso subtraindo 1.

% newComMet: Faz um novo comparativo com a metade


perceHeigh = resCons{1,1}{1,1}.height;
presHalf = resCons{1,1}{1,1}.half;
presPos = resCons{1,1}{1,1}.pos;
max = resCons{1,1}{1,1}.maxPart;
min = resCons{1,1}{1,1}.minPart;
altRet = resCons{1,1}{1,1}.heighRet;
compMeta = resCons{1,1}{1,1}.compMeta;
parou = false;
while parou == false
    if presPos == 1
        c1 = max / altRet;
        c2 = presHalf / altRet;
        height=c2+rand(1,1)*(c1 - c2); 
        if height > 1 
            newHeig = altRet * height;
            posVarAlt = 1;
        else
            newHeig = altRet * height;
            posVarAlt = 0;
        end
        newHeight = newHeig / altRet;
        varPerHeig = abs(1 - newHeight); 
        compMeta = presHalf / newHeig;
    else
        c1 = presHalf / altRet;
        c2 = min / altRet;
        height=c2+rand(1,1)*(c1 - c2); 
        if height > 1
            newHeig = altRet * height; 
            posVarAlt = 1; 
        else
            newHeig = altRet * height;
            posVarAlt = 0;
        end
        newHeight = newHeig / altRet;
        varPerHeig = abs(1 - newHeight);
        compMeta = presHalf / newHeig;
    end
    if newHeig <= max && newHeig >= min
        parou = true;
    end
end
retur = struct ('varPerHeig', varPerHeig, 'perceHeigh',perceHeigh,'presHalf'...
    , presHalf,'newHeig',...
    newHeig, 'newHeight', newHeight, 'max',max,'min',min, 'starWide',...
    resCons{1,1}{1,1}.starWide, 'endWide',resCons{1,1}{1,1}.endWide,...
    'presPos', presPos,'altret',altRet,'compMeta', compMeta,'half',...
    presHalf,'pos', presPos,'posVarAlt',posVarAlt,'partEsc',...
    resCons{1,1}{1,1}.partEsc);
end

