function [matRetor] = normal(dados)
%NORMAL Summary of this function goes here
%   Detailed explanation goes here


sizeDados = size(dados);
matTemp = zeros(sizeDados(1,1), sizeDados(1,2));
for i = 1 : sizeDados(1,2)
    matTemp(:, i) = mat2gray(dados(:,i));
end

matRetor = matTemp;