function [ resul, somAprox, matPerc, fun] = build( partRef, ...
partEsc, compostos, perce, total, canais, numMin, col, estPe, fun, metMin)
%CONST Summary of this function goes here
%   Detailed explanation goes here
% partições de referência - partRef (calculado em resíduos)
% partEsc - Partição de maior resíduo
% compostos - bibliotecas de contagens espectrais. 
% perce - percentuais dos compostos para multiplicar as bib.
% total - bibliotecas de contagens espectrais totais. 
% canais - canais de cada uma das partições. 
% numMin - Número mínimo de canais em uma partição. 
% col - Coluna a ser suprimida em uma partição. 

%% Construção de uma determinada janela em torno da partição escolhida

partTemp = [canais(partEsc,:) ; partRef];
                                        % realiza a integração das
                                        % partições de referência com a
                                        % partição de maior resíduo. 
                                        
% ordenacao das particoes
parts = ordenacao(partTemp);
                                        
tamParts = size(parts); % quantidade de partições.
est = cell(tamParts(1,1),1); 
                        % cria uma estrutra de dados com informações a 
                        % respeito de cada uma das partições. 
for i = 1 : tamParts(1,1)
    partsEli = parts; 
    starWide = randi([parts(i,1) ((parts(i,2) - (numMin+1)))],1,1);
                % aleatoriamente escolhe um canal de início para uma
                % partição arbitrária. esse canal vai estar compreendido
                % entre o canal de início da partição e o canal de término
                % menos o número mínimo de canais escolhido para uma
                % partição conter. 
    ter = parts(i,2) + 1;
    while ter > parts(i,2)
        endWide = randi([(starWide + numMin + 1) (parts(i,2))],1,1);
                    % aleatoriamente escolhe um canal compreendido entre o
                    % escolhido na linha 57 mais o número minimo de canais
                    % e o fim de uma partição. 
        if endWide <= parts(i,2) && endWide ~= starWide && ...
            (endWide - starWide >= numMin)
            ter = -1;
        end
    end
    partsEli(i,:) = [];
    [temp]= defPart(starWide, endWide, total,compostos, canais, ...
        partEsc, perce, partsEli, col, i, estPe);
                    % definição da partição. A definição dessapartição leva 
                    % em conta as partições de referência. A estrutura de 
                    % saída possui varios parâmetros. 
    est{i,1} = temp; 
end
% calculo dos parametros das particoes
[resul, somAprox, matPerc] = data(est, perce, col);
dati = {resul;matPerc(:,1);somAprox;matPerc};
[val,resulMet] = metrica(dati);
if val < fun
    fun = val;
end

end 

