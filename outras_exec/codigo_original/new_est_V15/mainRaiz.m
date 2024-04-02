function  mainRaiz

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

estPe = cell(4,1);
estPe{1,1} = [0.15 0.25];
estPe{2,1} = [0.45 0.55];
estPe{3,1} = [0.15 0.25];
estPe{4,1} = [0.05 0.15];
for col=1:4
    carac = int2str(col);
    carac2 = strcat('sem_col_',carac);
    mkdir(carac2);
    cd(carac2);
    mkdir 'otimi'
    cd otimi;
    copyfile ('../../otimi/');
    cd ..;
    mkdir residuos;
    cd residuos;
    copyfile('../../residuos/');
    cd ..;
    copyfile('../mainRaInt.m');
    mainRaInt(col, estPe{col,1});
    cd ..;
end
end

