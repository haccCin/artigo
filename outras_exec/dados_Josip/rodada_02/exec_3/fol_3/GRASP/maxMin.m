function [ maxi,mini ] = maxMin( compostos, coluna, linha, qtd )
%MAXMIN Summary of this function goes here
%   Detailed explanation goes here

%% 

% Função que irá determinar o máximo e o mínimo de contagem espectral para
% um determinado composto, especificado na variável 'coluna'.
maxi = 0;
for i = linha : linha + qtd
    if compostos(i,coluna) > maxi && compostos(i,coluna) ~= -1
        maxi = compostos(i, coluna);
    end
end
mini = inf;
for k = linha : linha + qtd
    if compostos(k, coluna) < mini && compostos(k,coluna) ~= -1
        mini = compostos(k, coluna);
    end
end
end

