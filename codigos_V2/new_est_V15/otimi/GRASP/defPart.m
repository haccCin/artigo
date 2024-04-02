function [ temp ] = defPart( starWide, endWide, total, comp,...
    canais, partEsc, perce, partRef, col, part, estPe)
%DEFPART Summary of this function goes here
%   Detailed explanation goes here

%% função para determinar as caracteristicas de uma partição.

% função para determinar as caracteristicas de uma partição. Receberá como
% parâmetro os valores do total de contagem  espectral, as estruturas de 
% partições de escolha e de referência e o número mínimo 'min' que uma
% determinada partição deve conter de canais. 

% Suprimi a coluna contendo o número de ordem do canal 
newDat = comp(:,2:end); 

% irá suprimir a coluna do elemento a ser omitido. 
val = newDat(:,[1:(col-1),(col+1):end]); 

% irá fazer a estimativa da altura com janelas de entrada, janela de saída,
% valores de contagens espectrais dos compostos, valores de contagens
% espectrais totais, percentuais, partições de referência e a estimativa
% dos valores de percentuais. 
valores = estAlt( starWide, endWide, val, total,perce, partRef, estPe);

% recupera o máximo valor trazido pelo passoa anterior.
maxPart = max(valores);

% recupera o mínimo valor trazido pelo passo anterior. 
minPart = min(valores);

% traz os valores de máximo e mínimo das contagens espectrais totais. 
[maxPart1, minPart1] = maxMin(total, 1, starWide, (endWide - starWide));

%impressão 
arqEstAlt = fopen('aarqEstAlt','a');
impressao(arqEstAlt,[minPart maxPart minPart1 maxPart1 part]);
                     % arquivo para a escrita dos resultados contendo:                      
fclose(arqEstAlt);


half = minPart + ((maxPart - minPart)/2);

% atribuição da altura do composto suprimido na partição em consideração.  
respos = deterAlt(maxPart, minPart, half);

% definição da estrutura de dados e de retorno. 
temp = struct('starWide',starWide, 'endWide', endWide, 'half', half, ...
    'maxPart', maxPart, 'minPart', minPart,'height', respos.height,...
    'heighRet', respos.heighRet,...
    'pos', respos.pos,'posVarAlt', respos.posVarAlt,...
    'partEsc', ...
    canais(partEsc,:),'compMeta',respos.compMeta, 'total', total, ...
    'compostos', comp,'valores', valores);
end

