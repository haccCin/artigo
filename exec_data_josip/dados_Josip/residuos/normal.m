function [ normal ] = normal( matriz )
%NORMAL Summary of this function goes here
%   Detailed explanation goes here


%% Função para normalizar os dados contidos em matriz.

% Função para normalizar os dados contidos em matriz. Essa normalização
% será feita com média zero e desvio padrão um. 

mea = mean2(matriz);
devia = std2(matriz);
tamMat = size(matriz);
normal = zeros(tamMat(1,1), tamMat(1,2));
for i = 1 : tamMat(1,1)
    for j = 1 : tamMat(1,2)
        temp = (matriz(i,j) - mea) / devia;
        normal(i,j) = temp;
    end
end
end

