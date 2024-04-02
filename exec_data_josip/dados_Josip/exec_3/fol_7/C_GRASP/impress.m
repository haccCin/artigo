function [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
    resApxArtIcc, resApxArtIsc, somPartZ, somPartArtIcc, somPartArtIsc] = ...
    impress(matPerc, somAprox, est, arquivo)
%IMPRESS Summary of this function goes here
%   Detailed explanation goes here

sizePart = size(somAprox);
apxPart = 0;
toPart = 0;
somPartZ = 0;
somPartArtIcc = 0;
somPartArtIsc = 0;
for ai = 1 : sizePart(1,1)
    apxPart = apxPart + somAprox{ai,1}.somAprPart2;
    toPart = toPart + somAprox{ai,1}.somTot;
    somPartZ = somPartZ + somAprox{ai,1}.somLSQLin2;
    somPartArtIcc = somPartArtIcc + somAprox{ai,1}.soAproxaartICC;
    somPartArtIsc = somPartArtIsc + somAprox{ai,1}.soAproxaartISC;
end
                                                % soma os valores de áreas
                                                % para os diversos
                                                % compostos. 
                                                
difTotApxMMQ = abs(apxPart-toPart);                         
                                                % diferença nos valores 
                                                % entre a área aproximada e
                                                % a área total abaixo do
                                                % espectro.
            
perc = matPerc(:,4);                           
                                                % Traz os valores de fração 
                                                % percentual dos compostos,
                                                % tendo o cobalto sido
                                                % estimado. 
            
pontNeg = isempty(find(perc < 0,1));               
                                                % Verifica se existe valor 
                                                % de fração percentual
                                                % negativo.
                                                
condMatApx = cond(est{4,1}.matSomAprox); 
                                                    % condicionamento da 
                                                    % matriz aproximada.
                                               
resApxMMQ = somAprox{1,1}.resiAproxMMQ;
                                                % avaliará a qualidade do
                                                % resultado pelo valor do
                                                % resíduo trazido pelo 
                                                % método dos mínimos
                                                % quadrados.
                                                

resApxZ = somAprox{1,1}.resiZAprox;
                                                % determinará a qualidade
                                                % da solução pelo método
                                                % 'z' de aproximação dos
                                                % mínimos quadrados. Essa
                                                % solução é a aproximação
                                                % dos compostos pelo método
                                                % 'z'. 
                                                
resApxArtIcc = somAprox{1,1}.resiAproxArtIcc;           
                                                % método que determinará a
                                                % qualidade da aproximação
                                                % da solução pelo ART
                                                % usando a coluna que
                                                % indica que a soma das
                                                % frações percentuais deve
                                                % ser nula. 
                                                
resApxArtIsc = somAprox{1,1}.resiAproxArtIsc;  
                                                % método que determinará a
                                                % qualidade da solução da
                                                % aproximação pelo método
                                                % ART excluindo a coluna em
                                                % que determina que a soma
                                                % dos compostos deve ser 1.
                                             
                                                
if strcmp(arquivo, '') == 1
else
    arqLine = fopen(arquivo,'a');
    impressao(arqLine,[(perc)' apxPart toPart difTotApxMMQ pontNeg condMatApx ...
        resApxMMQ resApxZ resApxArtIcc resApxArtIsc]);
    fclose(arqLine);                                
end
                                                % Arquivo para verificação  
                                                % das saídas do LineSearch.

end

