function [ partOut, somAproxOut, matPercOut, minRes, minDif ] =...
    altCGrasp(matPerc, somAprox, est, h, k, min, max, part, col, minRes, ...
    minDif)

%ALTCGrasp função para fazer a busca da estimativa
%   Essa função irá pegar a a solução construída e fará busca na direção da
%   altura. 

%% dados iniciais

matPercOut = matPerc; partOut = est; somAproxOut = somAprox;
                                    % incialização das variáveis de saída. 


y = est;                             
                                    % atribuição a uma variável arbitrária
                                    % para não se perder a referẽncia. 
                                    
gridIni = 2;                       
                                    % variável que determinará a divisão da
                                    % distância na direção requerida. 

grid = (gridIni)/(h);               
                                    % A variável 'h' é que determinará o 
                                    % o aumento ou não da divisão da
                                    % distância em questão. 

altRet = est{part,1}.heighRet;   
                                    % altura da solução inicial

parou = false;                      
                                    % variável que determinará o 
                                    % encerramento do laço for.
                                    
retur = est;                          
                                    % variável de saída.

mini = + inf;                       
                                    % variável que irá mapear a atribuição 
                                    % da solução corrente à variável de
                                    % saída
    
maxi = - inf;                       
                                    % variável que irá mapear a corrente 
                                    % solução à variável de maximo valor.
%% verificação se a busca será para cima ou para baixo da direção especifi.
% Se a direção for negativa, a busca será para baixo.

if k == -1                                        % busca abaixo 
    c1 = min / altRet;                            
                                                  % procura a constante
                                                  % multiplicativa que faz
                                                  % a altura atual
                                                  % transformar na altura
                                                  % mínima. 
    counti = 1;
    while parou == false
        
        val = (1 - c1) / (grid);                  
                                                  % faz a divisão do inter
                                                  % -valo de valores 
                                                  % compreendido entre o
                                                  % mínimo e o atual
                                                  % segundo o grid
                                                  % necessário. 
        param = y{part,1}.heighRet * (1 - val);
                                                  % realiza o
                                                  % descresciemnto na
                                                  % altura do composto
                                                  % suprimido, multiplican
                                                  % -do a altura atual por
                                                  % um fator menor que 1. 
                                            
        if param >= min && param <= max && ~isequal(min, altRet)
            [y{part,1}(:).heighRet] = param;
                                                  % irá setar a altura da 
                                                  % solução corrente.
                                                  
            [y{part,1}(:).posVarAlt] = 0;    
                                                  % irá setar a posição da 
                                                  % altura em relação à
                                                  % posição atual: Se for
                                                  % zero, a posição será
                                                  % pra baixo; se for 1,
                                                  % será para cima. 
                                        
            
           
            vi = param / (altRet);
            [y{part,1}(:).newComMet] = vi;            
                                                              % variável 
                                                              % irá
                                                              % comparar a
                                                              % altura
                                                              % modificada
                                                              % com a
                                                              % antiga
                                                              % altura. 
            
            
            va = (y{part,1}.half) / param; 
            [y{part,1}(:).compMeta] = va;       
                                                % variável que irá comparar
                                                % a metade da altura com a
                                                % altura atual. 
           
                                                
            if param > est{part,1}.half
                y{part,1}.pos = 1;
            else                           
                y{part,1}.pos = 0;
            end                                % irá setar a variável 
                                               % altura ese ela se encontra 
                                               % acima ou abaixo da metade.
        else
            parou = true;
        end
        
        [partTemp, somAproxTemp, matPercTemp] = data(y, y{1,1}.perce, col);
        [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
            resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
            somPartArtIsc] = impress(matPercTemp, somAproxTemp, partTemp, ...
            'aarqaltCGrasp');  
                                % conferir nesse arquivo todas as saídas
                                % de percentuais associadas a métrica
                                % definida como a subtração entre a área
                                % total e a área aproximada pelos mínimos
                                % quadrados. 
        valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
        valDif = [(apxPart - toPart)  somPartZ somPartArtIcc somPartArtIsc];
        [minRes, minDif] = divMetCgrasp(matPercTemp, valApx, valDif, ...
            condMatApx, minRes, minDif);                        
        dif = abs(apxPart - toPart);
        if dif < mini && apxPart > 0 && pontNeg == 1
           partOut = partTemp;
           somAproxOut = somAproxTemp;
           matPercOut = matPercTemp;
           mini = dif;
        end
        strSta = num2str(counti);
        conca = strcat('iter_AltCgrasp_Cgrasp_', strSta, '\n');
        fprintf(conca );
        counti = counti + 1;
    end
   
% se a direção for positiva, será para cima a busca. 

else                                           % busca acima
    c2 = max / altRet;
    counti = 1;
    while parou == false
        val = (c2 - 1) / (grid);
        param = y{part,1}.heighRet * (1 + val);
        if param <= max && ~isequal(max, altRet)
           [y{part,1}(:).heighRet] = param;
           [y{part,1}(:).posVarAlt] = 1;
           vq = param / (altRet);
           [y{part,1}(:).newComMet] = vq;
           vb = (y{part,1}.half) / param;
           [y{part,1}(:).compMeta] = vb; 
           if param > est{1,1}.half
                y{part,1}.pos = 1;
           else
                y{part,1}.pos = 0;
           end
        else
            parou = true;
        end
        [partTemp, somAproxTemp, matPercTemp ] = data(y, y{1,1}.perce, col);
        [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
            resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
            somPartArtIsc] = impress(matPercTemp, somAproxTemp, partTemp, ...
            'aarqaltCGrasp');
        valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
        valDif = [(apxPart - toPart)  somPartZ somPartArtIcc somPartArtIsc];
        [minRes, minDif] = divMetCgrasp(matPerc, valApx, valDif, ...
            condMatApx, minRes, minDif); 
        dif = abs(apxPart - toPart);
        if dif < mini && apxPart > 0 && pontNeg == 1
            partOut = partTemp;
            somAproxOut = somAproxTemp;
            matPercOut = matPercTemp;
            mini = dif;
        end
        strSta = num2str(counti);
        conca = strcat('iter_AltCgrasp_Cgrasp_', strSta, '\n');
        fprintf(conca );
        counti = counti + 1;
    end
end
fprintf('fim_AltCgrasp_Cgrasp \n');
end
