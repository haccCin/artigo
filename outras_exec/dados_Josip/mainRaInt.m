function  mainRaInt 

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
% uma das partições

% Ordem dos dados: Carbono, agua, S3, SiO2

%% realiza o pre-processamento dos dados
cd pre_processamento
[dat_Josi, tot] = main;
cd ..

%%


cd otimi;
estPe = cell(4,1);
estPe{1,1} = [0.15 0.25];
estPe{2,1} = [0.45 0.55];
estPe{3,1} = [0.15 0.25];
estPe{4,1} = [0.05 0.15];
for j = 1 : 1 : 4
    cd ..;
    gconv = int2str(j);
    gnaFol = strcat('exec_' ,gconv );
    mkdir(gnaFol);
    cd 'residuos';
    [resid, residMat, somComp, somTot, newTot, canais, esc, retor] = ...
            main(j, dat_Josi);
    cd ..;    
    cd(gnaFol);
    for i = 1:1:15
        str = int2str(i);
        str2 = strcat('fol_',str);
        copyfile('../otimi/',str2);
        cd ..
        newStr = strcat(gnaFol,'/', str2);
        cd(newStr);%
        cd 'GRASP';
        x = GRASP( newTot, canais, esc, retor, dat_Josi,10 ,10 ,j,...
            estPe{j,1});
        save x;
        cd ..
        cd ..
    end
end
end
