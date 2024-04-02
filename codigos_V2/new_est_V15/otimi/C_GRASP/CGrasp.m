function [ best, metMin, minimo ] = CGrasp(matPerc ,somAprox, x, dimen, fun , ...
    maxIters, maxNumIterNoImprov, numTimesToRun, maxDirToTry, alpha,col, ...
    metMin)
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

minimo = fun;

% formatação da variável de saída, caso não encontre solução melhor   
best = {x; x{2,1}(:,1) ;somAprox; matPerc};                                  
                                            
% valor inicial de solução da métrica.
val = 0;
tamMat1 = size(somAprox);
for l = 1 : tamMat1(1,1)
    val = val + somAprox{l,1}.somAprPart2 ;
end                                                            
% imprime os valores de percentuais positivos. 
arqMatCgrasp = fopen('aarMatBestCgrasp','a'); 
fclose(arqMatCgrasp);     
                                              
% imprimir todas as saídas do processo construtivo. Irá imprimir os percent.
% uais como primeiro parâmetro; os valores de área abaixo da curva como
% segundo parâmetro; o valor de área abaixo da curva no inicio do algoritmo
% opr fim um inteiro que indica se os percentuais são todos positivos. 
arqConstCGrasp  = fopen('aarqConsCgrasp','a');
fclose(arqConstCGrasp);                                  
                                                          
% arquivo que será escrito na função 'altCGrasp'. Será impresso pela função
% impress, onde o importante são os percentuais, a métrica e
% condicionamento. 
arqalt = fopen('aarqAltCGrasp','a');
fclose(arqalt);   
 
% arquivo escrito na saída do 'LineSearch'. Será impresso pela função
% 'impress'. 
arqline = fopen('aarqLine','a');        
fclose(arqline); 


% arquivo para trabalhar com as saídas da busca local.
arqInterImpro = fopen('aarqImpro','a');
fclose(arqInterImpro);   

 % arquivo para trabalhar com as saídas da do processo construtivo
arqConstImpro = fopen('aarqConsInCgrasp','a');
fclose(arqConstImpro);  
 
% densidade inicial do grid. 
h = 1;

%valor do flag
flag = 6;

for i = 1 : numTimesToRun
                                      
    numIterNoImprov = 0; 
        
    for iter = 1 : maxIters
        % saída construtivo. 
        [constru, metMin, verMinimo ]= construct(matPerc, somAprox, x, fun,...
            dimen, h, alpha, col,metMin); 
        
         % parametrizando para verificar melhorias
        [saiOut, inputEscPerce] = metrica(constru);
        fun = saiOut;
        
        % verificacao das melhorias
        if saiOut < minimo && any((constru{4,1}(:,4))< 0 ) == 0 
            best = constru;
            minimo = saiOut; 
            val4 = constru{4,1}(:,4);
            
            
            % comando de impressão. Imprime ppercetuais e nº condicionam. 
            arqMelhGrasp = fopen('aarMatBestCgrasp','a');
            sizeConsDat1 = size(constru{1,1});
            condici = log(cond(constru{1,1}{sizeConsDat1(1,1),1}.matSomAprox));
            impressao(arqMelhGrasp, [(val4)' saiOut condici]);                  
            fclose(arqMelhGrasp);
        end
        
        % impressão
        cd ..;
        cd GRASP;
        metMin = escPerce(constru, metMin, inputEscPerce,6);
        cd ..
        cd C_GRASP;
                                                                             
        % impressão do passo de construção de solução. 
        matConst1 = constru{4,1}(:,4);
        val2 = isempty(find(constru{4,1}(:,4) < 0,1));
        val1 = 0;
        tamApr = size(constru{3,1});
        for u = 1 : tamApr(1,1)
            val1 = val1 + constru{3,1}{u,1}.somAprPart2;
        end
        arqSaiConstru = fopen('aarqConsCgrasp','a');
        impressao(arqSaiConstru,[(matConst1)' val1 val val2]);
        fclose(arqSaiConstru);                            
       
        % colocar aqui um comando de impressao para verificaço das
        % melhorias. Colocar um flag para saber os valores de percentuais,
        % valor da métrica e onde ocorreu a melhoria. 
        
       
        % *********************início das buscas**************************                                         
         % Função que irá buscar melhores soluções
        qtdPart = size(constru{4,1}(:,1));
        [x2,  metMin, newMi] = localImprove(constru, fun, dimen, h, ...
            constru, constru, maxDirToTry, qtdPart(1,1), col, metMin);
        fprintf('procurou_Cgrasp \n');
        
       
        %% Verificações das duas saídas
        % Trecho de código que irá verificar as duas saídas anteriores e
        % atribuir as respectivas saídas as variaáveis de controle do
        % algoritmo.
             
        % impressao do arquivo
        [metri2, resul2] = metrica(x2);
        cd ..;
        cd GRASP;
        metMin = escPerce(x2, metMin, resul2, flag);
        cd ..;
        cd C_GRASP;
       
        
        % veriicação se há uma melhor saída
        if metri2 < minimo && any(x2{4,1}(:,4) < 0) == 0
            % atribuição do resultado da busca à saída. 
            best = x2;
            
            % valores de percentuais 
            val3 = x2{4,1}(:,4);
            
            % atribuição à variável ponteiro. 
            minimo = metri2;      
            
            %reseta a variável que contará iterações sem melhorias.
            numIterNoImprov = 0;  
            
           % comando de impressão. Imprime ppercetuais e nº condicionam. 
            arqMelhGrasp = fopen('aarMatBestCgrasp','a');
            tamX2 = size(x2{1,1});
            condici = log(cond(x2{1,1}{tamX2(1,1),1}.matSomAprox));
            impressao(arqMelhGrasp, [(val3)' metri2 condici]);                  
            fclose(arqMelhGrasp);                        
        else  
            % imcrementa-se o número de iterações sem melhorias. 
            numIterNoImprov = numIterNoImprov+1;
        end
        
        %% Diminui o GRID da busca.
        % Diminui o GRID de busca. 
        
        if numIterNoImprov >= maxNumIterNoImprov
            h = h /2;
            numIterNoImprov = 0;
        end
        % impressão para indicar o fim da construção e iteração atual.
        iterSTR=num2str(iter);
        numTimesToRunSTR=num2str(i);
        strConc = strcat('**numRun_', numTimesToRunSTR, '_ter_', iterSTR,'\n');
        fprintf(strConc);
        pause(1);
    end
end
end


