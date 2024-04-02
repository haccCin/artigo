function [ dif ] = dif( matStar, matTar )
%DIF Summary of this function goes here
%   Detailed explanation goes here

%% Função para determinar as diferenças entre start e target

% função para determinar as diferenças entre as funções target e start.
% Essa função receberá como parãmetros a matriz de canais 
% de cada uma das duas soluções, start e target, e retornará uma matriz
% do tamanho correspondente à diferença entre o menor e o maior valor. Essa
% matriz conterá o valor nulo para os canais que estão presentes em apenas
% uma das matrizes, e o valor 1 para os canais que estão presentes em ambas
% as soluções. Essa função retornará os valores que estão presentes em
% start e ausentes em target. Para encontrar os valores que estão presentes
% em target e ausentes em start, basta inverter a ordem dos parâmetros de
% entrada na chamada da função. 



tamStar = size(matStar);
dif = zeros(tamStar(1,1),1);
for i = 1 : tamStar(1,2)
    [a,b] = find(matTar == matStar(1,i)); 
    if isempty(a)
        dif(i,1) = 0;
    else
        dif(i,1) = 1;
    end
end
end

