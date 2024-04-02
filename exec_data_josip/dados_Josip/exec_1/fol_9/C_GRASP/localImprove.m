function [ resul, minRes, minDif ] = localImprove(x, fun, n, h, l, u, ...
    maxDirTry, numPart, col, minRes, minDif)
%LOCALIMPROVE função para buscar melhoras nas construções
%   Função para buscar por soluções melhores que as soluções construídas.

%% função para buscar por melhoras na função construída. 
% Variáveis iniciais.

minimo = + inf;          % variável que verificará o valor da diferença 
                         % entre as áreas pela aproximação dos compostos e
                         % e a área abaixo do espectro total. 

arqInterImpro = fopen('aarqImpro','a');
fclose(arqInterImpro);   % arquivo para trabalhar exclusivamente com as 
                         % saídas do código de busca local. 


numMin = 20 / h;
improve = true; 
resul = x;
funIni = abs(fun);              % Valor inicial da função. 
numDirToTry = min(3^(n)-1, maxDirTry);
y = x;
a1 = dire(n);                   % determina todas direções
tamVer = size(a1);
a = zeros(1,tamVer(1,2));      % Declaração da variável que receberá as 
                               % direções, excetuando a direção (0,...,0). 
pont = 1;
for t = 1 : tamVer(1,1)        % Laço sobre a matriz para encontrar a linha         
    if any(a1(t,:)) ~= 0       % nula e cancelá-la.     
        a(pont,:) = a1(t,:);
        pont = pont + 1;
    end
end
                               
D = zeros(numDirToTry, 1);     % O tamanho do vetor determinado no passo 
                               % anterior servirá para construir o vetor
                               % que receberá os sorteios de direções.
                               
countD = 0;                    % Variável que servirá para indicar quantas 
                               % direções já foram inseridas.
                               
                             
qtdPart = size(y{1,1});             % determinar quantas partições existem.


%% Início do laço.
saida = false;                      % variável para indicar saida do laço.
counti = 1;
while improve 
    improve = false;
    while (countD <= numDirToTry && ~improve) && (~saida)
        %% Escolha da direção. Escolha aleatória
        % nesse ponto escolhe-se a direção a partir da qual a busca irá se
        % iniciar.
            
        stop = false;
        while stop == false
            index = randi([1  (3^(n)-1)],1,1); % Sorteio de numero aleatorio
                                               % que indexa as direções.  
            
            if  (any(D == index)) == 0         % Se a direção de busca já 
                                               % tiver sido realizada, nova
                                               % busca.
                
               stop = true;                    
               D(index,1) = index;             % O que contiver valor nulo 
                                               % no vetor 'D' é porque é
                                               % uma posição não preenchida
               
               countD = countD + 1;            % Variável que é incrementa
                                               % da após a adição de uma 
                                               % direção.
                                               
            end 
            strSta = num2str(index);
            conca = strcat('direcao_busca_CGRASP_', strSta, '\n');
            fprintf(conca);
        end                                       
               
        %% Escolhida a direção, faz-se a pesquisa ao longo de parti.
        
        % Escolhida a partiçao no passo anterior, para essa direçao,
        % a pesquisa será feita ao longo de todas ou algumas 
        % partição. Escolhida a partição, ela precisa ser
        % reparametrizada. 
               
        stop2 = false; 
        pont2 = 0;
        particoes = zeros(qtdPart(1,1),1);
        while stop2 == false                          
            partEsc = randi([1 qtdPart(1,1)],1,1); % sorteio da partição 
                                                   % escolhida.
            if any(particoes == partEsc) == 0         
                particoes(partEsc,1) = partEsc; % escolha da partição.
                
                pont2 = pont2 + 1;              % ponteiro que indica até 
                                                % quando deve ocorrer o
                                                % sorteio das partições
                                    
                if a(index,1) == -1 % inteiro que indica a partir de onde 
                                    % deve iniciar a busca. 
                    passo =  (y{1,1}{partEsc,1}.heighRet - ...
                        l{1,1}{partEsc,1}.minPart) / (numMin); % passo da 
                                                               % da busca.
                    b = adic(y{1,1}{partEsc,1}.heighRet, ...
                        passo, a(index,1)); % calcula-se a a altura da 
                                            % solução
                    [y{1,1}{partEsc,1}(:).heighRet] = b; % modifica-se a 
                                                         % a altura da
                                                         % solução.
                                                         
                    [y{1,1}{partEsc,1}(:).posVarAlt] = 0; % parâmetro que 
                                                          % indica se a
                                                          % nova solução
                                                          % está acima ou
                                                          % abaixo da
                                                          % solução
                                                          % anterior
                    [y{1,1}{partEsc,1}(:).compMeta] = ...
                        (y{1,1}{partEsc,1}.half) / b; %reparametrização da
                                                      % variável que terá a
                                                      % altura modificada.
                else 
                    passo =  (u{1,1}{partEsc,1}.maxPart- ...
                    y{1,1}{partEsc,1}.heighRet) / (numMin);
                    b = adic(y{1,1}{partEsc,1}.heighRet, ...
                        passo, a(index,1));
                    [y{1,1}{partEsc,1}(:).heighRet] = b;
                    [y{1,1}{partEsc,1}(:).posVarAlt] = 1;
                    [y{1,1}{partEsc,1}(:).compMeta] = ...
                        (y{1,1}{partEsc,1}.half) / b;  % mesmos passos 
                                                       % descritos
                                                       % anteriormente, mas
                                                       % só que para o caso
                                                       % de se ter
                                                       % modificações de
                                                       % altura para cima.
                end
                
                if b > y{1,1}{1,1}.half
                    y{1,1}{partEsc,1}.pos = 1;
                else
                    y{1,1}{partEsc,1}.pos = 0;
                end   % veirifica-se se a nova altura está acima ou abaixo 
                      % valor de altura atual. 
                
                if  l{1,1}{partEsc,1}.minPart <= b &&...
                 b <= u{1,1}{partEsc,1}.maxPart
                   [partTemp, somAproxTemp, matPercTemp]...
                        = data(y{1,1}, y{1,1}{1,1}.perce, col);
                                                           % nova estrutura 
                                                           % de dados com 
                                                           % as informaçõs 
                                                           % de altura
                                                           % modificadas. 
                    est = [{partTemp}; matPercTemp(:,3); {somAproxTemp}; ...
                        {matPercTemp}]; 
                    [apxPart, toPart, pontNeg, condMatApx, resApxMMQ,...
                        resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                        somPartArtIcc, somPartArtIsc] = ...
                            impress(matPercTemp, somAproxTemp,...
                            partTemp, 'aarqImpro');
                    dif = abs(apxPart - toPart);
                    if abs(dif) < abs(funIni) && pontNeg  == 1                      
                        resul = est;                       
                        funIni = dif;
                        improve = true;
                        D = 0;
                        particoes = 0;
                    end
                    valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
                    valDif = [(apxPart - toPart)  somPartZ somPartArtIcc...
                        somPartArtIsc];
                    
                   [minRes, minDif] = divMetCgrasp(matPercTemp, valApx, ...
                       valDif, condMatApx, minRes, minDif);
                end
                if pont2 >= numPart
                    stop2 = true;
                end
            end
            strSta1 = num2str(partEsc);
            strSta2 = num2str(a(index,1)); strSta3 = num2str(counti);           
            conca = strcat('iter_', strSta3, '_busca_CGRASP_part_', strSta1,'_dir_',strSta2, '\n');
            fprintf(conca );
            counti = counti + 1;
        end
        if countD == numDirToTry
            saida = true;
        end
    end
end
end

