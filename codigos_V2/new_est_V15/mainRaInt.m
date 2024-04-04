function  mainRaInt(col, estPe, opNor, inp )

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

% escolha dos percentuais a serem usados. 
if inp == 2
    perce = [0.2 0.5 0.2 0.1];
end

if inp == 1
    perce = [0.334 0.495 0.171];
end

% copias de arquivos e carregamentos dos dados. 
copyfile('normali.m', 'otimi');
cd otimi;
load dados.mat;

% escolha dos dados a serem usados. 
if inp == 1
    val = daGer{1,1}(:,1:3);
end

if inp == 2
    val = dados(:,2:5);
end

%opção para normalizar os dados. 
if opNor == 1
    valNor = normali(val);
else
    valNor = val;
end

% complementação dos dados após normalização.
tamValNor = size(valNor);
comp = (1:tamValNor(1,1));
if inp == 1
    valNor = [comp' valNor];
    %valNor = valNor(1:615,:);
end

if inp == 2
    valNor = [comp' valNor];
    %valNor = valNor(1:615,:);
end
% tamanho dos dados. 
tamNewDat = size(valNor);
for g = 2 : tamNewDat(1,2)
        valNor(:,g) = valNor(:,g) * perce(1,g-1);
end

%cd ..;
%cd ..;
%cd pre_processamento;
%[valNor, valTot] = main(valNor);
 

for i = 33:1:33
    str = int2str(i);
    str2 = strcat('../fol_',str);
    copyfile('../otimi/',str2);
    cd ..
    str3 = strcat('fol_',str);
    cd(str3);
    cd ..;
    cd 'residuos';
    % multiplicar os percentuais 
    
    [resid, residMat, somComp, somTot, newTot, canais, esc, retor] = ...
        main(col, valNor(15:976,:), inp);
    cd ..;
    cd(str3);
    cd 'GRASP';
    
    if inp == 2
    %desabilitar as linhas seguintes se os dados forem os compostos. 
        for u = 2 : tamNewDat(1,2)
            valNor1(:,u) = valNor(:,u) * ((perce(1,u-1)));
        end
        valNor = valNor1;
        valNor(:,1) = dat{2,1}(1:976,1);
    end
    % se os dados forem os compostos, mudar a entrada de 'valNor' para
    % 'valNor1'.
    x = GRASP( newTot, canais, esc, retor, valNor(15:976,:), 10 ...
        ,10 , col, estPe, inp);
    save x;
    cd ..
    cd ..
    cd otimi
end
end