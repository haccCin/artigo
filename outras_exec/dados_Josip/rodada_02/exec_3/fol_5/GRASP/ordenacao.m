function [ matriz ] = ordenacao(matriz1)
%ORDENACAO Summary of this function goes here
%   Detailed explanation goes here

%% ordenacao da matriz de entrada

% Ordenação do resultado do passo anterior
tamPic = size(matriz1);
matriz = matriz1;
for k = 1 : tamPic(1,1) - 1
    for m = k+1 : tamPic(1,1)
        if matriz(k,1) > matriz(m,1)
            temp = matriz(k,:);
            matriz(k,:) = matriz(m,:);
            matriz(m,:) = temp;
        end
    end
end

end

