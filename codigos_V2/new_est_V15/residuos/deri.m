function [ valores ] = deri( comp )
%DERIPRI Summary of this function goes here
%   Detailed explanation goes here


%% Função para encontrar as derivadas primeiras dos compostos basicos

% Função para encontrar as derivadas primeiras dos compostos básicos. Será
% calculada a derivada para dois canais consecutivos. Seraõ retornados os
% canais em que o sinal da primeira derivada muda, e também o valor da
% derivada em cada um dos canais. 

tamCom = size(comp);
valores = zeros(tamCom(1,1)-1, tamCom(1,2));
for  j = 1 : tamCom(1,2)
    for i = 1 : tamCom(1,1) -1
        valor = comp(i+1,j) - comp(i,j);
        valores(i,j) = valor;
    end
end
end

