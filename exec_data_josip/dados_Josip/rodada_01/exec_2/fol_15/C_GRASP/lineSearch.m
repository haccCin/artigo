function [ partOut, somAproxOut, matPercOut, minRes, minDif  ] = ...
    lineSearch(matPerc, somAprox ,x, h, fun, col, dir, minRes, minDif)

%LINESEARCH função para fazer a busca em uma determinada direção
%   Função vai fazer a busca em uma determinada direção 'dir', passado como
%   parâmetro 

partOut = x; somAproxOut = somAprox;matPercOut = matPerc;
                              % atribuição das variáveis de saída
                              
somAproxRom = somAprox;

saida = x;

qtdPart = size(x);      
                              % Verifica a quantidade de partições onde 
                              % deve procurar nas diferentes linhas.

mini = fun;                  
                               % Valor mínimo de função. 

tamDir = size(dir);                               
for i = 1 : qtdPart(1,1)       
                               % irá realizar a busca em cada uma das
                               % partições. 
    for j = 1 : tamDir(1,1)
       k = dir(j);     % escolhe uma direção a ser pesquisada.
       
       tamK = size(k); % verifica o tamanho dessa direção. 
       
       if k ~= 0 && tamK(1,2) == 1 
                                   % realiza a busca para o caso em que a 
                                   % direção é unidimensional.
           
           % fara a pesquisa para uma partição em particular. 
            [partTemp, somAproxTemp, matPercTemp, minRes, minDif] = ...
                altCGrasp(matPerc, somAprox, saida, h, k, ...
                saida{i,1}.minPart, saida{i,1}.maxPart, i , col,...
                minRes, minDif);
            
            % verificará se a saida está associada ao menor valor de função
            % . Sendo positivo, essa nova saída será a mínima. 
                                                           
            [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
                resApxArtIcc, resApxArtIsc, somPartZ, somPartArtIcc,... 
                somPartArtIsc] = impress(matPercTemp, somAproxTemp,...
                partTemp, 'aarqLine'); 
            valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
            valDif = [(apxPart - toPart)  somPartZ somPartArtIcc...
                somPartArtIsc];
            [minRes, minDif] = divMetCgrasp(matPerc, valApx, valDif, ...
            condMatApx, minRes, minDif);
            
            dif = abs(apxPart - toPart);
            if dif < mini && apxPart > 0 && pontNeg == 1
                partOut = partTemp;
                somAproxOut = somAproxTemp;
                matPercOut = matPercTemp;
                mini = dif;
            end                                     % verifica se existe 
                                                    % valor de fração
                                                    % percentual negativo.
       strSta = num2str(k);
       conca = strcat(strSta,'_dir_lineSearch \n');
       fprintf(conca );
       end
    end
    strSta = num2str(i);
    conca = strcat(strSta,'_part_lineSearch \n');
    fprintf(conca );
end
end

