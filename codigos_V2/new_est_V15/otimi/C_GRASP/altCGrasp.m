function [partOut, somAproxOut, matPercOut, metMin, newMin, solSai1] = ...
    altCGrasp(matPerc, somAprox, est, h, k, min, max, part, col, metMin, ...
    fun, solEnt,x)

%ALTCGrasp função para fazer a busca da estimativa
%   Essa função irá pegar a a solução construída e fará busca na direção da
%   altura. 

%% dados iniciais
fidVeri = fopen('verifiAltC','a');
impressao(fidVeri, est{3,1}.matSomComp(2,:));
impressao(fidVeri, est{3,1}.matSomAprox(2,:));
fclose(fidVeri);

% identificador
flag = 8 ;

% incialização das variáveis de saída. 
matPercOut = matPerc; partOut = est; somAproxOut = somAprox;
                                   
% atribuição a uma variável arbitrária para não se perder a referẽncia
y = est;                             
                                   
% variável que determinará a divisão da distância na direção requerida.                                  
gridIni = 12;                       
                                    
% A variável 'h' é que determinará o aumento ou não da divisão da distância
% em questão. 
grid = (gridIni)/(h);               
                                   
% altura da solução inicial
altRet = est{part,1}.heighRet;   
                                    
% variável que determinará o encerramento do laço for.
parou = false;                      
                                  
% variável que irá mapear a atribuição da solução corrente à variável de
% saída
newMin = fun;                       
                                   
%% verificação se a busca será para cima ou para baixo da direção especifi.
% Se a direção for negativa, a busca será para baixo.

 % variavel que indicara a atribuiçao de retorno a linesearch. 
 retor = false;
 
% saida
solSai1 = solEnt;

% copia da entrada
copSolEnt = solEnt;

% determinaçao para 
flag1 = (x{3,1}.matSomAprox(col,part) > x{3,1}.matSomComp(col,part));
flag2 = (x{3,1}.matSomAprox(col,part) < x{3,1}.matSomComp(col,part));

