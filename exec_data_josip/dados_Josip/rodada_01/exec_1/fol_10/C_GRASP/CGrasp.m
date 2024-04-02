function [ best, minRes, minDif ] = CGrasp(matPerc ,somAprox, x, dimen,...
    fun ,min, max, maxIters, maxNumIterNoImprov, numTimesToRun, ...
    maxDirToTry, alpha,col, minRes, minDif)
% C_GRASP para busca em regiões contínas.
%   Parâmetros de entrada são:'dimen', parâmetro que determina a
%   dimensionalidade do problema; 'fun', função que determina o valor da
%   métrica a ser determinada durane o algoritmo; 'min', 'max' tal que
%   qualquer solução 'x' do problema atenda à seguinte restrição:
%   'min<=x<=max'. Nesse caso, os valores de mínimo e máximo do problema 
%   são os valores de altura advindos da definição de uma partição; 
%  'maxIters', o número de vezes que a construção e a busca
%   local serão executadas; 'maxNumIterNoImprov' determina o número máximo
%   de execuções sem que necessariamente haja uma melhora na métrica
%   considerada para um grid arbitrario 
%  'numTimesToRun', número de vezes em que o algoritmo será C_GRASP
%   executado;'maxDirToTry' número máximo de direções em que o algoritmo
%   deve encontrar alguma melhora, valor arbitrário determinado pelo
%   usuário, quando esse número de direções for muito grande
% ;'alpha', valor que determinará a aleatoriedade na construção da
%   solução. Será necessário inicializar o valor da função pela métrica que 
%   está sendo usada ao longo da função; 'x': Solução inicial. 

%% Setando o valor funcional de busca 
% seta-se o valor funcional inicial como infinito:

minimo = + inf;

                                            % variável para indicar o 
                                            % quanto a diferença entre a
                                            % área advinda da heurística e 
                                            % área abaixo do espectro
                                            % estã o próximos. 
                                            
 xTemp = {x; matPerc(:,1); somAprox; matPerc};  % Formatação da variável. 


best = xTemp;                                   
                                            % para o caso de não encontrar 
                                            % nenhuma solução melhor que a
                                            % corrente.


val = somAprox{1,1}.somAprPart2 + somAprox{2,1}.somAprPart2+...  
        somAprox{3,1}.somAprPart2 + somAprox{4,1}.somAprPart2; 
                                                            % métrica
                                                            % da solução
                                                            % inicial.

arqCgrasp = fopen('aarBestCGrasp','a');
fclose(arqCgrasp);  
                                        % arquivo para verificar as melho-
                                        % ras do algoritmo CGrasp. Essas 
                                        % melhoras são verificadas em nivel
                                        % das da soma das áreas dos
                                        % compostos após aproximação do
                                        % composto suprimido.

arqMatCgrasp = fopen('aarMatBestCgrasp','a'); 
fclose(arqMatCgrasp);     
                                              % Matriz para imprimir os v  
                                              % valores positivos de saída 
                                              % do GRASP para os 
                                              % percentuais no processo
                                              % do algoritmo como um todo. 

arqConstCGrasp  = fopen('aarqConsCgrasp','a');
fclose(arqConstCGrasp);                                  
                                                          % arquivo para  
                                                          % verificar as 
                                                          % melhoras no 
                                                          % processo cons-
                                                          % trutivo.
                                                          
arqMatCgrasp2 = fopen('aarMatConstCgrasp','a'); 
fclose(arqMatCgrasp2);                       
                                              % Matriz para imprimir os
                                              % valores positivos de saída 
                                              % do construtivo para os 
                                              % percentuais no processo
                                              % construtivo.
                                                          
arqImproCGrasp = fopen('aarqImproCgrasp','a');
fclose(arqImproCGrasp);                                   
                                                          % arquivo para 
                                                          % verificar as
                                                          % melhoras no
                                                          % processo de
                                                          % busca.
                                                          
                                                          
arqMatCgraspImp = fopen('aarMatImprCgrasp','a');  
fclose(arqMatCgraspImp);                      
                                              % Matriz para imprimir os  
                                              % valores positivos de saída 
                                              % da busca para os 
                                              % percentuais no processo
                                              % construtivo.
                                              
