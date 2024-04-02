function [ resul, metMinLin1, min ] = link( start, target, canais, ...
    numMin, ref, col,  estPe, partEsc, fun, metMinSC2)
%LINK Summary of this function goes here
%   Detailed explanation goes here

%% Função para fazer a linkagem  entre duas soluções

% função que irá realiar a linkagem entre duas soluções. As diretrizes para
% essas linkagem são as seguintes:

% 1- Para realizar a linkagem entre as 2 soluções, pensa-se em uma maneira
% de discretizar as caracteristicas de cada uma das 2 soluções, tanto a
% solução alvo, como a solução start. . Essa discretização ocorrerá em
% nível de altura, assim  como no nível de largura. 

% 2- No sentido de linkar a altura do retângulo em cada um das duas
% soluções, pode-se verificar qual solução tem mais altura relativamente 
% uma a outra, calculando a diferença de altura entre elas. Essa diferença 
% de altura entre as soluções será discretizada, segundo um determinado 
% passo
% que irá dividir essa distância em diferentes pequenos segmentos. A
% solução de pior métrica pode ter sua altura diminuida (no caso da pior 
% solução for a solução de maior altura), desde que a altura de pior 
% métrica não ultrapasse o valor mínimo da solução variada, 
% ou pode ter sua altura aumentada desde que não ultrapasse o máximo da 
% solução variada. A altura do retângulo precisa ter seu parâmetro de
% posição da altura modificado caso ultrapasse a metade. 
% (no caso da pior solução ser a solução mais baixa). O mesmo vale para a 
% largura, verificam-se os canais presentes em cada uma das soluções, e 
% caso a melhor solução tenha mais canais presentes, pode-se inserir os 
% canais faltantes da melhor solução na pior solução. Caso contrário, 
% pode-se extrair os canais excedentes da pior solução e verificar o 
% comportamento da solução. 

% Calcula-se a métrica das soluções start e target. Se a métrica da solução
% start for melhor que a da solução target, inverte-se a atribuição de cada
% solução. 

% Para o caso da linkagem na largura dos canais: O inicio da solução start
% pode acontecer antes do inicio da solução target e o fim da solução start
% pode acontecer antes do fim da solução target. Isso acontecendo, a
% linkagem entre a solução target  e start vai se dar a partir do inicio
% das duas solução: O inicio da  solução start caminhará em direção ao
% inicio da solução target, e a cada passo serão calculados os valores
% pertinentee. Assim que os dois inicio conincidirem, os fins caminharão um
% em direção ao outro. A cada passo, serão calculados os valores. Isso
% também acontecerá se o inicio da target acontecer antes do inicio da
% start, e o fim da target acontecer antes do fim da start. A solução
% target pode estar contida dentro da solução start. Nessa situação, o
% início da targer será diminuída até o início da solução start, e a cada
% passo dado os valores pertinentes serão calculados. Depois de ocorrer a
% coincidência entre os inícios, o fim da target caminhará em direção ao
% fim da start. 

% A função irá definir uma matriz contendo todos os valores de canais
% presentes na solução start e target. Depois da definição dessas matrizes,
% serão verificados o canais que estão presentes em start e ausentes em
% target. O contrário também é feito, ou seja, os canais presentes em
% target e ausentes em start. 

% são construidas duas estruturas de dados auxiliares. A primeira delas,
% 'exisStarTarg', são os valores de canais que estão presentes em start e
% não presentes em target. Se existirem valores nulos nessa estrutura,
% esses canais devem ser excluidos da soluição start. A contagem de
% diferenças entre as duas soluções levará em conta a quantidade de valores
% nulos entre existStartTare exisTarStar. Ao se extrair um canal de start,
% a diferença entre as duas soluções diminui de 1.