if k == -1                                       
    
    % valor da constante que faz a altura transformar para o valor minimo.
    c1 = min / altRet;

    % variável para verificar a iteraçao corrente 
    counti = 1;
    
    % faz a divisão do intervalo [1, c1] segundo o grid necessário.
    % Toma-se o valor 1 porque é a constante que se multiplica o mínimo
    % para dar o valor de 'altRet'. Esse e o passo. 
    val = (1 - c1) / (grid);
    
   
    while parou == false
                                            
        % decrescimento da altura do suprimido, multiplicando atual por <
        % 1, tomando por base que a altura atural ser dada por 
        % y{part,1}.heighRet * 1
        param = y{part,1}.heighRet * (1 - val);
        
        if param >= min && param <= max && ~isequal(min, altRet)
            %reconfigura a altura atual.
            [y{part,1}(:).heighRet] = param;
            [copSolEnt{1,1}{part,1}(:).heighRet] = param;
                                                 
            %setar a nova altura em relação à corrente: se for zero, a 
            % altura decresceu; Se for 1, aumentou.
            [y{part,1}(:).posVarAlt] = 0; 
            [copSolEnt{1,1}{part,1}(:).posVarAlt] = 0;
            
            %compara a altura modificada com a altura corrente. atribui aos
            %parâmetros da partição. 
            vi = param / (altRet);
            [y{part,1}(:).newComMet] = vi; 
            [copSolEnt{1,1}{part,1}(:).newComMet] = vi;            
                                                              
            % compara metade da altura com a atual e atribui esse valos aos
            % parâmetros da partição. 
            va = (y{part,1}.half) / param; 
            [y{part,1}(:).compMeta] = va; 
            va2 = (copSolEnt{1,1}{part,1}.half) / param;
            [copSolEnt{1,1}{part,1}(:).compMeta] = va2;
             
            % reconfigura o parâmetro da partição que indica se a nova 
            % altura está acima ou abaixo da metado do intervalo de valores
            % permitidos.
            if param > est{part,1}.half
                y{part,1}.pos = 1;
                copSolEnt{1,1}{part,1}.pos = 1;
            else                           
                y{part,1}.pos = 0;
                copSolEnt{1,1}{part,1}.pos = 0;
            end                                
        else
            parou = true;
        end
         
        % impressão de percentuais e métricas. 
        [partTemp, somAproxTemp, matPercTemp] = data(y, y{1,1}.perce, col);
        [partT2, somA2, matP2] = data(copSolEnt{1,1},...
            copSolEnt{1,1}{3,1}.perce, col);
        
        % comparaço do modelo de referencia e construido.
        val1 = partT2{3,1}.matSomAprox(col,part);
        val2 = partT2{3,1}.matSomComp(col,part);

        if (val1 < val2 && retor == false && flag1 == 1 )
        
            solSai1 = {partT2; somA2; matP2};
            retor = true;
        else
            if retor == false && parou == true && flag1 == 1
                solSai1 = {partT2; somA2; matP2};
                retor = true;
            end
        end
        
        [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
            resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
            somPartArtIsc] = impress(matPercTemp, somAproxTemp, partTemp, ...
            'aarqAltCGrasp'); 
        
        % verifica se a nova métrica é menor que a corrente. Se os valores
        % de percentuais também são positivos. Serao impressos os valores
        % em caso de melhoras. 
        inpuMe = {partTemp;[1];somAproxTemp;matPercTemp};
        [dif, resul] = metrica(inpuMe);
        if dif < newMin && apxPart > 0 
           partOut = partTemp;
           somAproxOut = somAproxTemp;
           matPercOut = matPercTemp;
           newMin = dif;
        end
        % impressao resultados
        fidVeri = fopen('verifiAltC','a');
        impressao(fidVeri, [partTemp{3,1}.matSomAprox(2,:) dif matPercTemp(:,4)']);
        fclose(fidVeri);
        
         % verificação dos resultados. 
        cd ..;
        cd GRASP;
        metMin = escPerce(inpuMe, metMin, resul, 8);
        cd ..;
        cd C_GRASP;
        
        % comando de impressao. 
        strSta = num2str(counti);
        strDir = num2str(k);
        strVal = num2str(val); 
        strPart = num2str(part);
        strParam = num2str(param);
        conca = strcat('**altCGrasp_iter_',strSta,'_dir_',strDir,'_val_', ...
            strVal ,'_part', strPart,'_altura_',strParam,'**\n');
        fprintf(conca);
        counti = counti + 1;
    end
   
% se a direção for positiva, será para cima a busca. 

else
   
     % constante multiplicativa
     c2 = max / altRet;
    
     %iteração atual
     counti = 1;
    
     % divisão do intervalo na quantidade de grids
     val = (c2 - 1) / (grid);
    
    while parou == false
       
        
        % modificação da altura do retânfgulo
        param = y{part,1}.heighRet * (1 + val);
        
        if param <= max && ~isequal(max, altRet)
           % reconfigura a nova altura
           [y{part,1}(:).heighRet] = param;
           [copSolEnt{1,1}{part,1}(:).heighRet] = param;
           
           % reconfigurar o inteiro que indica que está acima da metade.
           [y{part,1}(:).posVarAlt] = 1;
           [copSolEnt{1,1}{part,1}(:).posVarAlt] = 1;
           % compara a altura modificada com a altura corrente. 
           vq = param / (altRet);
           [y{part,1}(:).newComMet] = vq;
           [copSolEnt{1,1}{part,1}(:).newComMet] = vq;
           
           % compara metade da altura com a altura atual. 
           vb = (y{part,1}.half) / param;
           [y{part,1}(:).compMeta] = vb; 
           [copSolEnt{1,1}{part,1}(:).compMeta] = vb;
           
           % configura o inteiro que indica metade do intervalo com a
           % altura atual. 
           if param > est{1,1}.half
                y{part,1}.pos = 1;
               copSolEnt{1,1}{part,1}.pos = 1;
           else
                y{part,1}.pos = 0;
                copSolEnt{1,1}{part,1}.pos = 0;
           end
        else
            parou = true;
        end
        
        % impressão de percentuais e métricas
        [partTemp2, somAproxTemp2, matPercTemp2 ] = data(y, y{1,1}.perce, ...
            col);
         [partT3, somA3, matP3] = data(copSolEnt{1,1},...
            copSolEnt{1,1}{3,1}.perce, col);
        
        val1 = partT3{3,1}.matSomAprox(col,part);
        val2 = partT3{3,1}.matSomComp(col,part);
        
        if (val1 > val2 && retor == false && flag2 == 1)
            solSai1 = {partT3; somA3; matP3};
            retor = true;
        else
            if retor == false && parou == true && flag2 == 1
                solSai1 = {partT3; somA3; matP3};
                retor = true;
            end
        end 
        
        
        [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
            resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
            somPartArtIsc] = impress(matPercTemp2, somAproxTemp2, partTemp2, ...
            'aarqaltCGrasp');
        
        %  novo valor de métrica
        inpuMe2 = {partTemp2;[1];somAproxTemp2;matPercTemp2};
        [dif2, resul2] = metrica(inpuMe2);
        
        % compara se a solução modificada é melhor que a corrente. Retorna
        % a solução e precisa pedir para imprimir. 
        if dif2 < newMin && apxPart > 0 
            partOut = partTemp2;
            somAproxOut = somAproxTemp2;
            matPercOut = matPercTemp2;
            newMin = dif2;
        end
        
        % impressao resultados
        fidVeri = fopen('verifiAltC','a');
        impressao(fidVeri, [partTemp2{3,1}.matSomAprox(2,:) dif2 ...
            matPercTemp2(:,4)']);
        fclose(fidVeri);
        
        % verificação dos resultados. 
        
        cd ..;
        cd GRASP;
        metMin = escPerce(inpuMe2, metMin, resul2, 8);
        cd ..;
        cd C_GRASP;
        
        strSta = num2str(counti);
        strDir = num2str(k);
        strVal = num2str(val); 
        strPart = num2str(part);
        strParam = num2str(param);
        conca = strcat('**altCGrasp_iter_',strSta,'_dir_',strDir,'_val_', ...
            strVal , '_part', strPart,'_altura_',strParam,'**\n');
        fprintf(conca);
        counti = counti + 1;
    end
end
fprintf('fim_AltCgrasp_Cgrasp \n');

fidVeri = fopen('verifiAltC','a');
fprintf(fidVeri,'***********************************************\n');
fprintf(fidVeri,'***********************************************\n');
fclose(fidVeri);

pause(1);
end
