function  main

%MAIN Summary of this function goes here
%   Detailed explanation goes here

%% Chamada principal para os dados 

% Função principal para a chamada dos dados. 'x', 'y', 'z', 'w' e 'k' são,
% respectivamente, os valores de resíduo para cada uma das partições do
% conjunto total de canais, o resíduo trazido por meio do método dos
% mínimos quadrados do Matlab, a soma de cada um dos compostos para cada 
% uma das partições, a soma das contagens espectrais para cada uma das
% partições e 'k' contém dados para cada uma das partições, como o resíduo
% da partição, o resíduo trazido pela chamada ao método do Matlab em cada
% uma das partições, 

    load dados.mat;
    cd ..;
    cd 'residuos';
    [resid, residMat, somComp, somTot, newTot, canais, esc, retor] = main;
    cd ..;
    cd 'otimi';
    cd 'GRASP';  
    x = GRASP( newTot, canais, esc, retor, dat{1,1}, 3, 50, 2);
    save x;


end

