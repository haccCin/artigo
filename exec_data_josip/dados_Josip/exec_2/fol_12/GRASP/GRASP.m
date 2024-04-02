function [ saida, saida1 ] = GRASP( newTot, canais, ref, retor,comp,...
    tamLista, numIter,col, estPe)
%% Início de todo o programa

% para certificar que copiou daqui. 

% nesse trecho ocorrerá toda a inicialização das variáveis, além de
% abertura dos arquivos que trarão os resultados. A variável 'metMin' irá
% comparar as diversas métricas utilizadas na execução do programa. Cada
% uma dessas métricas levará em conta os resultados trazidos pelos
% diferents métodos de mínimos quadrados. Cada uma dessas métricas trazidas
% por diferentes mínimos quadrados, será comparada com a área real abaixo
% da curva espectral total. 


fprintf('inicio \n') % indica o iníco da execução do programa
metMin = inf(14,1); % variável para armazenar as métricas de melhora
metMaxi = 0;    % ponteiro que indica qual o máximo valor de metrica
lista = cell(tamLista,1); % lista para armazenar as soluções.
t = 1; % ponteiro para indicar a iteração atual.
j = 1; % ponteiro para indicar a ultima posição da lista preenchida. 

arqBuild = fopen('aarqBuil','a');
fprintf(arqBuild,...
            '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\n',...
            's','e','integralPartic', 'alturaRetang', 'metadePartic', ...
            'maximaPartic', ...
            'minimoPArtic', 'alturaPartic', 'p', 'comparativoMet');
fclose(arqBuild); 
                  % abertura de arquivo para armazenamento dos parâmetros 
                  % da solução construída, tais como: início de uma janela,
                  % fim de uma janela, integral da partição, altura de um
                  % retângulo, metade do intervalo onde a altura é definida
                  % , maximo valor do intervalo que define a altura, minimo
                  % valor do intervalo que define a altura, fator
                  % multiplicativo que define a altura do retângulo a
                  % partir da multiplicação da metade do mesmo, inteiro que
                  % define se a altura do retângulo está acima ou abaixo da
                  % metade do intervalo que o define e o número real que 
                  % compara a metade da altura com a  altura atual. 
                  
arqSear1 = fopen('aarqSear1','a');
    fprintf(arqSear1,...
             '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\n',...
            's','e','integralPartic', 'alturaRetang', 'metadePartic', ...
            'maximaPartic', ...
            'minimoPArtic', 'alturaPartic', 'p', 'comparativoMet');
fclose(arqSear1);
                 % As saídas da primeira busca também averiguam os mesmos
                 % dados da saída da construção.
                    
arqLink = fopen('aarqLink','a');
    fprintf(arqLink,...
             '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\n',...
            's','e','integralPartic', 'alturaRetang', 'metadePartic', ...
            'maximaPartic', ...
            'minimoPArtic', 'alturaPartic', 'p', 'comparativoMet');
fclose(arqLink);
                 % arquivo de saída da linkagem que verifica os mesmos
                 % parâmetros de saída da construção. 

arqSear2 = fopen('aarqSear2','a');
    fprintf(arqSear2,...
             '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\n',...
            's','e','integralPartic', 'alturaRetang', 'metadePartic', ...
            'maximaPartic', ...
            'minimoPArtic', 'alturaPartic', 'p', 'comparativoMet');
fclose(arqSear2);
                 % arquivo de saída da segunda busca que verifica os mesmos 
                 % parâmetros de saída que a construção da solução. 

arqAlt = fopen('aarqAlt','a');
fprintf(arqAlt,...
    '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\n',...
    'alturaRetangulo','maximoAltura','minimoAltura','presenteMetade',...
    'p','pV','novaAltura***','variacPercAlt','percentAltur','s','e',...
    'pp','comparatMet','metaAltura***','novoComparaMetade');
