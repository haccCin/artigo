function [valores] = maxiMini(matriz)
%MAXIMINI Summary of this function goes here
%   Detailed explanation goes here

%% Função para determinar os valores máximos e mínimos de uma matriz.


tamMat = size(matriz);
min = inf;
max = -inf;
for i = 1 : tamMat(1,1)
    for j = 1 : tamMat(1,2)
        if (matriz(i,j) > max) && (matriz(i,j) ~= 0)
            max = matriz(i,j);
        end
        if (matriz(i,j) < min) && (matriz(i,j) ~= 0)
            min = matriz(i,j);
        end
    end
end
valores = [min max];
end


