function [ quantidade, canais] = mult( valor, multi )
%MULT Summary of this function goes here
%   Detailed explanation goes here


%% Função para determinar a quamtidade de multiplos de um valor

% Função para determinar a quantidade de múltiplos de um valor. É fornecido
% o valor, e deseja-se saber quantos múltiplos de 'multi' esse valor contém.
% Se a contagem for  menor que valor - multi, é realizada mais uma contagem
% para se criar uma nova partição. 

quantidade = 0; % quantas partições existem 
parou = false; 
i = 0; 
canais = [];
while i < valor && parou == false
    if i < (valor - multi)
        
        
        if mod(i, multi) == 0
            quantidade  = quantidade  + 1;
            canais(quantidade,1) = i;
            canais(quantidade,2) = i + multi;
        end 
            % caso a contagem tenha atingido um múltiplo. Ao atingir o
            % valor inicial de um intervalo, ele inicia esse intervalo na.
            % Na linha seguinte, finaliza. A variável quantidade é um
            % ponteiro que verifica quantas partições foram iniciadas. 
   else
        quantidade = quantidade + 1;
        parou = true; 
        canais(quantidade,1) = canais(quantidade-1,2);
        canais(quantidade,2) = valor;
    end
    i = i + 1;
    
end
canais(1,1) = 1;
end
