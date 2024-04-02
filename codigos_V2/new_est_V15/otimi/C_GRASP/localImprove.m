function [ output, sevMet, minimo] = localImprove(x, fun, n, h, l, u, ...
    maxDirTry, numPart, col, sevMet)
%LOCALIMPROVE função para buscar melhoras nas construções
%   Função para buscar por soluções melhores que as soluções construídas.


% número de partições 
qtdPart = size(x{1,1});             

% arquivo para trabalhar com as saídas da busca local.
arqInterImpro = fopen('aarqImpro','a');
fclose(arqInterImpro);   

% valor que irá dividir a distâncias das alturas para buscas melhor soluc.
numMin = 20 / h;

% variável que indicará a existência de melhoras na busca.
improve = true;

% saída que receberá o parâmetro de entrada como valor inicial. 
output = x;

% valor inicial da métrica
minimo = abs(fun);        

% número máximo de direções em torno das quais realizar a pesquisa por melh
numDirToTry = min(3^(n)-1, maxDirTry);

% cópia do parâmetro de entrada que será modificada no algoritmo. 
y = x;

% função que determina todas as direções de pesquisa.
a1 = dire(n);

% tamanho das direções
tamVer = size(a1);

a = zeros(1,tamVer(1,2));      

% a descrição das direções possui um valor nulo. O laço ira cancelar o val.
pont = 1;
for t = 1 : tamVer(1,1)                
    if any(a1(t,:)) ~= 0       
        a(pont,:) = a1(t,:);
        pont = pont + 1;
    end
end

% definição do flag
flag = 10;

% constroi as direçes possveis, constroi as indexaçes. 
tamDirAj = size(a);
PontDir = 1;
indDir = [];
for s = 1 : qtdPart(1,1)
    for p = 1 : tamDirAj(1,1)
       indDir(PontDir,1) = PontDir;
       action{PontDir,1} = [s a(p,1)];
       PontDir = PontDir + 1;
    end
end

% número de direções a serem pesquisadas será armazenada no vetor D
tamIndDir = size(indDir);
D = zeros(tamIndDir(1,1), 1);     

% variável que servirá para indicar quantas direções foram pesquisadas. 
countD = 0;                   

% ponteiro para indicar saída de laço.
saida = false;

while improve 
    
    % variável que será true enquanto houver melhoras. 
    improve = false;
    
    % se o número de direções for menor que o número máximo e enquanto não
    % houver melhoras. 
    while (countD <= numDirToTry && ~improve) && (~saida)
             
        % variável que verificará o fim do laço da busca
        stop2 = false; 
        
        % ponteiro que indica o número de partições pesquisadas.
        pont2 = 0;
        
       % condiço para se continuar a busca.
        
        stop = false;
        % laço para escolher uma direção 
        while stop == false
            
            % sorteio de um número que indexa as direções.
            index = randi([1  tamIndDir(1,1)],1,1); 
            
            % se valor não estiver contido no vetor de direções ja 
            % pesquisadas.
            if  (D(index,1)==0)       

                % o laço para
                stop = true;
               
                % a direção é inserida no vetor 
                D(index,1) = index;             
               
                % a variável é incrementada após a adição de uma direção 
                countD = countD + 1;            
               
            end 
            
            strSta = num2str(index);
            conca = strcat('direcao_busca_CGRASP_', strSta, '\n');
            fprintf(conca);
        end
         
        parAtu = action{index,1}(1,1);
        dirAtu = action{index,1}(1,2);
        if dirAtu == -1
            passo =  (x{1,1}{parAtu,1}.heighRet - ...
                    l{1,1}{parAtu,1}.minPart) / (numMin); 
        end
        if dirAtu == 1
            passo =  (u{1,1}{parAtu,1}.maxPart- ...
                    x{1,1}{parAtu,1}.heighRet) / (numMin);
        end
        
        minPer =  l{1,1}{parAtu,1}.minPart; 
        maxPer = u{1,1}{parAtu,1}.maxPart;
        while stop2 == false  
                        
            % modificaçao da altura da solucao
            b = adic(y{1,1}{parAtu,1}.heighRet, ...
                passo, dirAtu); 
                    
            % modifica-se a altura da solucao
            [y{1,1}{parAtu,1}(:).heighRet] = b; 
                    
            % usado para indicar que a nova altura esta abaixo da
            % anterior.
            [y{1,1}{parAtu,1}(:).posVarAlt] = 0; 
            % reparametrizando a partição 
            [y{1,1}{parAtu,1}(:).compMeta] = ...
                (y{1,1}{parAtu,1}.half) / b;
            % remodificando parâmetro da partição
            if b > y{1,1}{1,1}.half
                y{1,1}{parAtu,1}.pos = 1;
            end
            
            %recalcula a partição. 
            [partTemp, somAproxTemp, matPercTemp]...
                        = data(y{1,1}, y{1,1}{1,1}.perce, col);
                    
            % impressao dos valores 
            est = [{partTemp}; matPercTemp(:,3); {somAproxTemp}; ...
                        {matPercTemp}]; 
            [provMin, resul] = metrica(est);
            fidVeri = fopen('verifiLocImpr','a');
            impressao(fidVeri, [partTemp{3,1}.matSomAprox(2,:) provMin ...
                matPercTemp(:,4)']);
            fclose(fidVeri);
                                  
            % estrutura de dados.
             
               
             % impresso dos percentuais e das métricas.
            [apxPart, toPart, pontNeg, condMatApx, resApxMMQ,...
                resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                somPartArtIcc, somPartArtIsc] = ...
                impress(matPercTemp, somAproxTemp,...
                partTemp, 'aarqImpro');        
             
             % se a métrica atualizada for melhor que a metrica
             % corrente. 
             if provMin < minimo && pontNeg  == 1 
                 % variável de saida
                 output = est;       
                        
                 % novo valor de metrica corrente                         
                 minimo = provMin;
                        
                 % nova variavel de melhorias modifcada para true
                 improve = true;
                        
                 % a direção escolhida para melhorias pode novamente
                 % ser pesquisada.
                 D = 0;
                        
                 % a partiço onde foi encontrada a melhora pode
                 % novamente ser pesquisada. 
             end
                    
             % impressao da iteração
                                
             cd ..;
             cd GRASP;
             sevMet = escPerce(est, sevMet, resul, flag);
             cd ..;
             cd C_GRASP;
             
             valVeri = y{1,1}{parAtu,1}(:).heighRet;
             
             if valVeri > maxPer || valVeri < minPer
                stop2 = true;
             end
             
            % direçao escolhida para a pesquisa. 
            strDir = num2str(index);
            
            %particao escolhida
            strPartEsc = num2str(parAtu);
            
            % valor do passo 
            strPass = num2str(passo);
            
            % valor da altura
            strAlt = num2str(b);
            
            % valor da métrica
            strMet = num2str(minimo);
            
            % valor da metrica corrente. 
            strCorr = num2str(fun);
            
            % concatenação das strings
            strImpri = strcat('**search_CGRASP_DIR', strDir,'_part_', ...
                strPartEsc,'_passo_',strPass,'_altura _',strAlt,'_metrica_'...
            , strMet,'_metrica_corrente_', strCorr,'_fim_iteracao',...
            '...**\n');
            fprintf(strImpri);
            pause(1);
        end 
        
    end
    if countD == numDirToTry
        saida = true;
    end
end
end
