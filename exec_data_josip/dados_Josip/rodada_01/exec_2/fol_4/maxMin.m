function [ maxi,mini ] = maxMin( compostos, coluna, linha, qtd )
%MAXMIN Summary of this function goes here
%   Detailed explanation goes here

% Função que irá determinar o máximo e o mínimo de contagem espectral para
% um determinado composto, especificado na variável 'coluna'.

maxi = max(compostos((linha:linha+qtd),(coluna)));
mini = min(compostos((linha:linha+qtd),(coluna)));

end