arqalt = fopen('aarqAltCGrasp','a');
fclose(arqalt);   
                                    % arquivo para escrever as 
                                    % saídas do altcGrasp. Arquivo será
                                    % escrito na função 'altCGrasp', e nele
                                    % conterá: os valores de diferença
                                    % (val3) entre a área trazida pelos 
                                    % mínimos quadrados (val2) e a área 
                                    % abaixo da curva espectral total 
                                    % (val1); Os valores de fração 
                                    % percentual (val4); um inteiro que 
                                    % indica se há algum valor percentual
                                    % negativo (val5); condicionamento da
                                    % matriz aproximada (val5); valor do
                                    % resíduo no método dos mínimos
                                    % quadrados (val7); resíduo no método
                                    % 'z' do matlab na aproximação pelos
                                    % mínimos quadrados (val8); 
                                    % resíduo da solução trazida pelo ART 
                                    % na aproximação das frações 
                                    % percentuais  usando a coluna 
                                    % indica que a soma das frações deve
                                    % ser 1 (val9); o ultimo valor leva em 
                                    % conta o método ART, mas sem a coluna
                                    % que indica a soma das frações
                                    % percentuais (val10).
                       
                                    

arqline = fopen('aarqLine','a');        
fclose(arqline);                        
                                   % arquivo de saída da LineSearch. Esse
                                   % arquivo será escrito pela função
                                   % impress e conterá os mesmo valores
                                   % escritos no arquivo 'aarqAltCGrasp'.
                                   
arqMelResiMMQ = fopen('aarqMelResiMMQ','a');                                   
fclose(arqMelResiMMQ);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica o resíduo. Esse
                                   % valor será tomado por base o valor do
                                   % MMQ. 
                                   
                                   

arqMelResiZ = fopen('aarqMelResiZ','a');                                   
fclose(arqMelResiZ);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica o resíduo. Esse
                                   % valor será tomado por base o valor do
                                   % método 'z' do matlab para os minimos 
                                   % quadrados.

arqMelResiART1 = fopen('aarqMelResiART1','a');                                   
fclose(arqMelResiART1);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica o resíduo. Esse
                                   % valor será tomado por base o valor do
                                   % ART, COM a coluna contendo os valores
                                   % 1. 
                                    

arqMelResiART = fopen('aarqMelResiART','a');                                   
fclose(arqMelResiART);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica o resíduo. Esse
                                   % valor será tomado por base o valor do
                                   % ART, SEM a coluna contendo os valores
                                   % 1.
                                   
                                   
arqMelDifMMQ = fopen('aarqMelDifMMQ','a');                                   
fclose(arqMelDifMMQ);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica a diferença. Esse
                                   % valor será tomado por base o valor do
                                   % MMQ. 
                                   
                                   

arqMelDifZ = fopen('aarqMelDifZ','a');                                   
fclose(arqMelDifZ);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica a diferença. Esse
                                   % valor será tomado por base o valor do
                                   % método 'z' do matlab para os minimos 
                                   % quadrados.

arqMelDifART1 = fopen('aarqMelDifART1','a');                                   
fclose(arqMelDifART1);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica a diferença. Esse
                                   % valor será tomado por base o valor do
                                   % ART, COM a coluna contendo os valores
                                   % 1. 
                                    

arqMelDifART = fopen('aarqMelDifART','a');                                   
fclose(arqMelDifART);
                                   % arquivo para gravar as melhoras
                                   % tomando como métrica a diferença. Esse
                                   % valor será tomado por base o valor do
                                   % ART, SEM a coluna contendo os valores
                                   % 1.
                                                          
%% Laço que determinará o número de vezes de execução do algoritmo

