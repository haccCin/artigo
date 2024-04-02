function [ channels ] = searCha(start, fim, comp)
%SEARCHA Summary of this function goes here
%   Detailed explanation goes here

%% função para determinar os canais efetivos inseridos em ums solução PR

% algoritmo para determinação dos canais efetivamente inseridos dentro de
% uma solução do PR. Essa função se faz necessária porque a determinação
% dos canais efetivamente inseridos dentro do PR se dará por meio da
% biblioteca de compostos. Na biblioteca de composto, quando um canal não
% se encontra na solução, a biblioteca é marcada com o valor de -1. 

pont = 1;
for  i = start : fim
    if (comp(i,:) ~= -1)
        channels(1, pont) = i;
        pont = pont + 1;
    end
end
end

