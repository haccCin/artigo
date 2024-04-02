function [ dif ] = counDif( exisStarTar, exisTarStar )
%COUNDIF Summary of this function goes here
%   Detailed explanation goes here

%% função para contar as diferenças entre as soluções start e target

% função auxiliar para contar a quantidade de diferenças entre as duas
% soluções start e target. Essa função receberá como parâmetro as matrizes
% 'exisStarTar', que indica os canais presentes em start e ausentes em
% target. Essa matriz conterá o valor 1 em um determinada posição para
% canais que são comuns às duas soluções, e elemento zero para um canal que
% pertence exclusivamente à solução start. Já a estrutura 'exisTarStar'
% levará em conta os canais que pertencem à soluçãoi target. Essa estrutura
% de dados conterá o valor 1 para canais que pertençam a target e start, e
% conterá o valor 0 para canais que são exclusivos de target, que não
% pertencem à start. A saída será um número inteiro indicando a quantidade
% de diferenças entre as duas soluções.

tamExisStar = size(exisStarTar);
tamExisTar = size(exisTarStar);
dif = 0;
for  i = 1 : tamExisStar(1,1)
    if exisStarTar(i,1) == 0
        dif = dif + 1;
    end
end
for j = 1 : tamExisTar(1,1)
    if exisTarStar(j,1) == 0
        dif = dif + 1;
    end
end
end

