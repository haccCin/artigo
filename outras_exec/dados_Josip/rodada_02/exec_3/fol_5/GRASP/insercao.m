function [ newLista ] = insercao( lista, elemento)
%INSERCAO Summary of this function goes here
%   Detailed explanation goes here


%% Função para realizar a inserção dentro da lista do GRASP.

% Método para realizar inserção dentro da lista do GRASP. Recebe como
% parâmetro a lista e o elemento candidato a ser inserido. Retorna a lista
% com o novo elemento inserido. 

tamLista = size(lista);
dif = inf;
metEle = metrica(elemento);
for i = 1 : tamLista(1,1)
    if ~isempty(lista{i,1})
        metInd = metrica(lista{i,1});
    end
    dif2 = abs(metEle - metInd);
    if dif2 < dif
       posicao = i;
       dif = dif2;
    end 
end
newLista = lista;
newLista{posicao,1} = elemento;

end


