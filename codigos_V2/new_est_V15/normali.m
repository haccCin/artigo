function [ norm_data ] = normali( dados )
%NORMALI Summary of this function goes here
%   Detailed explanation goes here

%% Função para normalizar os dados de entrada 

norm_data = dados;
tamDados = size(dados);

for i = 1 : tamDados(1,2)
    for j = 1 : tamDados(1,1)
        norm_data(j,i) = (dados(j,i) - min(dados(:,i))) / ...
            (max(dados(:,i))-min(dados(:,i)));
    end
end
end

