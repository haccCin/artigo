function [ difLar1,difLar2,dat ] = datEnlar( cha, soluc, canais, ref, col, ...
    estPe)
%DATENLAR Summary of this function goes here
%   Detailed explanation goes here

%% função para calcular dados na variação de largura

% função para calcular os dados na variação de largura da solução. Essa
% função será chamada ao longo da busca localao se variar a largura da
% solução, como também será chamada durante o path-relinking. Os parâmetros
% de entrada são: Os novos valores de canais modificados a partir da 
% solução corrente 'init', 'end'. tem-se também o total calculado para os
% compostos 'tot', além da solução a partir da qual irá ser feita a
% variação de largura. Os valores de contagem espectral dos compostos
% também será o parâmetro de entrada. Nos parâmetros de entrada, 'canais '
% conterá a estrutura de particionamento dos dados. 
% A estrutra de saída será uma solução
% contendo os valores de início de canal da solução, de termino de canal da
% solução, a metade da contagem espectral da partição modificada 'half', o
% máximo de contagem espectral da partição 'max', o mínimo de contagem
% espectral da partição 'min', 'height', percentual da altura do retângulo
% em relação à metade 'half', 'heighRet', altura do retângulo, 'pos'
% posição da altura do retângulo em relação à 'half', a estrutura de canais
% dos compostos, 'partEsc', partição escolhida, 'compMeta', comprimento em
% relação à metade. 

% recupera a matriz de contagem espectral dos compostos.
matUsa = soluc{1,1}{1,1}.compostos(:,2:end);

% copia da solução vinda do processo de busca do GRASP.
copSoluc = soluc;

% faz novo valor de estimativa de altura devido à modificação no intervalo
% de canais contidos nas partições. 
valores = estAlt(soluc{1,1}{1,1}.starWide, soluc{1,1}{1,1}.endWide, ...
    matUsa(:,[(1:col-1),(col+1:end)]), soluc{1,1}{1,1}.total, ...
    soluc{1,1}{1,1}.perce, ref, estPe);

%  maximo e minimo trazido pelo passo anterior. 
max = valores(1,2);
min = valores(1,1);

% calculo da metade dos valores trazidos no passo anterior. 
half = (max + min) / 2;

% nova estimativa de altura na partição considerada. 
resposAlt = deterAlt(max, min, half);

% construção da estrutura de saída.
est = struct('starWide', cha(1,1), 'endWide', cha(end,1), ...
    'half', half, 'maxPart', max,'minPart',min,'height', resposAlt.height,...
    'heighRet', resposAlt.heighRet,'pos',resposAlt.pos,'posVarAlt',...
    resposAlt.posVarAlt,...
    'canais',canais,...
    'partEsc',soluc{1,1}{1,1}.partEsc,'compMeta',resposAlt.compMeta,...
    'total',soluc{1,1}{1,1}.total, 'compostos', soluc{1,1}{1,1}.compostos);

% modificação da copia da solução corrente.
copSoluc{1,1}{1,1} = est;

% dados das partições
param = copSoluc{1,1};

% percentuais 
perce = soluc{1,1}{1,1}.perce;

% definicção dos parâmetros das partições. 
[partTemp, somAproxTemp, matPercTemp] = data(param, perce, col);

% impressão dos parâmetros das partições. 
dat = {partTemp; matPercTemp; somAproxTemp; matPercTemp};
[apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
    resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
    somPartArtIsc] = impress(matPercTemp, somAproxTemp, partTemp, ...
        'aarSearDatEnlar');
        
% preparação para impressão das métricas. 
valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
valDif = [(apxPart - toPart)  abs(somPartZ - toPart) ...
        abs(somPartArtIcc-toPart) abs(somPartArtIsc-toPart)];
        
% valores de métrica. 
difLar1 = metrica(soluc);
difLar2 = metrica(dat);

end