fclose(arqAlt); 
                % esse arquivo não é escrito aqui dentro. ele está definido 
                % dentro da função 'defPart'. Contém grandezas como 'altura
                % retângulo', 'maximoAltura', 'mínimoaltura',
                % 'presenteMetade', posição da altura (p), variação dessa
                % posição (valor discreto zero ou um que indica se foi para 
                % cima ou para baixo a partir da posição atual) ('pv'),
                % novo valor da altura 'novaAltura', percentual da variação
                % da altura 'percenAltur', início de um canal 's', fim de
                % um canal 'e', 

arqLarg = fopen('aarqLar','a');
fprintf(arqLarg,...
    '%s\t %s\t %s\t %s\t %s\t %s\n','s','e','nS','nE',...
    'p','f');
fclose(arqLarg);
                % esse arquivo não é escrito aqui dentro. Escrita dos 
                % valores do arquivo está definida em 'search'. Os valores
                % dentro do arquivo são na variação da largura da
                % partição: Início da partição (s), fim da partição (e), 
                % novo início da partição (ns), novo fim da partição (ne),
                % posição da altura atual (pos) e quantidade de canais
                % (fim).

arq = fopen('aarqIndices','a');
fprintf(arq,'%s\t%s\t%s\t%s\t%s\t%s\t\n','i1','i2',...
            'variacao******', 'de','va','vL' );
fclose(arq);
             % nao está definido dentro desse arquivo. Está definido dentro
             % da função 'enlarge'. Responsável por realizar o alargamento
             % no intervalo de uma partição. Traz dados como: nova janela
             % de início 'i1'; nova janela de término 'i2'; variação na
             % quantidade de janelas 'variação'; 'de' é um inteiro que
             % indica se houva uma variação na largura para mais ou para
             % menos; 'va' é setado igual a 1; 'vL' é a quantidade de
             % canais que irá sera adicionado ou extraído na variação da
             % partição. 

arqEstAlt = fopen('aarqEstAlt','a');
fprintf (arqEstAlt,'%s\t%s\t%s\t%s\t\n', 'minimo', 'maximo','maximTot', ...
    'minimTot');
fclose(arqEstAlt);
             % Definido na função 'defPart'. Ele traz os valores de minimo
             % valor de estimativa 'minimo'; máximo valor de estimativa
             % 'maximo'; 'maximTot' traz os valores de máximo valor de
             % contagem espectra no intervalo de definição da
             % partição;'minimTot' traz os valores de mínimo valor de
             % contagem espectral total no intervalo de definição da
             % partição. Esse arquivo está escrito dentro do arquivo
             % 'defPart.m'.

arqEstCond = fopen('aarEstCond','a');
fprintf(arqEstCond, '%s\n', 'Condicionamento');
fclose(arqEstCond)
             % Arquivo para escrita dos valores de número de
             % condicionamento para as matrizes particionadoras. Esse
             % arquivo será escrito dentro dessa função. Arquivo conterá 
             % os valores de número de concidionamento da 
             % matriz particionadora, na primeira coluna,
             % enquanto que na segunda coluna haverá a iteração que foi 
	     % alcançado aquele condicionamento, e na terceira coluna um 
	     % valor inteiro que determinará em que passo o resultado foi 
	     % foi alcançado: 0- na busca; 1 - primeira busca; 2 -  link
	     % 3 - segunda busca. 

arqEstCondAlt = fopen('aarEstCondAlt','a');
fprintf(arqEstCondAlt, '%s\n', 'Condicionamento');
fclose(arqEstCondAlt);
             % arquivo para escrita dos valores de número de
             % condicionamento para as matrizes aproximadoras. Esse arquvo
             % será escrito dentro dessa função. Arquivo apenas para a es
             % crita do condicionamento das matrizes aproximadoras. 
             
aarqMelResiMMQGra = fopen('aarqMelResiMMQGra','a');
fclose(aarqMelResiMMQGra);  
             % Melhora da métrica resíduo por mínimos quadrados dentro do 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'.
             
aarqMelResiZGra = fopen('aarqMelResiZGra','a');
fclose(aarqMelResiZGra);
             % Melhora da métrica resíduo pelo método 'z' do matlab do 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'.
             
