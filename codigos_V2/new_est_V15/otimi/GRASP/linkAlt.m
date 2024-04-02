function [ resul, sevMinLG, minimo] = linkAlt( start, target, canais,...
    numMin, passo, col, metMinLin1 ,fun)
%LINKALT Summary of this function goes here
%   Detailed explanation goes here

% target atribuido ao resultado 
resul = target;

% atribuicao À variavel de saida 
minimo = fun;

% varias metricas.
sevMinLG = metMinLin1;

% metricas da soluçao start
max = start{1,1}{1,1}.maxPart; 
min = start{1,1}{1,1}.minPart;
hstart = start{1,1}{1,1}.heighRet;

% altura da soluço target.
htarget = target{1,1}{1,1}.heighRet;

% diferenca de altura entre start e target
disPasso = (abs(hstart - htarget))/(passo);

% metricas das solucoes
[metStart,resulSta] = metrica(start);
[metTarget,resulTar] = metrica(target);

% inversao das solucoes.
if metStart < metTarget
    temp = target;
    target = start;
    start = temp;
end

% recálculo das métricas, após a inversão.
[metStart,resulSta] = metrica(start);
[metTarget,resulTar] = metrica(target);

% se o start for maior
if hstart > htarget
    
    % copia da soluço start. 
    copStart = start;
    
    % número de passos.    
    for  i = 1 : passo
        
        % diminuiçao da altura de start pelo valor mínimo de distancia.   
        h = hstart - i * disPasso;
        
        % se estiver dentro do intervalo permitido. 
        if h > min && h < max
            
            % reparametrização da copia da solucao start
            copStart{1,1}{1,1}.heighRet = h;
            copStart{1,1}{1,1}.height = copStart{1,1}{1,1}.heighRet...
                / copStart{1,1}{1,1}.half;
            copStart{1,1}{1,1}.compMeta = abs(1-(copStart{1,1}{1,1}.half...
                / copStart{1,1}{1,1}.height));
            
            % recalculo dos dados de saída.
            [partTemp, somAproxTemp, matPercTemp] = ...
                data(copStart{1,1}, copStart{1,1}{1,1}.perce, col);
                   
            % calculo das percentuais e das metricas. 
            [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, ...
                        resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                        somPartArtIcc, somPartArtIsc] = ...
                        impress(matPercTemp, somAproxTemp, partTemp, '');
            
            % reparametrizacao
            dat = {partTemp; matPercTemp(:,1);somAproxTemp; matPercTemp};       
            [dat{1,1}{1,1}(:).ch] = (start{1,1}{1,1}.ch);
            [metDat, resLinAlt] = metrica(dat);
            tamSol = size(dat{1,1}{1,1}.ch);
            [dat{1,1}{1,1}(:).free] = tamSol(1,1) - numMin;
            
            % impressao e saidas
            sevMinLG = escPerce(dat, sevMinLG, resLinAlt,4);
            
            % impressao
            arqAlt = fopen('aaArqAltLink','a');
            impressao(arqAlt,[hstart htarget h metTarget metDat]);
            fclose(arqAlt);
            if abs(metDat) < minimo
                resul = dat;
                minimo = abs(metDat);
            end
        end
    end
% se o target for maior. 
else 
    if hstart < htarget
       
        % copia da solucao start
        copStart = start;
    
        % número de passos  serem dados 
        for j = 1 : passo
        
            % aumentando pelo valor minimo da distancia. 
            h = hstart + j * disPasso;
        
            % intervalor permitido para o novo valor. 
            if h > min && h < max
            
                % reparametrização da copia. 
                copStart{1,1}{1,1}.heighRet = h;
                copStart{1,1}{1,1}.height = copStart{1,1}{1,1}.heighRet...
                    / copStart{1,1}{1,1}.half;
                copStart{1,1}{1,1}.compMeta = abs(1-(copStart{1,1}{1,1}.half...
                    / copStart{1,1}{1,1}.height));
            
                % calculo dos parametros. 
                [partTemp, somAproxTemp, matPercTemp] = ...
                    data(copStart{1,1}, copStart{1,1}{1,1}.perce, col);
            
                % impressao dos percentuais e metricas 
                [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, ...
                    resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                    somPartArtIcc, somPartArtIsc] = ...
                    impress(matPercTemp, somAproxTemp, partTemp, '');
            
                % reconfiguraço das particoes. 
                dat = {partTemp; matPercTemp(:,1);somAproxTemp; matPercTemp};       
                [dat{1,1}{1,1}(:).ch] = (start{1,1}{1,1}.ch);
                [metDat1, resLinAlt2] = metrica(dat);
                tamSol = size(dat{1,1}{1,1}.ch);
                [dat{1,1}{1,1}(:).free] = tamSol(1,1) - numMin;
            
                % impressao
                
                sevMinLG = escPerce(dat, sevMinLG, resLinAlt2,4);
            
                % impressao
                arqAlt = fopen('aaArqAltLink','a');
                impressao(arqAlt,[hstart htarget h metTarget metDat1]);
                fclose(arqAlt);
            
                % traz a solução modificada como soluço do algoritmo se
                % formelhoir que target. 
                if abs(metDat1) < minimo
                    resul = dat;
                    minimo = abs(metDat1); 
                end
            end
        end
    end
end
end
