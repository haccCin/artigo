function [ temp ] = defPart( starWide, endWide, total, comp,...
    canais, partEsc, perce, partRef, col, estPe)
%DEFPART Summary of this function goes here
%   Detailed explanation goes here

%% função para determinar as caracteristicas de uma partição.

% função para determinar as caracteristicas de uma partição. Receberá como
% parâmetro os valores do total de contagem  espectral, as estruturas de 
% partições de escolha e de referência e o número mínimo 'min' que uma
% determinada partição deve conter de canais. 

newDat = comp(:,2:end); % suprimi a coluna contendo o valor do canal. 
val = newDat(:,[1:(col-1),(col+1):end]); % ira suprimir a coluna de valor 
                                         % na variável 'col'. 
%valores = estAlt( starWide, endWide, val, total,perce, partRef, estPe);
            % estimativa do valor de altura do composto desconhecido nas
            % diferentes partições.
valores = maxiMini(val);            
maxPart = max(valores);
minPart = min(valores);
[maxPart1, minPart1] = maxMin(total, 1, starWide, (endWide - starWide));
arqEstAlt = fopen('aarqEstAlt','a');
impressao(arqEstAlt,[minPart maxPart minPart1 maxPart1]);
                     % arquivo para a escrita dos resultados contendo:                      
fclose(arqEstAlt);
half = minPart + ((maxPart - minPart)/2);
respos = deterAlt(maxPart, minPart, half);
temp = struct('starWide',starWide, 'endWide', endWide, 'half', half, ...
    'maxPart', maxPart, 'minPart', minPart,'height', respos.height,...
    'heighRet', respos.heighRet,...
    'pos', respos.pos,'posVarAlt', respos.posVarAlt,...
    'partEsc', ...
    canais(partEsc,:),'compMeta',respos.compMeta, 'total', total, ...
    'compostos', comp,'valores', valores);
end

