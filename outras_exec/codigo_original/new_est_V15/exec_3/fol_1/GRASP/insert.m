function [ saida,i ] = insert( canal, matriz )
%INSERT Summary of this function goes here
%   Detailed explanation goes here

%% função do Path relinking para inserir um canal.

% Função chamada durante o path relinking para inserir um canal. Recebe
% como parâmetro um canal a ser inserido, e uma matriz onde se deseja
% inserir o canal. A saída será uma matriz com um canal a mais adicionado
% comparativamente a 'matriz'fornecida como parâmetro de entrada. O
% parâmetro de entrada 'matriz' será considerada uma matriz linha. 

tamMatriz = size(matriz);
parou = false;
i = 1;
while parou == false && i < tamMatriz(1,1)
     if  canal < matriz(1,1)
         saida = [canal;matriz];
         parou = true;
         i = 1;
     end
     if  canal > matriz(end,1)
        saida = [matriz;canal]; 
        parou = true;
        i = tamMatriz(1,1);
     end
     if i < tamMatriz(1,1) && canal > matriz(i,1) && canal < matriz(i+1,1)
        temp = matriz(1:i,1);
        mat1 = [temp;canal];
        saida = [mat1; matriz(i+1:end,1)];
    end
    i = i + 1;
end

