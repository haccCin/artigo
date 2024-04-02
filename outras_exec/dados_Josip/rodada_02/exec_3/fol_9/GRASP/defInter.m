function [ matriz1, matriz2 ] = defInter( matriz, posicao, ativi )
%DEFINTER Summary of this function goes here
%   Detailed explanation goes here

%% Função usada no path relinking para definição de intervalos. 

% Função para definição de intervalos no path relinking. Nesse função, os
% parâmetros de entrada são uma determinada matriz e uma posição na qual a
% matriz terá o elemento eliminado. O parâmetro de saída serão duas
% matrizes contendo os valores dos intervalos à esquerda do elemento
% eliminado e à direita do elemento eliminado. Se o valor a ser extraido
% for o primeiro da matriz, as matrizes retornadas serão uma matriz vazia e
% uma matriz igual a original, mas se iniciando a partir da segunda posição
% . Se o valor a ser extraido for o ultimo, as matrizes retornadas serão a
% matriz original excluindo o ultimo termo e a matriz vazia. 

tamMat = size(matriz);
if ativi == 0
    if posicao ~= 1 && posicao ~= tamMat(1,1)
        matriz1 = matriz(1:posicao-1,1);
        matriz2 = matriz(posicao+1:end,1);
    else
        if posicao == 1
            matriz1 = [];
            matriz2 = matriz(2:end,1);
        end
        if posicao == tamMat(1,1)
            matriz1 = matriz(1:end-1,1);
            matriz2 = [];
        end
    end
else
    if posicao ~= 1 && posicao ~= tamMat(1,1)
        matriz1 = matriz(1:posicao-1, 1);
        matriz2 = matriz(posicao:end,1);
    else
        if posicao == 2
            matriz1 = matriz(1,1);
            matriz = matriz(2:end,1);
        end
        if posicao == tamMat(1,1)
            matriz1 = matriz(1:end-1,1);
            matriz2 = matriz(end,1);
        end
    end
end
end

