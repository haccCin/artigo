function [ resul, somAprox, matPerc ] = build( partRef, retor, compostos, perce,...
    total, canais,numMin, col, estPe )
%CONST Summary of this function goes here
%   Detailed explanation goes here

%% Construção de uma determinada janela em torno da partição escolhida

% Esse método trará como parâmetros de entrada a largura 'wide' da
% partição, a altura 'heigh' da partição (percentual do total) 
% , além das partições de referência
% 'partRef' e as partição 'partEsc' como partição escolhida para ser a
% quarta partição a integrar os dados. Também fazem parte dos parêmetros de
% entrada as bibliotecas de compostos  'compostos', além do percentual que
% cada um dos compostos deve ser multiplicado para dar a contagem espectral
% original, encontrado na variável 'perce'. A saída será uma estrutura de 
% dados chamada 'est' contendo a contagem espectral em torno da janela 
% escolhida, a contagem espectral em torno da biblioteca original do sódio,
% a composição espectral para cada um dos compostos segundo a construção
% escolhida. A localização do nível central a partir do qual a biblioteca 
% do sal ficará centrada será a partir de um percentual da biblioteca de
% contagem total. Dada a largura da partição, a contagel espectral total
% terá um valor de máximo e mínimo na partição considerada. Será escolhido
% um valor médio desses valores de máximo e mínimo, e a partir dai,
% escolhido um valor de particionamento. Ao entrar no módulo de otimização
% e iniciar o GRASP, tem-se os seguintes dados: O valor do resíduo em cada
% uma das partições, o valor do resíduo trazido pelo matlab, alguns dados
% de cada uma das partições (variável 'retor'). 'maxEsc' e 'minEsc' trarão
% os valores de máximo e de mínimo do total na partição escolhida como
% partição móvel. 'half' trará o valor do meio compreendido entre 'maxEsc'
% e 'minEsc' na partição escolhida como movel. A altura 'height' e a 
% largura 'wide' da partição serão gerados por números aleatórios. A
% escolha se a altura será acima da linha média ou abaixo da linha média se
% dará pelo sorteio de um número aleatório 'pos'. O sorteio da altura do
% retângulo acontecerá enquanto o valor da altura nao for maior que o
% mínimo do total ou for menor que o máximo do total. A otimização para a
% matriz do sal será feita tanto na partição escolhida com maior resíduo,
% quanto nas partições de referência. Para isso, essa construção irá varrer
% cada uma das partições. Essa varredura se dará a partir da construção de
% uma matriz contendo a partição escolhida e as partições de referência. Na
% chamada da função 'data' será repassado um composto fictício para o sódio
% com um valor de contagem espectral igual para cada uma das partições. A 
% variável 'compRet' faz a comparação da altura presente do retângulo com o
% valor da sua metade. 

tamRetor = size(retor); %quantidade de partições de referência
partEsc = retor{tamRetor(1,1),1}.iteMMQMat; 
                                            % partição de maior resíduo
                                            

                                            
%%


% trecho de código que ordena os canais inseridos na partição de maior
% residuo e nas particoes de referemncia. 

v = canais(partEsc,:);
parts = insePart(partRef, v);

%%


tamParts = size(parts); % quantidade de partições.
partInse  = zeros(tamParts(1,1), tamParts(1,2));
est = cell(tamParts(1,1),1); 
estCh = cell(tamParts(1,1),1);
                        % cria uma estrutra de dados com informações a 
                        % respeito de cada uma das partições.  
for i = 1 : tamParts(1,1)
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
    partInse(i, :) = [starWide endWide];  
end

%%
% Código para ordenais extraidos do passo anterior


partEsco = ordPart(partInse);


%%


for r = 1 : tamParts(1,1)
    if r == 1
        [temp]= defPart(partEsco(r,1), partEsco(r,2), total,...
            compostos, canais, partEsc, perce, partEsco((2:end),:), col, estPe);
    end
    if r == tamParts(1,1)
        [temp]= defPart(partEsco(r,1), partEsco(r,2), total,...
            compostos, canais, partEsc, perce, partEsco((1:end-1),:), col, estPe);
    end
    if r > 1 && r < tamParts(1,1)
       [temp]= defPart(partEsco(r,1), partEsco(r,2), total,...
            compostos, canais, partEsc, perce, partEsco([1:r-1,r+1:end],:), col, estPe); 
    end
    est{r,1} = temp;
end
[resul, somAprox, matPerc] = data(est, perce, col);
end

