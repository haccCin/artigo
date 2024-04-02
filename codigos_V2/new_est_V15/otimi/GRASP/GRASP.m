function [ saida ] = GRASP( newTot, canais, ref, retor,comp,...
    tamL, numIter,col, estPe, inp)
%% 
resulPro = cell((numIter + 1), 1);

fprintf('****inicio_GRASP**** \n');
pause(1);

% inicio da execução 
minimo = + inf;

% vetor que armazenará os valores mínimos. 
metMin = inf(10,1);    
metMaxi = 0;           %ponteiro que indica qual o máximo valor de metrica
lista = cell(tamL,1);  %lista para armazenar as soluções.
t = 1;                 %ponteiro para indicar a iteração atual.
j = 1;                 % ponteiro para indicar a posição preenchida. 



% variável de retorno.
tamRetor = size(retor); 
partEsc = retor{tamRetor(1,1),1}.iteMMQ; 
                       
 
% arquivo para a escrita dos percentuais no particionamento e respectiva 
% métrica associada. Esse arquivo está escrito dentro da função 'escPerce'.
% Essa função 'escPerce' é chamada após cada uma das etapas GRASP.                      
filFid = fopen('aarqPerce', 'a');
fclose(filFid);


   
% Arquivo para a escrita dos percentuais para dados aproximados e respectiva 
% métrica associada (mesmo arquivo). Será escrito dentro da função 
% 'escPerce'. Leva em conta o os mínimos quadrados usual. Chamada após cada
% uma das etapas essenciais do GRASP.                                 
                                   
filFid2 = fopen('aarqPerceAprPart2','a');
fclose(filFid2);  

 % Definido na função 'defPart'. Traz o valor de estimativa mínima('minimo')
 % máximo valor de estimativa 'maximo'; 'maximTot' traz os valores de máximo 
 % valor de contagem espectral no intervalo de definição da partição;
 % 'minimTot' traz os valores de mínimo valor de contagem espectral total 
 % no intervalo de definição da partição. Esse arquivo está escrito dentro 
 % do arquivo 'defPart.m'. 
                                   
filFid3 = fopen('aarqEstAlt','a');
fclose(filFid3);
                                  
% arquivo para a escrita dos valores de número de condicionamento para o 
% caso de diminuição no valor da métrica para matrizes particionadoras. 
% Essa verificação é feita após o fim de cada estágio básico do GRASP. 
filFid4 = fopen('aarEstCond','a');                                  
fclose(filFid4);

% arquivo para a escrita dos valores de número de condicionamento para o 
% caso de diminuição no valor da métrica para matrizes aproximadoras. Essa
% vverificação é feita após cada estágio básico do GRASP. 

filFid5 = fopen('aarEstCondAlt', 'a');
fclose(filFid5);
                                   
% arquivo criado após o passo de construção. Ele será aberto e impresso 
% pelo comando 'impress', chamando a função de mesmo nome, onde o
% importante serão os seguintes parâmetros: percentuais(colunas 1-4);soma 
% aproximada (coluna 5); área real (coluna 6); diferença de áreas (coluna 7); 
% condicionamento (coluna 9). Resíduo (coluna 10). necessário criar um 
% comando para plotagem dessas variáveis. Esse arquivo será construído 
% após o passo de construção do GRASP.            
filFid6 = fopen('aarqBuil', 'a');
fclose(filFid6);
  
% arquivo criado após o passo básico de construção, seguido pelo passo do
% 'CGRASP'. Os parâmetros impressos serão os mesmos de 'aarqBuil'. Será
% aberto e escrito após o passo do CGRASP do passo construtivo.                                
                                   
filFid7 = fopen('aarqBuilCgrasp','a');
fclose(filFid7);                
 
% % arquivo criado após o passo de busca. Ele será aberto e impresso pelo 
% comando 'impress', chamando a função de mesmo nome, onde o importante 
% serão os seguintes parâmetros: percentuais(colunas 1-4);soma aproximada 
% (coluna 5); área real (coluna 6); diferença de áreas (coluna 7); 
% condicionamento (coluna 9). Resíduo (coluna 10). necessário criar um 
% comando para plotagem dessas variáveis. 
                                   
filFid8 = fopen ('aarqSearch','a');
fclose(filFid8);
                                   
