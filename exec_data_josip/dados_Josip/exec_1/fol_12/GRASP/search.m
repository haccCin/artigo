function [ resSear, minRes, minDif ] = search( resCons, tamLista, canais, ...
    maxIter, ref, col, minRes, minDif)
%SEARCH Summary of this function goes here
%   Detailed explanation goes here

%% busca

% diretrizes da busca 
% **Parâmetro de entrada: A última solução construída, 
% 1- Definir um vizinho:Vizinho pode ser definido em termos da variação de
% altura da partição escolhida (passo percentual em relação ao percentual 
% atual e passo de largura em relação à largura atual). 
% Essa variação de altura será pensado
% como um percentual do percentual da altura do retângulo aproximador do
% compostos do sódio. Esse percentual será setado entre 10% e 50% da altura
% do retângulo. à variação de largura pode ser pensada como um determinada
% quantidade de canais a ser inserida ou extraída nos extremos de cada um 
% das
% partições, obedecendo ao critério de não ultrapassar os limites do mesmo.
% Para isso, se faz necessário uma estrutra de dados contendo as
% informações sobre todas as partições. A variação na largura será definida
% como um percentual dos canais já inseridos na partição, desde que se
% respeite os limites do canal. Esse percentual será setado entre 10% e
% 50%. 'posVarAlt' indicará se o percentual de variação da altura se dará
% acima ou abaixo da posição atual. 'acLar' vai determinar se a largura da
% partição escolhida deve diminuir ou aumentar.

% 2- O método precisa de uma métrica para saber quão boa é a solução
% construída. Essa métrica pode ser a multiplicaçãop dos percentuais de
% saída do MMQ pela soma das contagens espectrais dos compostos em cada
% partição.

% 3- Criar uma lista para as melhores soluções da busca: Essa lista será
% povoada até que esteja completamente preenchida. se a lista não conseguir
% ser preenchida, será necessário definir um número máximo de iterações. Se
% esse número máximo de interações é determinado por 'maxIter'.
% ao final das duas condições acima, se a lista estiver vazia, é porque a
% soluçao é um mínimo, e a busca se encerra.

% 4- Parâmetros de entrada: Solução construída. 

% 5- durante a execução do algoritmo, pode-se sortear um número para
% determinar o passo na altura e se essa mesma altura será aumenta ou
% diminuída. Isso também pode ser feito pelo sorteio de um núemro aleatório
%; Além, também, de um  número aleatório para determinar o passo na largura
%, e se essa largura sera diminúida ou aumentada. Tudo isso pode ser feito
% pelo sorteio de um número aleatório.

% 6- Será feito para as 4 partições? Para o desconhecido simulado?

% 7- as ações de variar a largura da partição e de aumentar ou diminuir a
% altura do retângulo são ações disjuntas, não podem ser feitas
% seguidamente para posterior cálculo da métrica. Uma ação de variação da
% altura necessita ser feita, calculada a métrica, e posteriormente uma
% ação de variação de largura da partição, para posterior cálculo da
% métrica. 

arqAlt = fopen('aarqAlt','a');
impressao(arqAlt,...
            [1.0000001*10^-5 1.0000001*10^-5 1.0000001*10^-5 ...
            1.0000001*10^-5 1 1 1.0000001*10^-5 1.0000001*10^-5 ...
            1.0000001*10^-5 1 1 1 1.0000001*10^-5 1.0000001*10^-5 ...
            1.0000001*10^-5]);
fclose(arqAlt);
arqLarg = fopen('aarqLar','a');
impressao(arqLarg,...
            [0 0 0 0 0 0]);
