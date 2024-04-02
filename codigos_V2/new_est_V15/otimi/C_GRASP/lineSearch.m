function [ partOut, somAproxOut, matPercOut, newMetMin, metMin,varVer] = ...
    lineSearch(matPerc, somAprox ,x, h, fun, col, dir, metMin)

%LINESEARCH função para fazer a busca em uma determinada direção
%   Função vai fazer a busca em uma determinada direção 'dir', passado como
%   parâmetro 

fidVeri = fopen('verifiLiSe','a');
impressao(fidVeri, x{3,1}.matSomComp(2,:));
impressao(fidVeri, x{3,1}.matSomAprox(2,:));
fclose(fidVeri);

%atribuição das variáveis de saída. 
partOut = x; somAproxOut = somAprox;matPercOut = matPerc;

% input do altcgrasp
inpuAlt = x; inpuSomAlt = somAprox; inpuPercAlt = matPerc;

% variável que receberá a quantidade de partições. 
qtdPart = size(x);      

% variável ponteiro que verificará o mínimo de saída. 
newMetMin = fun;                  

tamDir = size(dir); 

% flag
flag = 9;

% iteração para as diferentes partições.
solEnt = {x;somAprox;matPerc};
for i = 1 : qtdPart(1,1)       
    
    % irá pesquisar nas diferentes direções nas partições.                           
    for j = 1 : tamDir(1,1)
      
        % escolhe uma direção a ser pesquisada e o tamanho dela.
        k = dir(j);    
        tamK = size(k); 
        
        % realiza a busca para o caso em que a direção é unidimensional.
        if k ~= 0 && tamK(1,2) == 1 
                                   
            % fara a pesquisa para uma partição 'i' arbitrária. 
            [partOutAlt, somOutAlt, matPercOutAlt, metMin, newMi, solSai] = ...
                altCGrasp(inpuPercAlt, inpuSomAlt, inpuAlt, h, k,...
                inpuAlt{i,1}.minPart, inpuAlt{i,1}.maxPart, i , col, ...
                metMin, fun, solEnt, x);
            
            % impressao resultados
            input = {partOutAlt;[1];somOutAlt;matPercOutAlt};
            [dif, resul] = metrica(input);
            if k == -1
                fidVeri = fopen('verifiLiSe','a');
                impressao(fidVeri, [solSai{1,1}{3,1}.matSomAprox(col,:) dif ...
                    solSai{3,1}(:,4)']);
                fclose(fidVeri);
                solEnt = solSai;
            end
            if k ==1
                fidVeri = fopen('verifiLiSe','a');
                impressao(fidVeri, [solSai{1,1}{3,1}.matSomAprox(col,:) dif ...
                    solSai{3,1}(:,4)']);
                fclose(fidVeri);
                solEnt = solSai;
            end
         
            % impressão dos percentuais  e das métricas                                                         
            [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
                resApxArtIcc, resApxArtIsc, somPartZ, somPartArtIcc,... 
                somPartArtIsc] = impress(matPercOutAlt, somOutAlt,...
                partOutAlt, 'aarqLine'); 
            
            % impressao do passo do linesearch
            
            inpuSomAlt = somOutAlt;
            inpuPercAlt = matPercOutAlt;
            inpuAlt = partOutAlt; 
            if dif < newMetMin 
                partOut = partOutAlt;
                somAproxOut = somOutAlt;
                matPercOut = matPercOutAlt;
                newMetMin = dif;
                fun = newMetMin;
            end 
                        
            %impressão
            cd ..;
            cd GRASP;
            metMin = escPerce(input, metMin, resul, flag);
            cd ..;
            cd C_GRASP;
                       
            % impressão para acompanhamento de impressão. 
            strSen= num2str(k);
            strDir = num2str(j);
            strPar = num2str(i);
            conca = strcat('****LineSearch_ sentido_', strSen,'_dir_',...
                strDir,'_Part_', strPar,'*****\n');
            fprintf(conca);
        end
    end
    % impressão acompanhamento de impressão. 
    conca2 = strcat('***LineSearch_fim_pesquisa_particao_',strPar,...
        '_***\n');
    fprintf(conca2);
    pause(1); 
end

fidVeri = fopen('verifiLiSe','a');
fprintf(fidVeri,'***********************************************\n');
fprintf(fidVeri,'***********************************************\n');
fclose(fidVeri);
end