% arquivo a ser usando no algoritomo de busca. sera responsavel por 
% escrever os parametros que dizem respeiot à altura do composto aproximado 
% nas partições: altura do retangulo, valor maximo da altura, valor minimo 
% da altura, metade da altura antes da modificacao, posicao em relacao a
% metade, inteiro que indica para que direcao a altura foi modificada,
% inicio da janela, fim da janela, altura modificada, comparativo com a
% metade, novo valor da metade.                                
filFid9 = fopen('aarqAltSearGra','a');
fclose(filFid9);
                                  
% arquivo para verificar as saídas de cada iteração do processo de busca 
% dio alterando a altura na partição de maior resíduo. Esse arquivo será
% escrito por 'impress' e trará os valores de percentuais e métricas.                                 

filFid10 = fopen('aarqIterSearchGras','a');
fclose(filFid10);
                                    
% arquivo que está sendo escrito na função 'enlarge'. Ele irá trazer os
% canais terminais e os canais finais, correntes e modificados.  
% 'starWide', newIni,'endWide', newTer, 'pos', pos,'partEsc', partEsc,'fim'
% ,fim,'newCha',newChan                                    
filFid11 = fopen('aarqIndices','a');
fclose(filFid11);    
                                   
% arquivo que está sendo escrito na função 'datEnlar'. impresso pela função
% 'impress'. Ira trazer os valores de percentuais e métricas como principal
% meta.                                  
filFid12 = fopen('aarSearDatEnlar','a');
fclose(filFid12); 

% arquivo para verificar as saídas da iteraço da linkagem dos canais. Esse
% arquivo est escrito na funço 'link' na pasta denominada 'GRASP'. ser pélo
% comando impress, imprimindo percentuais e metricas. 

filFid13 = fopen('aarqIterLink','a');
fclose(filFid13);
                                  
% trecho de código para verificar os percentuais e metricas a cada saída ds
% dos passos básicos da GRASP. Esse arquivo ser escrito aqui mesmo dentro
% da função. seria escrito pela funcao impress. 

filFid14 = fopen('aarqMelImproGra','a');
fclose(filFid14);


% coordenadas baricêntricas determinadas pelos compostos conhecidos. Essa
% arquivo será escrito na funçao 'estAlt'
filFid15 = fopen('aarqCoorBariPoin','a');
fclose(filFid15);

filFid16 = fopen('aarqIterSearGrasIao','a');
fclose(filFid16);

% verificação da modificaço da largura no passo construtivo do GRASP. Esse
% arquivo sera escrito pelo comando 'impressao'. Esse arquivo esta escrito
% na funço 'search' do GRASP. imprime percentuais e metrica

filFid17 = fopen('aarqIterSearGrasIss','a');
fclose(filFid17);

% arquivo para imprimir as diversas coordenadas baricentricas. Será escrito
% na função 'estAlt'

filFid18 = fopen('aarqdivCoorBari','a');
fclose(filFid18);

