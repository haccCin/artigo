function [ soma ] = somCanais( canais, compostos, qtd, perce2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% criação de vetores por soma de particões dos dados originais

% Função para criar vetores a partir da soma de contagens espectrais do
% vetor de compostos. A função receberá como entrada a matriz contendo o
% iníco e fim de cada uma das partições, a matriz de compostos as contagens
% espe-
% ctrais água, óleo, gás e sal (compostos) e o valor de 'qtd', quantidade
% de canais que fará parte de cada uma das partições, tomando por base que 
% início de cada uma das partiçõecompostos(canais(i,1) + k,l)s será por 'canais'. A saída será uma
% matriz de dimensão quadrada de igual valor ao número de compostos ( no
% caso citado, uma matriz quatro por quatro),  onde na primeira linha
% conteŕa terá os elementos S_{11}, S_{12}, S_{13} e S_{14}, onde S_{ab}
% será a soma das contagens espectrais para a partição 'a' dado o compostos
% 'b'. A primeira linha conterá a soma das contagens espectrais para a
% primeira partição para os quatro diferentes compostos numa linha. Uma
% coluna dessa matriz irá conter a soma das contagens espectrais nos
% diferentes intervalos para um composto fixo.
 
tamCan = size(canais);
tamCom = size(compostos);
soma = zeros(tamCan(1,1),tamCom(1,2));
for i = 1 : tamCan(1,1)
    for l = 1 : tamCom(1,2)
        for k = 0 : qtd
            if tamCan(1,2) > 1 && k <= (abs(canais(i,1) - canais(i,2)))...
                    && canais(i,1) + k <= tamCom(1,1) && ...
                    compostos(canais(i,1) + k,l) ~= -1
                
                soma(i,l) = soma(i,l) + compostos(canais(i,1) + k,l) ...
                    * perce2(1,l);
            end
        end
    end
end
end