aarqMelResiART1Gra = fopen('aarqMelResiART1Gra','a');
fclose(aarqMelResiART1Gra);
             % Melhora da métrica resíduo pelo método 'ART1' 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'.
             
aarqMelResiARTGra =  fopen('aarqMelResiARTGra','a');
fclose(aarqMelResiARTGra); 
             % Melhora da métrica resíduo pelo método 'ART' do 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'.
             
aarqMelDifMMQGra = fopen('aarqMelDifMMQGra','a');            
fclose(aarqMelDifMMQGra);
             % Melhora da métrica diferença pelo método 'MMQ' do 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'. 
             
aarqMelDifZGra = fopen('aarqMelDifZGra','a');             
fclose(aarqMelDifZGra);
             % Melhora da métrica diferença pelo método 'Z' do 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'.   
             
aarqMelDifART1Gra = fopen('aarqMelDifART1Gra','a');
fclose(aarqMelDifART1Gra);
             % Melhora da métrica diferença pelo método 'ART1' do 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'.  
             
aarqMelDifARTGra = fopen('aarqMelDifARTGra','a'); 
fclose(aarqMelDifARTGra);
             % Melhora da métrica diferença pelo método 'ART' do 
             % método do GRASP. Esse arquivo será escrito pelo método
             % 'divMetGrasp'. 
             
aarqImproGra = fopen('aarqMelImproGra', 'a');
fclose(aarqImproGra);
             % arquivo para a escrita das melhroras do GRASP.  
             
percPart = fopen('aarqPerce','a');
fclose(percPart);
             % arquivo para a escrita dos percentuais por meio dos dados
             % particionados e a métrica associada. Esse arquivo está
             % escrito dentrio da função 'escPerce'.
             
percPartLSQ = fopen('aarqPerceLSQLin','a');
fclose(percPartLSQ);
             % arquivo para escrita dos percentuais por meio dos dados 
             % particionados e a métrica associada. Esse arquivo está
             % escrito dentro da função 'escPerce'. Esse método leva em
             % conta o método dos mínimos quadrados do matlab.
             
percePartLSQNoNeg = fopen('aarqPerceLSQNonneg','a');
fclose(percePartLSQNoNeg);
             % arquivo para escrita dos percentuais por meio dos dados
             % particionados e a métrica associada no mesmo arquivo. Esse
             % arquivo será escrito dentro da função 'escPerce'. Esse
             % método leva em conta o método dos mínimos quadrados do
             % matlab. 
             
 perceAprPart2 = fopen('aarqPerceAprPart2','a');
 fclose(perceAprPart2);
             % Arquivo para a escrita dos percentuais por meio dos dados 
             % aproximados e a métrica associada no mesmo arquivo.Esse
             % arquivo será escrito dentro da função 'escPerce'. Esse
             % método leva em conta o método dos mínimos quadrados usual. 
             
 perceAprLSQLin2 = fopen('aarqPerceLSQLin2','a');
 fclose(perceAprLSQLin2);
             % arquivo para a escrita dos percentuais por meio dos dados 
             % aproximados e a métrica associada no mesmo arquivo. 
             % será escrito dentro da função 'escPerce'. Esse método leva
             % em conta o método dos mínimos quadrados do matlab. 
        
perceAprLSQNoNeg = fopen('aarqPerceLSQNonneg2','a');
fclose(perceAprLSQNoNeg);
            % arquivo para a escrita dos percentuais por meio dos dados 
            % aproximados e a métrica associada no mesmo arquivo. 
            % será escrito dentro da função 'escPerce'. Esse método leva
            % em conta o método dos mínimos quadrados do matlab que não 
            % incluíra valores negativos. 
            
percePartARTICC = fopen('aarqSubArtICC','a');
fclose(percePartARTICC);
            % arquivo para a escrita dos percentuas por meio do 
            % particionamento dos dados, e a métrica associada, no mesmo
            % arquivo. Esse método levará em conta o particionamento dos
            % dados, a estimatica pelo ART, e o método encontrado na
            % internet COM a coluna que determina que a soma das frações
            % percentuais seja 1. Esse arquivo será escritp na função
            % 'escPerce'.
            
