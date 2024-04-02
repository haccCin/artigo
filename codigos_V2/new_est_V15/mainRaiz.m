function  mainRaiz(inp)

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

estPe = cell(3,1);
if inp == 1
    estPe{1,1} = [0.284 0.384];
    estPe{2,1} = [0.445 0.545];
    estPe{3,1} = [0.121 0.221];
end
if inp == 2
    estPe{1,1} = [0.386 0.486];
    estPe{2,1} = [0.120 0.220];
    estPe{3,1} = [0.344 0.444];
end
for col=1:3
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
    copyfile('../normali.m');
    mainRaInt(col, estPe{col,1}, 1, inp);
    cd ..;
end
end

