function [ dados_normal ] = normaliza( dados )
%NORMALIZA Summary of this function goes here
%   normalização dos dados segundo uma distribuição normal com media 0 e
%   variação 1. 

x = mat2gray(dados(:,2:end));
tamDados = size(dados);
for i = 2 : tamDados(1,2)
    for k = 1 : tamDados(1,1)
        dados_normal(k,i) = (dados(k,i) - mean(dados(:,i))) / (std(dados(:,i)));
    end
end
end