fclose(arqLarg);
resSear = resCons;
lista = cell(tamLista,1);
lista{1,1} = resCons;
while ~isempty(lista{1,1})
    lista = cell(tamLista,1);
    t = 1;
    iter = 1;
    while (t <= tamLista && iter < maxIter )
        copCons1 = resCons;
        datAlt = alt(resCons);
        arqAlt = fopen('aarqAlt','a');
        impressao(arqAlt,...
            [datAlt.altret datAlt.max datAlt.min datAlt.presHalf ...
            datAlt.pos datAlt.posVarAlt datAlt.newHeig datAlt.varPerHeig ...
            datAlt.perceHeigh datAlt.starWide datAlt.endWide ...
            datAlt.presPos datAlt.compMeta datAlt.half]);
        fclose(arqAlt);
        est1 = struct('starWide', datAlt.starWide, 'endWide',...
            datAlt.endWide,'half', datAlt.half,'maxPart', datAlt.max, ...
            'minPart', datAlt.min, 'height', datAlt.newHeight, ...
            'heighRet', datAlt.newHeig,...
            'pos', datAlt.pos,'posVarAlt', datAlt.posVarAlt, 'canais', ...
            canais, 'partEsc', datAlt.partEsc,'compMeta',...
            datAlt.compMeta,...
            'total', resCons{1,1}{1,1}.total, ...
            'compostos', resCons{1,1}{1,1}.compostos);
        copCons1{1,1}{1,1} = est1;
        param1 = copCons1{1,1};
        perce1 = resCons{1,1}{1,1}.perce;
        [partTemp, somAproxTemp, matPercTemp] = data(param1, perce1, col);
        dat1 = {partTemp; matPercTemp(:,1); somAproxTemp;matPercTemp};
        ch1 = searCha(dat1{1,1}{1,1}.starWide, dat1{1,1}{1,1}.endWide,...
            dat1{1,1}{1,1}.compostos);
        [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
            resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
            somPartArtIsc] = impress(matPercTemp, somAproxTemp, partTemp, ...
            '');
        valApx= [resApxMMQ resApxZ resApxArtIcc resApxArtIsc];
        valDif = [(apxPart - toPart)  somPartZ somPartArtIcc somPartArtIsc];
        [minRes, minDif] = divMetGrasp(matPercTemp, valApx, valDif, ...
            condMatApx, minRes, minDif);
        [dat1{1,1}{1,1}(:).ch] = ch1';
        difAlt1 = metrica(resCons);
        difAlt2 = metrica(dat1);
        if difAlt2 < difAlt1 && t < tamLista
            lista{t,1} = dat1;
            t = t + 1;
            strSta = num2str(t);
            conca = strcat('inser_lista_busca_GRASP_alt', strSta, '\n');
            fprintf(conca);
        end
        datLar = enlarge(resCons, 10);
        arqLarg = fopen('aarqLar','a');
        impressao(arqLarg,...
            [resCons{1,1}{1,1}.starWide, resCons{1,1}{1,1}.endWide,...
            datLar.starWide datLar.endWide datLar.pos datLar.fim]);
        fclose(arqLarg);
        [difLar1, difLar2, dat2] = datEnlar(datLar.newCha,...
            resCons, canais, ref, col, minRes, minDif);
        ch2 = searCha(dat2{1,1}{1,1}.starWide, dat2{1,1}{1,1}.endWide,...
            dat2{1,1}{1,1}.compostos);
        [dat2{1,1}{1,1}(:).ch] = ch2';
        if difLar2 < difLar1 && t < tamLista
            lista{t,1} = dat2;
            t = t + 1;
            strSta = num2str(t);
            conca = strcat('inser_lista_busca_GRASP_lar', strSta, '\n');
            fprintf(conca);
        end
        iter = iter + 1;
    end
    if t ~= 1
        alea = randi([1 t-1],1,1);
        resCons = lista{alea,1};
        resSear = resCons;
        fprintf('escolheu_busca_lista_GRASP \n');
    end
end
arqAlt = fopen('aarqAlt','a');
        impressao(arqAlt,...
            [0.0000001*10^-5 0.0000001*10^-5 0.0000001*10^-5 ...
            0.0000001*10^-5 0 0 0.0000001*10^-5 0.0000001*10^-5 ...
            0.0000001*10^-5 0 0 0 0.0000001*10^-5 0.0000001*10^-5 ...
            0.0000001*10^-5]);
fclose(arqAlt);
arqLarg = fopen('aarqLar','a');
impressao(arqLarg,...
            [0 0 0 0 0 0]);
fclose(arqLarg);

end