while metMin(1,1) > 0 && t <= numIter
    %% Início do processo de construção
    booOut = false;
    while j <= tamL || (booOut == false) 
        insert = false; 
        
        % construção de uma solução
        if inp == 1
            [parti, somAprox, matPerc, funRetBG] = build ( ref, partEsc,...
            comp, [1/0.334 1/0.495 1/0.171], newTot, canais, 10, col, ...
            estPe, minimo, metMin);
        end
        if inp == 2
            [parti, somAprox, matPerc, funRetBG] = build ( ref, partEsc,...
            comp, [1/0.436 1/0.17 1/0.394], newTot, canais, 10, col, ...
            estPe, minimo, metMin);
        end
        
        if j == 1
            resulPro{t,1} = {parti; somAprox; matPerc; funRetBG}; 
        end
                
        % verificação da saída. Aqui nao sera impresso. sera impresso
        % apenas no comando 'escPerce'. sera feito apenas se houver
        % percentuais apenas positivos. 
        if funRetBG < minimo &&  any (matPerc(:,4) < 0)== 0
           saida = {parti; [1];somAprox; matPerc};
           minimo = funRetBG;
        end
        
        % parametrização para entra em metrica 
        input = {parti; [1] ; somAprox; matPerc};
        
        % escrita do arquivo de metricas

        [valor, newResul] = metrica(input);
        metMin = escPerce(input, metMin, newResul, 2);
        
        % mudança para a pasta onde se encontra o CGRASP. 	
        cd ..;                           
        cd C_GRASP/; 
                                 
        % execução do CGRASP.                               
        [x, metMin, funRetBC] = CGrasp(matPerc,somAprox ,parti, 1, ...
            minimo, 3, 2, 2, 1, 0.5, col, metMin);
        
        % verificação da saída do CGRASP da busca. 

        % retornando à pasta do GRASP para verificar a viabilidade da ...
        % solução. imprimindo
        
        cd ..;
        cd GRASP;
        igua = quite(lista, x, 0.1);
        [metX, resulB] = metrica(x);
        metMin = escPerce(x, metMin, resulB, 3);

       % condição número 2.
        if j > tamL && igua == false
            booOut = true;
        end

        % condição número 3
        if j <= tamL && igua == false
            lista{j,1} = x;
            j = j + 1;
            if metX > metMaxi
                metMaxi = metX;
            end
            % mudança da variável que indica inserção
            insert = true; 
        end

        % condição numero 4
        if j <= tamL && igua == true
           igua = false; 
        end

        % parada para indicar construção de uma solução    
        fprintf('*********construiu_GRASP ************\n');
        pause(3);
        
       	if insert == true
            
            %valores trazidos pela construção. Esse arquivo irá trazer os
            %valores após a construção. esses valores tem que ser
            %comparados com os valores ao final de uma iteração do GRASP. 
            %esse arquivo está linkado com 'aarqMelImproGra'.
            [apxPart2, toPart2, pontNeg2, condMatApx2, resApxMMQ2, resApxZ2, ...
                resApxArtIcc2, resApxArtIsc2,  somPartZ2, somPartArtIcc2, ...
                somPartArtIsc2] = impress(matPerc, somAprox, parti, ...
                'aarqBuil');

            % valores trazidos pela busca + CGRASP.         
            [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ,...
                resApxArtIcc, resApxArtIsc, somPartZ, somPartArtIcc,...
                somPartArtIsc] = impress(x{4,1}, x{3,1}, x{1,1}, ...
                'aarqBuilCgrasp');
            
            % impressão dos parâmetros da partição
            arqBuild = fopen('aarqBuil','a');
        	impressao(arqBuild,[x{1,1}{1,1}.starWide x{1,1}{1,1}.endWide ...
                x{1,1}{1,1}.intPart x{1,1}{1,1}.heighRet x{1,1}{1,1}.half...
                x{1,1}{1,1}.maxPart x{1,1}{1,1}.minPart x{1,1}{1,1}.height...
            	x{1,1}{1,1}.pos x{1,1}{1,1}.compMeta]);
        	[x{1,1}{1,1}(:).ch] = searCha(x{1,1}{1,1}.starWide, ...
            	x{1,1}{1,1}.endWide, x{1,1}{1,1}.compostos)';
        	fclose(arqBuild);
        	      	            
            % escrita das melhoras de número de condicionamento encontradas
            % durante o processo de busca. 
            tamSaiConst = size(x{1,1});
            if metX <= minimo
                saida = x;
            	fprintf('ok \n');
            	arqEstCond = fopen('aarEstCond','a');
            	impressao(arqEstCond, ...
                    [cond(saida{1,1}{tamSaiConst(1,1),1}.matSomComp) t 0]);
            	fclose(arqEstCond);
            	arqEstCondAlt = fopen('aarEstCondAlt','a');
            	impressao(arqEstCondAlt, ...
                    cond(saida{1,1}{tamSaiConst(1,1),1}.matSomAprox));
            	fclose(arqEstCondAlt);
            	fprintf('inseriu_lista_GRASP \n');
                minimo = metX;
           end
        end
    end
    fprintf('*******fim_passo_construtivo************\n');
    pause(3);
    booOut = false;
       
