function [ total ] = gerTotal( chutes, compostos )
%GERTOTAL Summary of this function goes here
%   Detailed explanation goes here

% Função para determinar o total desconhecido dados os chutes fracionários
% para cada um dos compostos. Os chutes fracionários estão
% inseridos na variável 'chutes', enquanto que a variável compostos trarão
% os valores de contagel espectral para cada um dos quatros compostos em
% cada um dos quatros canais.

tamCom = size(compostos);
total = zeros(tamCom(1,1),1);
for i = 1 : tamCom(1,1)
    parcial = 0 ;
    for j = 1 : tamCom(1,2)
        parcial = parcial + chutes(1,j) * compostos(i,j);
    end
    total(i,1) = parcial;
end
end

