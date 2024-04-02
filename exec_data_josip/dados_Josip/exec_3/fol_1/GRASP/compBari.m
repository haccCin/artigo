function [parou] = compBari(mat1, mat2, limiar)
%COMPBARI Summary of this function goes here
%   Detailed explanation goes here função que recebe dois vetores e
%   verifica onde está o maior valor de cada um deles e a posição em que se
%   encontra.mat1

[v1, i1] = max(mat1);
[v2, i2] = max(mat2);
parou = false;
if i1 == i2 && (v1 - v2) < limiar
    parou = true;
end
end