% Ao ser pesquisado exisTargStar, o número de elementos nulos nessa
% estrutura indicarão os canais a serem inseridos em start. Ao ser inserido
% um canal em start, as diferenças entre as duas soluções diminui de 1. Ao
% ser inserido um canal que não esteja contiguo a um determinado intervalo,
% ao se formar a soma de compostos por 'somCanais', os parâmetros de
% entrada para 'somCanais' tomará como parâmetro uma matriz que contém numa
% linha o intervalo de canais a serem somados. Caso o canal não seja
% contiguo, define-se uma nova linha contendo os intervalos que não são
% contiguos. Passa-se ainda para 'somCanais' a estrutura de contagens
% espectrais, a quantidade de canais para cada um do intervalos, e os
% percentuais para desnormalizar os dados. Ou seja, vamos supor que a
% partição escolhida tenha um intervalo de [34 54] e se deseje inserir um
% canal que não seja contiguo a esse intervalo definido, 13, por exemplo.
% Logo, a matriz passada para a função de soma dos compostos receberá como
% parâmetro a matriz [34 54; 13 13]. 


%% Definições iniciais
% Nesse ponto do algoritmo, ele verificará as soluções 'start' e 'target'.
% Verificará qual partição que está variando os seus parâmetros no primeiro
% laço que se inicia com o for tendo a variável de controle 'i'.
% Calculam-se as duas métricas das duas soluções em questão para se
% verificar qual delas tem o menor valor de métrica. Essas duas soluções
% são trocadas caso a solução 'start' tenha uma métrica menor que a solução
% 'target'. Verificam-se quais canais estão presentes na solução 'start' e
% ausentes na solução 'target', e quais estão presentes na solução 'target'
% e ausentes na solução 'start'. A primeira quantidade de diferenças é
% importante para se verificar que canais se extrair da solução start,
% enquanto que a segunda quantidade de diferenças é importante para se
% verificar que canais se inserir na solução start. Caculam-se as
% quantidades de diferenças totais das duas soluções, somando-se as
% quantidades de diferenças. 

% atribuiçaõ de variavel
metMinLin1 = metMinSC2;

% realiza a troca das variáveis caso start tenha melhor qualidade que targ.
metStar = metrica(start);
metTarg = metrica(target);
if metStar < metTarg
    targTemp = target;
    target = start;
    start = targTemp;
    metTemp = metTarg;
    metTarg = metStar;
    metStar = metTemp;
end

% atribuição da variável de saída
min = fun;

%atribuição da saída  soluço target. 
resul = target;

% qual o canal inicial da partição de maior resíduo
parStar = start{1,1}{1,1}.starWide;

% qual o canal final da partição de maior resíduo. 
finStar = start{1,1}{1,1}.endWide;

% o canal é inserido apenas se seu indexador for 1.
matStart = searCha(parStar,finStar,start{1,1}{1,1}.compostos);

% canal inicial da solução target
parTar = target{1,1}{1,1}.starWide;

%canal final da solução target
finTar = target{1,1}{1,1}.endWide;

% descrição dos canais inseridos na solução target. 
matTarget = searCha(parTar,finTar,target{1,1}{1,1}.compostos);

% verifica os canais presentes em start e ausentes em target.
exisStarTarg = dif(matStart, matTarget);

% verifica os canais presentes em target e ausentes em start. 
exisTarStar = dif(matTarget,matStart);

% soma das diferenças entre as soluções start e target.
value1 = sum(exisStarTarg(:)==0); 

% soma das diferenças entre solução target e start.
value2 = sum(exisTarStar(:)==0);

% soma das diferenças.
value = value1+value2;

% comando para inserir os canais na solução start
[start{1,1}{1,1}(:).ch] = (matStart)';   

% comando para inserção na solução target. 
[target{1,1}{1,1}(:).ch] = (matTarget)'; 

% ponteiro para indicar o fim do laço da 
% linkagem.
parou = false;

% numero de canais que podem ser retirados da solução 
% start.  
tamMatStart = size(matStart);
[start{1,1}{1,1}(:).free] = tamMatStart(1,2) - numMin; 