%% Início da primeira busca. 

    % realização da etapa da busca
    [y1, metMin ] = search( x, 10, canais, 100, ref, col, estPe, ...
        minimo, metMin);
    
    % impressao
    [valPosS1, resPoS1] = metrica(y1);
    metMin = escPerce(y1, metMin, resPoS1, 3);
    
    % verificação da metrica e impressao 
    if valPosS1 < minimo
        saida= y1;
        minimo = valPosS1;
    end
    
    % mudança para a pasta onde está contido o CGRASP.
    cd ..;                              
    cd C_GRASP/
    
   % ajuste nas alturas das diferentes partições 
   [y, metMin, funRetSC] = CGrasp(y1{4,1}, y1{3,1}, y1{1,1}, 1, minimo,...
       3, 2, 2, 1, 0.5, col, metMin);
   
   % mundança de diretório 
   cd ..;
   cd GRASP;
   
   % verificaço da metrica 
   [valS1C, resulS1C] = metrica(y);
   metMin = escPerce(y, metMin, resulS1C, 4);
    
    % aviso de término do CGRASP. 
    fprintf('********terminou_GRASP_busca_1**************\n');
    pause(2);
    
    % retorno à pasta onde estava o GRASP.
    cd ..;
    cd GRASP/;
    
    % impressão dos parâmetros de percentuais e métricas.
    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, resApxArtIcc,...
       resApxArtIsc,  somPartZ, somPartArtIcc, somPartArtIsc] = ...
       impress(y{4,1}, y{3,1}, y{1,1}, 'aarqStepSearGra');
   
    % impressão dos parâmetros de janela das partições e altura do
    % aproximado. 
    
    arqSear1 = fopen('aarqSear1','a');
    impressao(arqSear1,[y{1,1}{1,1}.starWide y{1,1}{1,1}.endWide ...
            y{1,1}{1,1}.intPart...
            y{1,1}{1,1}.heighRet y{1,1}{1,1}.half y{1,1}{1,1}.maxPart...
            y{1,1}{1,1}.minPart y{1,1}{1,1}.height y{1,1}{1,1}.pos...
            y{1,1}{1,1}.compMeta]);
    fclose(arqSear1);
    
    % verifica número de condicionamento na melhora da área abaixo da
    % curva.
    tamSaiSea = size(y{1,1});
    if valS1C <= minimo
        saida = y;
        lista = insercao(lista,y);
        fprintf('inseriu_na_lista_após_busca \n');
        arqEstCond = fopen('aarEstCond','a');
        impressao(arqEstCond, ...
            [cond(saida{1,1}{tamSaiSea(1,1),1}.matSomComp) t 1]);
        fclose(arqEstCond);
        arqEstCondAlt = fopen('aarEstCondAlt','a');
        impressao(arqEstCondAlt, ...
            cond(saida{1,1}{tamSaiSea(1,1),1}.matSomAprox));
        fclose(arqEstCondAlt);
        minimo = valS1C;
    end
    % insere na lista do GRASP se a resposta da busca for melhor que a
    % solução que tenha  máximo valor de métrica na lista. 
    if valS1C < metMaxi
        lista = insercao(lista,y);
        fprintf('substituiu_de_maior_condicionamento \n');
        metMaxi = metMax(lista);
    end
    
    
%% início da linkagem
    % escolha de um elemento da lista.
    posi = randi([1 tamL],1,1);
    escolha = lista{posi,1};
    
    % linkagem 
    [k1, metMin, minLG] = linkagem(y, escolha, canais,10,20, ref, col,...
         estPe, partEsc,minimo, metMin );
     
     %impressao
    [valPosS2, resL] = metrica(k1);
    metMin = escPerce(k1, metMin, resL, 3);
    
    if valPosS2 < minimo
        saida = k1;
        minimo = valPosS2;
    end
    
    % impressao percentuais e metricas. 
    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, resApxArtIcc,...
       resApxArtIsc,  somPartZ, somPartArtIcc, somPartArtIsc] = ...
       impress(k1{4,1}, k1{3,1}, k1{1,1}, 'aarqMelImproGra'); 
   
    % execução do ajuste. 
    cd ..;                              
    cd C_GRASP/
    [k, metMin, fun] = CGrasp(k1{4,1}, k1{3,1}, k1{1,1}, 1, minimo, 3, 2, ...
        2, 1, 0.5, col, metMin);
    
    cd ..;
    cd GRASP/;
    
    % impressão dos parametros após a linkgem em tela. 
    strIterLink = num2str(i);
    strConcLink = strcat('***end_iter_GRASP_link_', strIterLink, '_***\n');
    fprintf(strConcLink);
    pause(1);
    
    % impressao dos parametros em arquivo. 
    arqLink = fopen('aarqLink','a');
    impressao(arqLink,[k{1,1}{1,1}.starWide k{1,1}{1,1}.endWide ...
            k{1,1}{1,1}.intPart...
            k{1,1}{1,1}.heighRet k{1,1}{1,1}.half k{1,1}{1,1}.maxPart...
            k{1,1}{1,1}.minPart k{1,1}{1,1}.height k{1,1}{1,1}.pos...
            k{1,1}{1,1}.compMeta]);
    fclose(arqLink);
    
    
    % calculo das metricas. A atribuicao à variavel 'metMin' é feita porque
    % na função 'escPerce' ele faz a verificaçao se o resultado trazido
    % pelo algoritmo  o menor ate entao encontrado. 
    [metK,resulLin] = metrica(k);
    metMin = escPerce(k,metMin,resulLin, 4);
    
    
    % verificação do numero de condicionamento na melhora da metrica.
    tamSaiL = size(k{1,1});
    if metK <= minimo
        saida = k;
        lista = insercao(lista,k);
        fprintf('achou \n');
        arqEstCond = fopen('aarEstCond','a');
        impressao(arqEstCond, ...
            [cond(saida{1,1}{tamSaiL(1,1),1}.matSomComp) t 2]);
        fclose(arqEstCond);
        arqEstCondAlt = fopen('aarEstCondAlt','a');
        impressao(arqEstCondAlt, ...
            cond(saida{1,1}{tamSaiL(1,1),1}.matSomAprox));
        fclose(arqEstCondAlt);
        minimo = metK;
    end
    
    % verificando se a solucao deve ser inserida na lista. 
    if metK < metMaxi
        lista = insercao(lista,k);
        metMaxi = metMax(lista);
    end
    