percePartARTISC = fopen('aarqSubArtISC','a');
fclose(percePartARTISC);
            % arquivo para a escrita dos percentuas por meio do 
            % particionamento dos dados, e a métrica associada, no mesmo
            % arquivo. Esse método levará em conta o particionamento dos
            % dados, a estimatica pelo ART, e o método encontrado na
            % internet SEM a coluna que determina que a soma das frações
            % percentuais seja 1. Esse arquivo será escritp na função
            % 'escPerce'. 
            
perceAprARTICC = fopen('aarqAproxaArtICC','a');
fclose(perceAprARTICC);
            % arquivo para a escrita dos percentuas por meio da
            % aproximação dos dados, e a métrica associada, no mesmo
            % arquivo. Esse método levará em conta o particionamento dos
            % dados, a estimatica pelo ART, e o método encontrado na
            % internet COM a coluna que determina que a soma das frações
            % percentuais seja 1. Esse arquivo será escritp na função
            % 'escPerce'. 
            
perceAprARTISC = fopen('aarqAproxaArtISC','a');
fclose(perceAprARTISC );
            % arquivo para a escrita dos percentuas por meio da
            % aproximação dos dados, e a métrica associada, no mesmo
            % arquivo. Esse método levará em conta o particionamento dos
            % dados, a estimatica pelo ART, e o método encontrado na
            % internet SEM a coluna que determina que a soma das frações
            % percentuais seja 1. Esse arquivo será escritp na função
            % 'escPerce'.
            
arqAltLink = fopen('aaArqAltLink','a');
fclose(arqAltLink);
            % Arquivo para sere escrito as variaçãoes de altura do composto
            % suprimido nas diferentes partições. Ess variação se dará
            % segundo um passo definido na na função 'linkAlt'. A escrita
            % do arquivo está definida na função 'linkAlt'. Dados: coluna
	    % 1: altura start; coluna 2: altura alvo; h: altura corrente, 
	    % modificada; metStart: métrica da solução start; metTarget: 
            % métrica da solução target; metDat: metrica da solução corrente. 
	    % a métrica precisa ser colocada como uma diferença, pois está 
	    % tudo dando zero. 

minRes = +inf(1,4);  
minDif = +inf(1,4);

%% Início do GRASP

% A partir do próximo laço, todo o processo iterativo terá início. Esse
% processo durará até que um valor mínimo seja encontrado ou até que o
% número máximo de iterações seja atingido. 

