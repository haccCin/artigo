function [ retur ] = adic( ponto , grid, dir )
%ADIC função para adicionar a um vetor o grid e uma determinada direção
%   função para adicionar a um vetor seu grid e uma determinada direção.
%   Pega-se o ponto inicial, adiciona-se a esse ponto uma direção
%   multiplicada pelo seu respectivo grid.


if dir == -1
   newDir = [0 -1]; 
else
    newDir = [0 1];
end
tamPonto = size(ponto);
if tamPonto(1,1) == 1
    newPonto = [0 ponto];
end
vet_adic = newPonto + grid * newDir;
if vet_adic(1,1) == 0
    retur = vet_adic(1,2);
else
    retur = vet_adic;
end
end