%% inicio da segunda busca 
    % iníciro da segunda busca.
 
    [z1, metMin] = search(k, 10, canais, 100, ref, col, estPe, minimo, ...
        metMin);
    
     % impressao
    [valPosS3, resPoS2] = metrica(z1);
    metMin = escPerce(z1, metMin, resPoS2, 3);
    
     % verificação da metrica e impressao 
    if valPosS3 < minimo
        saida= z1;
        minimo = valPosS3;
    end
    
    % mudaça de diretório. 
    cd ..;                              
    cd C_GRASP/
    
    % execução CGRASP    
    [z, metMin, funRetS2C] = CGrasp(z1{4,1}, z1{3,1}, z1{1,1}, 1, minimo,...
      3, 2, 2, 1, 0.5, col, metMin );
    
    % aviso de término do CGRASP. 
    fprintf('********terminou_GRASP_busca_2**************\n');
    pause(2);
    
     % retorno à pasta onde estava o GRASP.
    cd ..;
    cd GRASP/;
    
    % impressao de percentuais e metricas. Os valores trazidos pela segunda
    % busca tem que ser comparados com a iteração de mesma ordem na saida
    % da construção de uma solução. Esse arquivo 'aarqMelImproGra' e
    % 'aarqBuil' estão linkados. 
    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, resApxArtIcc,...
       resApxArtIsc,  somPartZ, somPartArtIcc, somPartArtIsc] = ...
       impress(z{4,1}, z{3,1}, z{1,1}, 'aarqMelImproGra');
   
    % impressao das metricas
    arqSear2 = fopen('aarqSear2','a');
    impressao(arqSear2,[z{1,1}{1,1}.starWide z{1,1}{1,1}.endWide ...
            z{1,1}{1,1}.intPart...
            z{1,1}{1,1}.heighRet z{1,1}{1,1}.half z{1,1}{1,1}.maxPart...
            z{1,1}{1,1}.minPart z{1,1}{1,1}.height z{1,1}{1,1}.pos...
            z{1,1}{1,1}.compMeta]);
    fclose(arqSear2);
    
    % calcula a metrica e escreve percentuais. 
    [metZ,resulSe2] = metrica(z);
    metMin = escPerce(z, metMin, resulSe2,4);
      
    % verifica a melhora no numero de condicionamento na melhora da metrica
    tamSaiSe2 = size(z{1,1})
    if metZ <= minimo
        saida = z;
        lista = insercao(lista,z);
        fprintf('achou \n');
        arqEstCond = fopen('aarEstCond','a');
        impressao(arqEstCond, ...
            [cond(saida{1,1}{tamSaiSe2(1,1),1}.matSomComp) t 3]);
        fclose(arqEstCond);
        arqEstCondAlt = fopen('aarEstCondAlt','a');
        impressao(arqEstCondAlt, ...
            cond(saida{1,1}{tamSaiSe2(1,1),1}.matSomAprox));
        fclose(arqEstCondAlt);
        minimo = metZ;
    end
    
    % insere na lista. 
    if metZ < metMaxi
        lista = insercao(lista,z);
        metMaxi = metMax(lista);
        
    end
    
    strSta = num2str(t);
    conca = strcat('***iter_grasp_fim_fim_busca_2', strSta, '******\n');
    fprintf(conca );
    pause(1); 
    t = t + 1;
    resulPro{t,1} = {z{1,1}; z{3,1}; z{2,1}; metZ};
    save resulPro; 
end
end