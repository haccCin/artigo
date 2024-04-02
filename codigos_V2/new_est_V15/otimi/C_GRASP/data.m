function [ resul, somAprox, matPerc ] = data(part, perce, col)
%DATA Summary of this function goes here
%   Detailed explanation goes here

%função para gerar os dados de interesse de cada partição. 

% Essa função ira gerar os dados de interesse de cada uma das partições.
% Esses dados de interesse serão: A integral dos compostos 
% (incluindo o sódio), tanto nas
% partições de referência, como na partição escolhida para ser variável. A 
% solução pelos mínimos quadrados para os compostos e para o sal. Para essa
% solução, se faz necessária a soma dos compostos, em cada uma das
% partições. A solução será dada por: x = (A'A)^(-1)A'b, onde A é a matriz 
% contendo a soma de cada um dos compostos nas partições, e 'b' é a soma da
% contagem espectral total para os compostos em cada uma das partições.
% Além disso, também sera retornado os valores percentuais de cada um dos
% compostos nas diferentes partições de interesse. Então, os parâmetros de
% entrada são: As contagens espectrais dos compostos, a contagem espectral
% total e as partições de interesse. O retorno será uma estrutura de
% dados contendo os valores acima descritos. É calculada a integral em cada
% uma das partições, na chamada da variável 'intPart', onde esse cálculo é
% feito multiplicando a largura da partição pela altura da mesma, como no
% cálculo de área de um retângulo. A estrutura de dados de retorno conterá
% os seguintes valores: 'starWide', o canal início de cada uma das
% partições, 'endWide ', o canal de fim de cada uma das partições, 
% 'intPart', a integral do composto descohecido simulado (o sódio), tomando
% por base aproximações por retângulos, 'somComp', a soma dos compostos
% envolvidos, incluisive a da biblioteca de sódio verdadeira, 'somTot', a
% soma da contagem espectral total em cada uma das partições, 'heighRet', a
% altura do retângulo para a simulação da integral do desconhecido
% simulado, 'half', a metade do espectro total na partição considerada, 
% utilizada para construção do sódio simulado, 'maxPart', o valor máximo da
% contagem espectral total na partição utilizada, 'minPart', o valor do
% mínimo da contagem espectral total na partição considerada, 'height',
% percentual considerado a partir do meio do caminho entre o maximo e
% minimo de contagem espectral total para localização da altura do retâgulo
% . A variavel 'pos' indicará se o retângulo foi construído acima ou abaixo
% da variável 'half'. A estrutura de saída 'out' irá conter em cada uma das
% suas células as seguintes informaçoes: na célula 1 irá conter as
% informações de cada partição em particular; a célula 2 irá conter as
% aproximações para os valores percentuais dos compostos; a célula 3 irá
% conter os valores da contagem espectral total para a aproximação do
% simulado desconhecido, em cada uma das partições.

% tamanho da partição
tamPart = size(part);

% matriz para receber os canais
matPart = zeros(tamPart(1,1), 2);
resul = cell(tamPart(1,1),1);

% matrizes para receber os vetores de compostos, vetores totais e aproximad 
matSomComp = zeros(tamPart(1,1),tamPart(1,1));
matSomAprox = zeros(tamPart(1,1), tamPart(1,1));
matSomTot = zeros(tamPart(1,1),1);

% laço iterado para cada uma das partições. 
for i = 1 : tamPart(1,1)
    
    % canal de início de uma partição
    matPart(i,1) = part{i,1}.starWide;
    
    % canal de fim de uma partição. 
    matPart(i,2) = part{i,1}.endWide;
    
    % introdução dos canais nos parâmetros da partição. 
    [part{i,1}(:).ch] = searCha(part{i,1}.starWide, part{i,1}.endWide,...
        part{i,1}.compostos)';
        % introduz na partição os canais existentes na mesma. 
    tamCh = size(part{i,1}.ch);
    intPart = 0;
    
    % Aproximação do composto omitido nas partições. Nesses passos é 
    % determinada a coordenada referente ao composto omitido nas diferentes
    % partições. 
    for t = 1 : tamCh(1,1)
        if part{i,1}.compostos(part{i,1}.ch(t,1),2) ~= -1
            intPart = intPart + part{i,1}.heighRet;
        end
    end
        % faz a aproximação para o composto suprimido nas diferentes
        % partições. 
    
     
    % Quantidade de canais. 
    var = (abs(part{i,1}.starWide - part{i,1}.endWide)+1);
    
    % soma das contagens espectrais dos diferentes compostos para uma
    % partição aebitrária 'i'. A saída sera uma matriz linha. 
    somComp = somCanais(matPart(i,:), part{i,1}.compostos(:, 2:end),...
        (var), perce); 
        
        
    % faz-se a transposição para a que coluna 1 da matriz seja referente 
    % apenas aos compostos na partição 1. Na ultima linha faz-se a
    % substituição do composto aproximado na devida partição 'i'. 
    matSomComp(:,i) = somComp';
    matSomAprox(:,i) = somComp';
    matSomAprox(col,i) = intPart;
        
    % determinação dos vetores de contagem espectral total.
    somTot = somCanais(matPart(i,:), part{i,1}.total, ...
        var, [1 1 1 1]);
    
    % coordenada do vetor de contagem espectral total na devida partição
    % 'i'. 
    matSomTot(i,1) = somTot;
    
    % construção da estrutura de dados. 
    temp = struct('starWide',part{i,1}.starWide,'endWide',...
        part{i,1}.endWide,'intPart', intPart, 'somComp', somComp,...
        'somTot', somTot,'heighRet', part{i,1}.heighRet, 'half', ...
        part{i,1}.half, 'maxPart', part{i,1}.maxPart, 'minPart',...
        part{i,1}.minPart, 'height', part{i,1}.height, 'pos',...
        part{i,1}.pos, 'posVarAlt',part{i,1}.posVarAlt,...
        'perce',perce,'partEsc',part{i,1}.partEsc, ...
        'compMeta', part{i,1}.compMeta, 'total', part{i,1}.total, ...
        'compostos', part{i,1}.compostos,'matSomAprox',matSomAprox,...
        'matSomComp',matSomComp,'matSomTot', matSomTot,'ch', part{1,1}.ch);
    resul{i,1} = temp;
end

% Construção da matriz particionadora apos iterar sobre as partições. 
matSomComp2 = [matSomComp ones(tamPart(1,1),1)]'; 

% construção do vetor de coordenadas após iterar sobre as partições. 
matSomTot2 = [matSomTot;1];

% construção da matriz aproximadora após iterar sobre as partições 
matSomAprox2 = [matSomAprox ones(tamPart(1,1),1)]';

% desabilitando mensagens do matlab
warning('off', 'all');

%% Início das aproximações. 

% determinação dos percentuais no particionamento
aprox = ((matSomComp2)' * matSomComp2)^(-1) * ((matSomComp2)') *...
    matSomTot2;

% valor do resíduo do passo anterior. 
resiPartMMQ = sum(abs(matSomTot2 - matSomComp2 * aprox));

% Determinação quantitativa pelo particionamento dos dados pelo método do
% ART, contendo a coluna com valores '1'. 
subArtICC = art('kaczmarz', matSomComp2, matSomTot2, 2000);

% valor do resíduo do passo anterior. 
resiPartArtIcc = sum(abs(matSomTot2 - matSomComp2 * subArtICC));
                                                         
% determinação quantitativa dos compostos pelo método 'ART', seguido da 
% determinação do valor do resíduo. 
subArtISC = art('kaczmarz', matSomComp2(1:end-1,:), matSomTot2(1:end-1),...
    2000);  
resiPartArtIsc = sum(abs(matSomTot2 - matSomComp2 * subArtISC));
                                                         
% comandos para as linhas seguintes o matlab desabilitar mensagens.                                                         
opts = optimoptions(@lsqlin, 'Display', 'off');

zPart = lsqlin( matSomComp2,matSomTot2,matSomComp2,matSomTot2, [],[],[],[],[],...
    opts);
resiZPart= sum(abs(matSomTot2 - matSomComp2 * zPart));
opts1 = optimset( 'Display', 'off');
tPart = lsqnonneg(matSomComp2,matSomTot2,opts1);
resiTPart= sum(abs(matSomTot2 - matSomComp2 * tPart));

% determinação quantitativa dos dados aproximando um composto omitido
% determinado por 'i' pelos mínimos quadrados. Em seguida, calcula-se o 
% valor do resíduo. 
aprox2 = ((matSomAprox2)' * matSomAprox2)^(-1) * ((matSomAprox2)') *...
    matSomTot2;
resiAproxMMQ = sum(abs(matSomTot2 - matSomAprox2 * aprox2));

% determinação quantitativa dos dados aproximando um composto omitido
% determinado por 'i' pelo método 'lsqlin' do matlab. Em seguida, determina
% -se o valor do resíduo. 
zAprox = lsqlin(matSomAprox2, matSomTot2,matSomAprox2,matSomTot2, [],[],[],[],...
    [], opts);
resiZAprox = sum(abs(matSomTot2 - matSomAprox2 * zAprox));

% agora faz-se a determinação das quantidades aproximando um deles omitido
% pela variável 'col'. Método do ART, contendo a linha 1 como restrição das
% coordenadas baricêntricas. depois, calcula-se o resíduo. 
aproxaartICC = art('kaczmarz', matSomAprox2, matSomTot2, 2000);
resiAproxArtIcc = sum(abs(matSomTot2 - matSomAprox2 * aproxaartICC));
                                                             
% mesma coisa do passo anterior, agora destacando a linha das restrições 
% coordenadas baricêntricas. 
aproxaartISC = art('kaczmarz', matSomAprox2(1:end-1,:), ...
    matSomTot2(1:end-1), 2000);  
resiAproxArtIsc = sum(abs(matSomTot2 - matSomAprox2 * aproxaartISC));
 
% agora o método dos mínimos quadrados não negativos, seguindo-se ao valor
% do resíduo. 
tAprox = lsqnonneg(matSomAprox2,matSomTot2, opts1);
resiTAprox = sum(abs(matSomTot2 - matSomAprox2 * tAprox));

matPerc = [aprox zPart tPart aprox2  zAprox tAprox subArtICC subArtISC ...
    aproxaartICC aproxaartISC]; 
    % variáveis: 'aprox', aproximação pelos mínimos quadrados; '' 
somAprox = cell(tamPart(1,1),1);

%% determinação das áreas abaixo das curvas nas diferentes aproximações. 
for k = 1 : tamPart(1,1)
    
    % determinação das áreas aproximadas 
    % no particionamento 
    somAprPart = aprox' * resul{k,1}.somComp';
    
    % no particionamento pelo LSQonneg
    somLSQNonneg = tPart' * resul{k,1}.somComp';
    
    % particionamento pelo método Z
    somLSQLin = zPart' * resul{k,1}.somComp';
    
    % pela aproximação dos mínimos quadrados
    somAprPart2 = aprox2' *resul{k,1}.somComp';
    
    % pela aproximação dos mínimo quadrados não negaticos
    somLSQNonneg2 = tAprox' * resul{k,1}.somComp';
    
    % pela aproximação pelo método Z
    somLSQLin2 = zAprox' * resul{k,1}.somComp';
    
    % pelo método ART no particionamento, com e sem linha correspondendo À
    % restrição das coordenadas baricêntricas. 
    soSubArtICC = subArtICC' * resul{k,1}.somComp';
    soSubArtISC = subArtISC' * resul{k,1}.somComp';
    
    % Pelo método ART na aproximação, com e sem linha correspondendo À
    % restrição das coordenadas baricentricas. 
    soAproxaartICC = aproxaartICC' * resul{k,1}.somComp';
    soAproxaartISC = aproxaartISC' * resul{k,1}.somComp';
    
    %construção da estrutra de dados
    temp2 = struct('somTot', resul{k,1}.somTot, 'somAprPart',somAprPart,...
        'somLSQNonneg',somLSQNonneg,'somLSQLin', somLSQLin,'somAprPart2',...
        somAprPart2,'somLSQNonneg2', somLSQNonneg2,'somLSQLin2',...
        somLSQLin2, 'soSubArtICC', soSubArtICC,'soSubArtISC', soSubArtISC...
        , 'soAproxaartICC', soAproxaartICC, ...
        'soAproxaartISC', soAproxaartISC, 'resiPartMMQ', resiPartMMQ,...
        'resiPartArtIcc', resiPartArtIcc, 'resiPartArtIsc', resiPartArtIsc,...
        'resiZPart', resiZPart, 'resiTPart', resiTPart, 'resiAproxMMQ',...
        resiAproxMMQ,'resiZAprox', resiZAprox, 'resiAproxArtIcc',...
        resiAproxArtIcc,'resiAproxArtIsc', resiAproxArtIsc,...
        'resiTAprox', resiTAprox);

    somAprox{k,1} = temp2;
end
end

