function [ metMax ] = metMax (lista)
%Função para determinar a métrica máxima de uma lista
%   Detailed explanation goes here

tamLista = size(lista);
metMax = 0 ;
for i = 1 : tamLista(1,1)
    vari = lista{i,1}{3,1}{1,1}.somAprPart;
    if vari > metMax && metMax >= 0
        metMax = vari;
    end
end
end

