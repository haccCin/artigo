function [ resul, minRes, minDif ] = linkAlt( start, target, canais,...
    numMin, passo, col, minRes, minDif)
%LINKALT Summary of this function goes here
%   Detailed explanation goes here

resul = target;
max = start{1,1}{1,1}.maxPart; 
min = start{1,1}{1,1}.minPart;
hstart = start{1,1}{1,1}.heighRet;
htarget = target{1,1}{1,1}.heighRet;
disPasso = (abs(hstart - htarget))/(passo);
[metStart,resulSta] = metrica(start);
[metTarget,resulTar] = metrica(target);

if metStart < metTarget
    temp = target;
    target = start;
    start = temp;
end

[metStart,resulSta] = metrica(start);
[metTarget,resulTar] = metrica(target);
if hstart > htarget
    copStart = start;
    for  i = 1 : passo
        h = hstart - i * disPasso;
        if h > min && h < max
            copStart{1,1}{1,1}.heighRet = h;
            copStart{1,1}{1,1}.height = copStart{1,1}{1,1}.heighRet...
                / copStart{1,1}{1,1}.half;
            copStart{1,1}{1,1}.compMeta = abs(1-(copStart{1,1}{1,1}.half...
                / copStart{1,1}{1,1}.height));
            [partTemp, somAproxTemp, matPercTemp] = ...
                data(copStart{1,1}, copStart{1,1}{1,1}.perce, col);
                    % DEfiniçao das informacoes relativas de cada uma das
                    % particoes. 
            dat = {partTemp; matPercTemp(:,1);somAproxTemp; matPercTemp};
                    % definicao da variavel  unica que contera as
                    % informacoes da particao;do particionamento dos dados
                    % ;da soma das integrais de cada uma das particoes; e
                    % valores percentuais para cada um dos metodos.
                    
            [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, ...
                        resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                        somPartArtIcc, somPartArtIsc] = ...
                        impress(matPercTemp, somAproxTemp, partTemp, '');
                    % variaveis de saida.
            valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
                    % formatacao de variaveis
            valDif = [(apxPart - toPart)  somPartZ somPartArtIcc  ...
                somPartArtIsc];
                    % formatacao de variaveis 
            [minRes, minDif] = divMetGrasp(matPercTemp, valApx, ...
                        valDif, condMatApx, minRes, minDif);
                    % escrita dos arquivos
            [dat{1,1}{1,1}(:).ch] = (start{1,1}{1,1}.ch);
            metDat = metrica(dat);
            tamSol = size(dat{1,1}{1,1}.ch);
            [dat{1,1}{1,1}(:).free] = tamSol(1,1) - numMin;
            arqAlt = fopen('aaArqAltLink','a');
            impressao(arqAlt,[hstart htarget h metTarget metDat]);
            fclose(arqAlt);
            if metDat < metTarget
                resul = dat;
            end
        end
    end
else
    copStart = start;
    for j = 1 : passo
        h = hstart - j * disPasso;
        if h > min && h < max
            copStart{1,1}{1,1}.heighRet = h;
            copStart{1,1}{1,1}.height = copStart{1,1}{1,1}.heighRet...
                / copStart{1,1}{1,1}.half;
            copStart{1,1}{1,1}.compMeta = abs(1-(copStart{1,1}{1,1}.half...
                / copStart{1,1}{1,1}.height));
            [partTemp, somAproxTemp, matPercTemp] = ...
                data(copStart{1,1}, copStart{1,1}{1,1}.perce, col);
                    % DEfiniçao das informacoes relativas de cada uma das
                    % particoes. 
            dat = {partTemp; matPercTemp(:,1);somAproxTemp; matPercTemp};
                    % definicao da variavel  unica que contera as
                    % informacoes da particao;do particionamento dos dados
                    % ;da soma das integrais de cada uma das particoes; e
                    % valores percentuais para cada um dos metodos.
                    
            [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, ...
                        resApxZ, resApxArtIcc, resApxArtIsc,  somPartZ, ...
                        somPartArtIcc, somPartArtIsc] = ...
                        impress(matPercTemp, somAproxTemp, partTemp, '');
                    % variaveis de saida.
            valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
                    % formatacao de variaveis
            valDif = [(apxPart - toPart)  somPartZ somPartArtIcc  ...
                somPartArtIsc];
                    % formatacao de variaveis 
            [minRes, minDif] = divMetGrasp(matPercTemp, valApx, ...
                        valDif, condMatApx, minRes, minDif);
                    % escrita dos arquivos 
            [dat{1,1}{1,1}(:).ch] = (start{1,1}{1,1}.ch);
            [metDat, metDat] = metrica(dat);
            tamSol = size(dat{1,1}{1,1}.ch);
            [dat{1,1}{1,1}(:).free] = tamSol(1,1) - numMin;
            arqAlt = fopen('aaArqAltLink','a');
            impressao(arqAlt,[hstart htarget h resulSta(1,1) resulTar(1,1)...
                metDat(1,1)]);
            fclose(arqAlt);
            if metDat < metTarget
                resul = dat;
            end
        end
    end
end
end
