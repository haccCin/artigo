function [ resul ] = chan( menor, maior )
%CHAN Summary of this function goes here
%   Detailed explanation goes here

%% função para retornar uma matriz contendo os valores das entradas

% Função auxiliar a ser chamada no path relinking. Essa função retornará
% uma matriz contendo em cada uma das posições todos os elementos, um a um,
% dos parâmetros de entrada. A saída será um vetor contendo todos os
% elementos contidos entre o maior e o menor valor dos parâmetros de
% entrada. 

dif = maior - menor;
resul = zeros(dif + 1,1);
k = menor;
for i = 1 : dif+1
    resul(i,1) = k;
    k = k + 1;
end
end