while value > 0 && parou == false
    
    
    % comando refeito para o caso de uma nova solução start.
    % Inicio e fim da solução start.	
    parStar = start{1,1}{1,1}.starWide;
    finStar = start{1,1}{1,1}.endWide;
    
    % inicio e fim da solução target.	
    parTar = target{1,1}{1,1}.starWide;
    finTar = target{1,1}{1,1}.endWide;
     
    % descrição dos canais inseridos efetivamente em cada solução.                                   
    matTarget = searCha(parTar,finTar,target{1,1}{1,1}.compostos);
    matStart = searCha(parStar,finStar,start{1,1}{1,1}.compostos);
     
    % impressão dos canais em arquivo                                   
    impressi = fopen('aaimpreVir','a');
    impressao(impressi,[matStart 0 matTarget 0 metStar metTarg]);
    fclose(impressi);

    % métricas associadas a cada solução. 
    metStar = metrica(start);
    metTarg = metrica(target);
    
    % troca das soluções caso uma seja melhor que a outra.                                     
    if metStar < metTarg
        targTemp = target;
        target = start;
        start = targTemp;
        metTemp = metTarg;
        metTarg = metStar;
        metStar = metTemp;
    end
    
    % matriz de canais na solução start e ausentes em target. 	                                     
    matStar = (start{1,1}{1,1}.ch);
    exisStarTarg = dif(matStar', matTarget);
    
    % canais na solução target e ausente em start. 	                                   
    exisTarStar = dif(matTarget,matStar);
    
    % tamanho das soluções                                  
    tamStar  = size(exisStarTarg);
    tamTarg = size(exisTarStar);

    % quantidade de diferenças entre as soluções
    value1 = sum(exisStarTarg(:)==0); 
    value2 = sum(exisTarStar(:)==0);
    value = value1+value2;
    
    % lista do algoritmo
    lista = cell(value,1);
    positi = 1;

    
    for i = 1 : tamStar(1,1)
        % copia a ser modificada da solução start.
        copStar1 = start;

        % recuperação dos dados de entrada modificados. 
        copTot1 = start{1,1}{1,1}.total;
        copComp1 = start{1,1}{1,1}.compostos;
        
        % se existe em start e não em target e se a solução 
        % start tem um número mínimo de canais. 
        if exisStarTarg(i,1) == 0 && tamStar(1,1) >= numMin
            
            % define intervalos antes e após o canal retirado de start.  
            [mat1,mat2] = defInter(matStar,i,0);
            
            % esse caso é executado apenas se não for nem 1° nem ultimo can
            if ~isempty(mat1) && ~isempty(mat2)
                
                % fundir as matrizes. Aqui dentro dessa funço j ocorre a
                % definiçao da particao. 
                resul1 = fus([mat1;mat2],matStar, copTot1, copComp1, ...
                    canais, partEsc,0, start{1,1}{1,1}.perce, ref, col,...
                    partEsc, estPe);
                
                % cálculo dos parâmetros das partições. 
                copStar1{1,1}{1,1} = resul1.part;
                param1 = copStar1{1,1};
                [partTemp, somAproxTemp, matPercTemp] = ...
                    data(param1, start{1,1}{1,1}.perce, col);
                
                % impressao das metricas e dos percentuais. 
                [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
                    resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
                    somPartArtIsc] = impress(matPercTemp, somAproxTemp, ...
                    partTemp, 'aarqIterLink');
                            
                % parametrizacao do resultado. 
                dat1 = {partTemp; matPercTemp(:,1);somAproxTemp;...
                    matPercTemp};
                [dat1{1,1}{1,1}(:).ch] = (resul1.ch);
                tamSol1 = size(dat1{1,1}{1,1}.ch);
                [dat1{1,1}{1,1}(:).free] = tamSol1(1,1) - numMin;
                [metDat3, resul1L] = metrica(dat1);
                
                % impressao
                metMinLin1 = escPerce(dat1, metMinLin1, resul1L, 4); 
                
                % impressão dos canais em arquivo                                   
                impressi = fopen('aaimpreVir','a');
                matConcat = [(mat1)' (mat2)'];
                impressao(impressi,[matConcat 0 matTarget 0 apxPart ...
                    metTarg]);
                fclose(impressi);
                
                % inserçao na lista se o resultado atual for melhor que
                % start. 
                if metDat3 < metStar && positi <= value1
                    lista{positi,1} = dat1;
                    positi = positi + 1;
                    if abs(metDat3) < min
                        resul = dat1;
                        min = abs(metDat3);
                    end
                end
            else
                % se mat1 for não vazio, mas mat2 for vazio. 
                if ~isempty(mat1)
                    % matriz indexadora de canais será apenas mat1
                    ch = mat1;
                    
                    % definiçao da partiçao. 
                    partTemp = defPart(ch(1,1), ch(end,1),... 
                        start{1,1}{1,1}.total, start{1,1}{1,1}.compostos,...
                        canais, partEsc, start{1,1}{1,1}.perce,ref, col,...
                        partEsc, estPe);
                    
                    % parametrizacao para definicao dos dados pela chamda À
                    % funçao 'data'.
                    copStar1{1,1}{1,1} = partTemp;
                    param = copStar1{1,1};
                    [partTemp, somAproxTemp, matPercTemp] = ...
                        data(param, start{1,1}{1,1}.perce, col);
                    
                    % parametrizacao para impressao dos percentuais e das 
                    % metricas. 
                    dat2 = {partTemp; matPercTemp(:,1);somAproxTemp; ...
                        matPercTemp};
                    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, ...
                        resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                        somPartArtIcc, somPartArtIsc] = ...
                        impress(matPercTemp, somAproxTemp, partTemp, ...
                        'aarqIterLink');
                    
                    % impressao
                    [metDat1, resulL2] = metrica(dat2);
                    metMinLin1 = escPerce(dat2, metMinLin1, resulL2, 4);
                    
                     % impressão dos canais em arquivo                                   
                     impressi = fopen('aaimpreVir','a');
                     matConcat = mat1;
                     impressao(impressi,[(matConcat)' 0 matTarget 0 apxPart ...
                        metTarg]);
                     fclose(impressi);
                                   
                    % reconfiguraçao das partiçoes 
                    [dat2{1,1}{1,1}(:).ch] = ch;
                    tamSol2 = size(dat2{1,1}{1,1}.ch);
                    [dat2{1,1}{1,1}(:).free] = tamSol2(1,1) - numMin;
                                        
                    % insercao na lista caso a solucao atual seja melhore
                    % que a solucao start. 
                    if metDat1 < metStar && positi <= value1
                        lista{positi,1} = dat2;
                        positi = positi + 1;
                        if abs(metDat1) < min
                            resul = dat2;
                            min = abs(metDat1);
                        end
                    end
                else
                    % dispensa 'mat1' pois  vazio. A matriz indexadora da
                    % nova soluço será apenas 'mat2'.
                    ch = mat2;
                    
                    % redefiniçao da partiçao apos exclusao de um canal de
                    % start. 
                    partTemp = defPart(ch(1,1), ch(end,1),...
                        start{1,1}{1,1}.total, start{1,1}{1,1}.compostos,...
                        canais, partEsc, start{1,1}{1,1}.perce, ref, col,...
                        partEsc, estPe);
                    
                    % modifica a copia da solucao start e recalcula
                    % parametros.
                    copStar1{1,1}{1,1} = partTemp;
                    param = copStar1{1,1};
                    [partTemp, somAproxTemp, matPercTemp] = ...
                        data(param, start{1,1}{1,1}.perce, col);
                    dat3 = {partTemp; matPercTemp(:,1);somAproxTemp; ...
                        matPercTemp};
                    
                     % impressao
                    [metDat2, resulL3] = metrica(dat3);
                    metMinLin1 = escPerce(dat3, metMinLin1, resulL3, 4);
                    
                    % impressao dos percentuais e metricas. 
                    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, ...
                        resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                        somPartArtIcc, somPartArtIsc] = ...
                        impress(matPercTemp, somAproxTemp, partTemp, ...
                        'aarqIterLink');
                    
                     % impressão dos canais em arquivo                                   
                     impressi = fopen('aaimpreVir','a');
                     matConcat = mat2;
                     impressao(impressi,[(matConcat)' 0 matTarget 0 apxPart ...
                        metTarg]);
                     fclose(impressi);
                                
                    % escrita dos arquivos. 
                    [dat3{1,1}{1,1}(:).ch] = ch;
                    tamSol3 = size(dat3{1,1}{1,1}.ch);
                    [dat3{1,1}{1,1}.free] = tamSol3(1,1) - numMin;
                                        
                    % insercao na lista caso a solucao modificada seja
                    % melhor que a solucao start. 
                    if metDat2 < metStar && positi <= value1
                        lista{positi,1} = dat3;
                        positi = positi + 1;
                        if abs(metDat2) < min
                            resul = dat3;
                            min = abs(metDat2);
                        end
                    end   
                end
            end
        end
    end
    % nesse ponto irá introduzir os canais de target em start
    for k = 1 : tamTarg(1,1)
       % copia da solução start.
       copStar2 = start;
       
       % copia da matri de contagem espectral total.
       copTot2 = start{1,1}{1,1}.total;
       
       % copia da matriz de contagem espectral total. 
       copComp2 = start{1,1}{1,1}.compostos; 
       
       % se existe em target e noo existe em start.
       if exisTarStar(k,1) == 0
           % descriçao dos canais em start
           l = start{1,1}{1,1}.ch;
           
           % canal de target.
           p = matTarget(1,k);
           
           % insercao do canal na posicao devida. 
           [matIns, pos] = insert(p,l);
           
           % define as duas matrizes. 
           [mat1,mat2] = defInter(matIns,pos,1);
           if ~isempty(mat1) && ~isempty(mat2)
               
               % realiza a fusao entre as matrizes. nessa funço existe já a
               % definiçao da particao. 
                resul2 = fus([mat1;mat2], matStar, copTot2, copComp2, ...
                    canais, partEsc, 1, start{1,1}{1,1}.perce, ref, col,...
                    partEsc, estPe);
                
                % copia de  start modificada. 
                copStar2{1,1}{1,1} = resul2.part;
                param2 = copStar2{1,1};
                
                % determinacao dos parametros. 
                [partTemp, somAproxTemp, matPercTemp] = ...
                    data(param2,start{1,1}{1,1}.perce, col);
                
                
                % impressao de percentuais e metricas. 
                [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, ...
                        resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                        somPartArtIcc, somPartArtIsc] = ...
                        impress(matPercTemp, somAproxTemp, partTemp, ...
                        'aarqIterLink');
                
                % reparametrizacao dos dados. 
                dat4 = {partTemp; matPercTemp(:,1);somAproxTemp; ...
                    matPercTemp};            
                [dat4{1,1}{1,1}(:).ch] = (resul2.ch);
                tamSol4 = size(dat4{1,1}{1,1}.ch);
                [dat4{1,1}{1,1}(:).free] = tamSol4(1,1) - numMin;
                
                 % impressao
                 [metDat4, resulL4] = metrica(dat4);
                 metMinLin1 = escPerce(dat4, metMinLin1, resulL4, 4);
                
                % impressão dos canais em arquivo                                   
                impressi = fopen('aaimpreVir','a');
                matConcat = [(mat1)' (mat2)'];
                impressao(impressi,[matConcat 0 matTarget 0 apxPart ...
                    metTarg]);
                fclose(impressi);
                
                % verificando se a soluço modificada é melhor que start. 
                if metDat4 < metStar && positi <= value
                    lista{positi,1} = dat4;
                    positi = positi + 1;
                    if abs(metDat4) < min
                        resul = dat4;
                        min = abs(metDat4);
                    end
                end
            end
       end
    end
    
    % escolhe um elemento da lista para ser a nova solução 
    if positi > 1
        valor = randi([1 positi-1],1,1);
        start = lista{valor,1};
    else
        parou = true;
    end
    
    % dimiue o número de diferenças
    value = value - 1;
    strSta = num2str(value);
    conca = strcat('Retirada_uma_diferenca_', strSta, '\n');
    fprintf(conca);
    
    % aberutura do arquivo para indicar fim de execução 
    fimExe = fopen('aaimpreVir', 'a');
    impressao(fimExe,[-1 -1 -1 -1 -1 -1]);
    fclose(fimExe);
    
end
end