% Laço que determinará o número de vezes de execução do algoritmo
h = 1;
for i = 1 : numTimesToRun
    %% Variáveis iniciais
    % 'h': tamanho inicial do
    % grid;'numIterNoImprov': Número máximo de execuções sem nenhuma
    % melhora. A linha onde se escolhe aleatoriamente uma solução pode ser
    % uma solução já construída previamente. 
    
                                   
    numIterNoImprov = 0; 
    
    %% Laço que determinará a qtd de vezes de busca e construção
    
    for iter = 1 : maxIters
        %% Construção da solução
        % Função que determinará a construção de uma solução.
        
        [constru, minRes, minDif ]= construct(matPerc, somAprox, x, fun, ...
            dimen, h, x, x, alpha, col, minRes, minDif); 
                                                       % saida do processo
                                                       % construtivo. A
                                                       % saída não será
                                                       % impressa pela
                                                       % função
                                                       % 'divMetCgrasp'
                                                       % porque isso foi
                                                       % feito ao fim da
                                                       % função
                                                       % 'construct'.
        
        fprintf('construiu_Cgrasp \n');                % impressão na tela
                                                       % de comando para
                                                       % determinar quando
                                                       % termina processo
                                                       % construtivo
        matConst1 = constru{4,1}(:,4);
        val2 = isempty(find(constru{4,1}(:,4) < 0,1));
        val1 = constru{3,1}{1,1}.somAprPart2 + ...
            constru{3,1}{2,1}.somAprPart2+...
           constru{3,1}{3,1}.somAprPart2 + constru{3,1}{4,1}.somAprPart2;
        arqSaiConstru = fopen('aarqConsCgrasp','a');
        impressao(arqSaiConstru,[(matConst1)' val1 val val2]);
        fclose(arqSaiConstru);                             % métrica da so-                           
                                                           % lução advinda 
                                                           % do processo 
                                                           % construtivo. 
                                                           % Essa métrica
                                                           % será impressa.
                                                           % 'val' é a soma
                                                           % das áreas
                                                           % aproximadas de
                                                           % entrada do
                                                           % método, e
                                                           % 'val1' é a
                                                           % soma das áreas
                                                           % aproximadas
                                                           % após o
                                                           % processo de
                                                           % construção.
                                                           % 'val2'
                                                           % determina se
                                                           % há valores de
                                                           % percentuais
                                                           % negativos. 
                                                           %
       
        matConst1 = constru{4,1}(:,4); 
        condici2 = log(cond(constru{1,1}{4,1}.matSomAprox));
        if isempty(find(matConst1 < 0,1))                  
            arqSaiMatConstru = fopen('aarMatConstCgrasp','a');
            impressao(arqSaiMatConstru, [(matConst1)' condici2]);      
            fclose(arqSaiMatConstru);                      
        end                                                % matriz para im     
                                                           % primir os
                                                           % valores de
                                                           % pecentuais de
                                                           % compostos
                                                           % advindos do
                                                           % processo
                                                           % construitivo
                                                 
        %% Busca local por melhores soluções 
        
        % Função que irá buscar melhores soluções
        qtdPart = size(constru);
        [x2, minRes, minDif] = localImprove(constru, fun, dimen, h, ...
            constru, constru, maxDirToTry, qtdPart(1,1), col, minRes, ...
            minDif);
        fprintf('procurou_Cgrasp \n');
        
       
        %% Verificações das duas saídas
        % Trecho de código que irá verificar as duas saídas anteriores e
        % atribuir as respectivas saídas as variaáveis de controle do
        % algoritmo.
        
        val3 = x2{4,1}(:,4);
        val11 = x2{3,1}{1,1}.somAprPart2 + x2{3,1}{2,1}.somAprPart2+...
            x2{3,1}{3,1}.somAprPart2 + x2{3,1}{4,1}.somAprPart2;
        val10 = x2{3,1}{1,1}.somTot + x2{3,1}{2,1}.somTot + ...
            x2{3,1}{3,1}.somTot + x2{3,1}{4,1}.somTot;
        dif = abs(val11 - val10);
        if dif < minimo && isempty(find(val3<0,1))
            best = x2;            % atribuiação à variavel de saída.
            minimo = val10;      % métrica da variável de saída              
            numIterNoImprov = 0;  % reset na variável de reset
            arqMelhGrasp = fopen('aarMatBestCgrasp','a');
            condici = log(cond(x2{1,1}{4,1}.matSomAprox));
            impressao(arqMelhGrasp, [(val3)' dif condici]);                  
            fclose(arqMelhGrasp);                        
        else                                                
            numIterNoImprov = numIterNoImprov+1;
        end
        
        %% Diminui o GRID da busca.
        % Diminui o GRID de busca. 
        
        if numIterNoImprov >= maxNumIterNoImprov
            h = h /2;
            numIterNoImprov = 0;
        end
    end
end
end