while metMin(1,1) > 0 && t <= numIter
    t %variável de verificação da iteração atual. É impressa na tela. 
    igua = false;
    while (igua == false && j<= tamLista)
        %%% Início do process construtivo. No início do processo
        %%% construtivo , duas estruturas são retornadas: 'x' e 'x1', onde
        %%% 'x' leva em conta a estimativa do desconhecido pela
        %%% geometrização do problema, e 'x1' leva em conta a estimativa do
        %%% desconhecido pelos valores de máximo e mínimo da contagem
        %%% espectral total. Os arquivos salvarão alguns dados importantes.
        %%% A métrica irá comparar os valores de áreas trazidos pelos
        %%% resultados dos minimos quadrados, com o valor de área abaixo da
        %%% curva do espectro total. O método 'quite' ira introduzir o
        %%% elemento na lista com uma quantidade mínima de diferenças em
        %%% relação aos elementos presentes de 10%. 
        
        [resul, somAprox, matPerc] = build ( ref, retor, comp,...
            [1/0.2 1/0.5 1/0.2 1/0.1], ...
            newTot, canais,10,col, estPe ); 
        [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
            resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
            somPartArtIsc] = impress(matPerc, somAprox, resul, ...
            'aarqMelImproGra'); 
        valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
        valDif = [(apxPart - toPart)  somPartZ somPartArtIcc ...
            somPartArtIsc];
        [minRes, minDif] = divMetGrasp(matPerc, valApx, ...
                       valDif, condMatApx, minRes, minDif);
        fprintf('construiu_GRASP \n')
                                    % constroi-se uma determinada solução.
        
        cd ..;                           
        cd C_GRASP/; % mudança para a pasta onde o CGrasp esta armazenado. 
        
        fun = somAprox{1,1}.somTot + somAprox{2,1}.somTot + ...
            somAprox{3,1}.somTot + somAprox{2,1}.somTot;       
                                       % soma das áreas nas 4 partições de 
                                       %referencia. A métrica usada será a
                                       %diferença obtida ao longo da
                                       %heurística com a soma abaixo da
                                       %curva do espectro nas 4 partições. 
        
        [x, minRes, minDif] = CGrasp(matPerc,somAprox ,resul, 1, fun, ...
            resul, resul, 3, 2, 2, 1, 0.5, col, minRes, minDif);
        fprintf('terminou_CGRASP \n')
                                                           
                                                            
        cd ..                                               
                                                            
        
        cd GRASP/;                                          
                                                           
        arqBuild = fopen('aarqBuil','a');
        impressao(arqBuild,[x{1,1}{1,1}.starWide x{1,1}{1,1}.endWide ...
            x{1,1}{1,1}.intPart...
            x{1,1}{1,1}.heighRet x{1,1}{1,1}.half x{1,1}{1,1}.maxPart...
            x{1,1}{1,1}.minPart x{1,1}{1,1}.height x{1,1}{1,1}.pos...
            x{1,1}{1,1}.compMeta]);
        [x{1,1}{1,1}(:).ch] = searCha(x{1,1}{1,1}.starWide, ...
            x{1,1}{1,1}.endWide,...
        x{1,1}{1,1}.compostos)';
        fclose(arqBuild);
        [metX,resul] = metrica(x);
        newMini = escPerce(x,metMin,resul);
        metMin = newMini;
        igua = quite(lista, x, 0.1);
        if metX <= metMin(1,1)
            saida = x;
            fprintf('ok \n');
            arqEstCond = fopen('aarEstCond','a');
            impressao(arqEstCond, [cond(saida{1,1}{4,1}.matSomComp) t 0]);
            fclose(arqEstCond);
            arqEstCondAlt = fopen('aarEstCondAlt','a');
            impressao(arqEstCondAlt, cond(saida{1,1}{4,1}.matSomAprox));
            fclose(arqEstCondAlt);
            fprintf('inseriu_lista_GRASP \n')
        end
        if igua == false && j <= tamLista
            lista{j,1} = x;
            j = j + 1;
            if metX > metMaxi
                metMaxi = metX;
            end
        else
            if j <= tamLista && igua == true
                igua = false;
            else 
                igua = true;
            end
        end
    end
    fprintf('preencheu_lista_GRASP \n')
    arqBuild = fopen('aarqBuil','a');
    impressao(arqBuild,[1 1 1.0000001*10^-5 ...
        1.0000001*10^-5 1.0000001*10^-5 1.0000001*10^-5 1.0000001*10^-5 ...
        1.0000001*10^-5 1 1.0000001*10^-5]); 
    fclose(arqBuild);
    
    %%
    %%% Início da busca. Após preencher todas as posições da lista do algo
    %%% ritmo, a busca é então iniciada. O início da busca, passa-se como
    %%% parâmetro o ultimo elemento construído 'x', o valor do tamanho da
    %%% lista da busca, os canais de cada partição e o número máximo de
    %%% iterações. 
    
    [y, minRes, minDif] = search( x, 10, canais, 100, ref, col, minRes, ...
        minDif);
    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, resApxArtIcc,...
       resApxArtIsc,  somPartZ, somPartArtIcc, somPartArtIsc] = ...
       impress(y{4,1}, y{3,1}, y{1,1}, 'aarqMelImproGra'); 
    valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
    valDif = [(apxPart - toPart)  somPartZ somPartArtIcc somPartArtIsc];
    [minRes, minDif] = divMetGrasp(matPerc, valApx, valDif, condMatApx, ...
        minRes, minDif); 
    fprintf('terminou_busca_GRASP \n')
    cd ..;                              
    cd C_GRASP/
    [y, minRes, minDif] = CGrasp(y{4,1}, y{3,1}, y{1,1},1, ...
        y{3,1}{1,1}.somTot, y{1,1}, y{1,1}, 3, 2, 2, 1, 0.5, col, minRes, ...
        minDif);
    fprintf('terminou_CGRASP_busca_1 \n');
    cd ..;
    cd GRASP/;
    arqSear1 = fopen('aarqSear1','a');
    impressao(arqSear1,[y{1,1}{1,1}.starWide y{1,1}{1,1}.endWide ...
            y{1,1}{1,1}.intPart...
            y{1,1}{1,1}.heighRet y{1,1}{1,1}.half y{1,1}{1,1}.maxPart...
            y{1,1}{1,1}.minPart y{1,1}{1,1}.height y{1,1}{1,1}.pos...
            y{1,1}{1,1}.compMeta]);
    fclose(arqSear1);    
    fprintf('buscou \n')
    [metY,resulSe1] = metrica(y);
    newMiniSe1 = escPerce(y,metMin,resulSe1);
    metMin = newMiniSe1;
    if metY <= metMin(1,1)
        saida = y;
        lista = insercao(lista,y);
        fprintf('inseriu_na_lista_após_busca \n');
        arqEstCond = fopen('aarEstCond','a');
        impressao(arqEstCond, [cond(saida{1,1}{4,1}.matSomComp) t 1]);
        fclose(arqEstCond);
        arqEstCondAlt = fopen('aarEstCondAlt','a');
        impressao(arqEstCondAlt, cond(saida{1,1}{4,1}.matSomAprox));
        fclose(arqEstCondAlt);
    end
    if metY < metMaxi
        lista = insercao(lista,y);
        fprintf('substituiu_de_maior_condicionamento \n');
        metMaxi = metMax(lista);
    end
    posi = randi([1 tamLista],1,1);
    escolha = lista{posi,1};
    fprintf('iniciou_linkagem_GRASP \n'); 
    k = linkagem(y, escolha, canais,10,20, ref, col, minRes, minDif, estPe);
    
    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, resApxArtIcc,...
       resApxArtIsc,  somPartZ, somPartArtIcc, somPartArtIsc] = ...
       impress(k{4,1}, k{3,1}, k{1,1}, 'aarqMelImproGra'); 
    valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
    valDif = [(apxPart - toPart)  somPartZ somPartArtIcc somPartArtIsc];
    [minRes, minDif] = divMetGrasp(matPerc, valApx, valDif, condMatApx, ...
        minRes, minDif);
    
    fprintf('terminou_linkagem_GRASP \n');
    cd ..;                              
    cd C_GRASP/
    fprintf('iniciou_linkagem_CGRASP \n')
    [k, minRes, minDif] = CGrasp(k{4,1}, k{3,1}, k{1,1}, 1, ...
        k{3,1}{1,1}.somTot, k, k, 3, 2, 2, 1, 0.5, col, minRes, minDif);
    fprintf('terminou_CGRASP_linkagem\n');
    cd ..;
    cd GRASP/;
    arqLink = fopen('aarqLink','a');
    impressao(arqLink,[k{1,1}{1,1}.starWide k{1,1}{1,1}.endWide ...
            k{1,1}{1,1}.intPart...
            k{1,1}{1,1}.heighRet k{1,1}{1,1}.half k{1,1}{1,1}.maxPart...
            k{1,1}{1,1}.minPart k{1,1}{1,1}.height k{1,1}{1,1}.pos...
            k{1,1}{1,1}.compMeta]);
    fclose(arqLink);
    fprintf('linkou \n')
    [metK,resulLin] = metrica(k);
    newMiniLi = escPerce(k,metMin,resulLin);
    metMin = newMiniLi;
    if metK <= metMin(1,1)
        saida = k;
        lista = insercao(lista,k);
        fprintf('achou \n');
        arqEstCond = fopen('aarEstCond','a');
        impressao(arqEstCond, [cond(saida{1,1}{4,1}.matSomComp) t 2]);
        fclose(arqEstCond);
        arqEstCondAlt = fopen('aarEstCondAlt','a');
        impressao(arqEstCondAlt, cond(saida{1,1}{4,1}.matSomAprox));
        fclose(arqEstCondAlt);
    end
    if metK < metMaxi
        lista = insercao(lista,k);
        metMaxi = metMax(lista);
    end
    %%% Inicio da linkagem. Após a primeira busca, a linkgem se inicia. 
    %%% Mas, antes do inicio da mesma, é feita uma seleção do elemento da
    %%% lista do GRASP que será linkado com a solução da primeira busca. A
    %%% linkagem é dividida em duas partes: A primeira parte irá linkar os
    %%% valores de altura da solução 'start' em direção ao valores de
    %%% altura da solução 'target'. Na segunda parte, ocorrerá a linkagem
    %%% dos canais presentes ou ausentes na solução 'start' em direção aos
    %%% canais presentes ou ausentes na solução 'target'. 
    fprintf('iniciou_GRASP_busca_2 \n');    
    z = search(k, 10, canais, 100, ref, col, minRes, minDif);
    
    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, resApxArtIcc,...
       resApxArtIsc,  somPartZ, somPartArtIcc, somPartArtIsc] = ...
       impress(z{4,1}, z{3,1}, z{1,1}, 'aarqMelImproGra'); 
    valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
    valDif = [(apxPart - toPart)  somPartZ somPartArtIcc somPartArtIsc];
    [minRes, minDif] = divMetGrasp(matPerc, valApx, valDif, condMatApx, ...
        minRes, minDif);
    
    fprintf('terminou_GRASP_busca_2 \n');
    cd ..;                              
    cd C_GRASP/
    fprintf('iniciou_CGRASP_busca_2 \n');
    z = CGrasp(z{4,1}, z{3,1}, z{1,1}, 1, z{3,1}{1,1}.somTot, z, z, 3, 2,...
        2, 1, 0.5, col, minRes, minDif);
    fprintf('terminou_CGRASP_busca_2 \n')
    cd ..;
    cd GRASP/;
    arqSear2 = fopen('aarqSear2','a');
    impressao(arqSear2,[z{1,1}{1,1}.starWide z{1,1}{1,1}.endWide ...
            z{1,1}{1,1}.intPart...
            z{1,1}{1,1}.heighRet z{1,1}{1,1}.half z{1,1}{1,1}.maxPart...
            z{1,1}{1,1}.minPart z{1,1}{1,1}.height z{1,1}{1,1}.pos...
            z{1,1}{1,1}.compMeta]);
    fclose(arqSear2);
    fprintf('buscou_de_novo \n')
    [metZ,resulSe2] = metrica(z);
    newMiniSe2 = escPerce(z,metMin,resulSe2);
    metMin = newMiniSe2;
    if metZ <= metMin(1,1)
        saida = z;
        lista = insercao(lista,z);
        fprintf('achou \n');
        arqEstCond = fopen('aarEstCond','a');
        impressao(arqEstCond, [cond(saida{1,1}{4,1}.matSomComp) t 3]);
        fclose(arqEstCond);
        arqEstCondAlt = fopen('aarEstCondAlt','a');
        impressao(arqEstCondAlt, cond(saida{1,1}{4,1}.matSomAprox));
        fclose(arqEstCondAlt);
    end
    if metZ < metMaxi
        lista = insercao(lista,z);
        metMaxi = metMax(lista);
        
    end
    strSta = num2str(t);
    conca = strcat('iter_grasp_', strSta, '\n');
    fprintf(conca );
    t = t + 1;
end
end

