function [ esc ] = referen( canais, qtd )
%REFEREN Summary of this function goes here
%   Detailed explanation goes here


%% Função para a escolha de canais

% Função para a escolha dos canais que serão fixos. Esses canais serão
% sorteados nos primeiros 900 canais, já que esses 

esc=zeros(qtd,2);
parou = false; 
i = 1;
tamCanais = size(canais);
while parou == false
   x = randi([1 tamCanais(1,1)],1,1);
   if isempty(find(esc == canais(x,:)))
       esc(i,:) = canais(x,:); 
       i = i + 1;
       if i > qtd
           parou = true;
       end
   end
end
end

