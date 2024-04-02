function [ resSear, metMin] = search( resCons, tamLista, canais,...
    maxIter, ref, col,  estPe, fun, metMin)
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

%abertura do arquivo para escrever os parametros da largura. 
arqLarg = fopen('aarqLar','a');
fclose(arqLarg);

%inicialização de variaveis. 
resSear = resCons;
lista = cell(tamLista,1);
lista{1,1} = resCons;

medIni = fun;

flag = 3;

% busca realizada até a lista encontrar-se vazia
while ~isempty(lista{1,1})
    
    % reinicializaçao da lista e de algumas variaveis. 
    lista = cell(tamLista,1);
    t = 1;
    iter = 1;
    
    % buscar ate o preenchiimento da lista ou um numero maximo de iteraçoes
    while (t <= tamLista && iter < maxIter )
        
        % copia da soluçao corrente.
        copCons1 = resCons;
        
        % modificacao nos parametros da altura
        datAlt = alt(resCons);
        
        % atribuicao a uma estrutura de dados dos parametros das alturas
        % nas particoes. 
        est1 = struct('starWide', datAlt.starWide, 'endWide',...
            datAlt.endWide,'half', datAlt.half,'maxPart', datAlt.max, ...
            'minPart', datAlt.min, 'height', datAlt.newHeight, ...
            'heighRet', datAlt.newHeig, 'pos', datAlt.pos,'posVarAlt', ...
            datAlt.posVarAlt, 'canais', canais, 'partEsc', datAlt.partEsc,...
            'compMeta',datAlt.compMeta,'total', resCons{1,1}{1,1}.total, ...
            'compostos', resCons{1,1}{1,1}.compostos);
        
        % a primeira particao  modificada. tem que modificar para ser
        % modificada a particao de maior residuo. depois, na ultima linha,
        % serão obtidos valores de métricas e percentuais em 'data'.
        copCons1{1,1}{1,1} = est1;
        param1 = copCons1{1,1};
        perce1 = resCons{1,1}{1,1}.perce;
        [partTemp, somAproxTemp, matPercTemp] = data(param1, perce1, col);
        
        % faz a comparação entre a solução corrente e a modificada. 
        dat1 = {partTemp; matPercTemp(:,1); somAproxTemp;matPercTemp};
        ch1 = searCha(dat1{1,1}{1,1}.starWide, dat1{1,1}{1,1}.endWide,...
            dat1{1,1}{1,1}.compostos);
        [dat1{1,1}{1,1}(:).ch] = ch1';
        [temp2, resulSe] = metrica(dat1);
        % imprimir o arquivo
        metMin = escPerce(dat1, metMin, resulSe, flag);
        if temp2 < medIni && t < tamLista
            lista{t,1} = dat1;
            t = t + 1;
            medIni = (temp2);
            strSta = num2str(t);
            conca = strcat('***ins._list._busc._GRASP_alt***', strSta, '\n');
            fprintf(conca);
            pause(1);
        end
        
        % desse ponto em diante será feita a verificação na variação dos
        % canais. Serão impressos o antigo intervalo de canais, e o
        % intervalo de canais modificado.
        
        datLar = enlarge(resCons, 10);
        
        % calculo dos parametros. 
        [difLar1, difLar2, dat2] = datEnlar(datLar.newCha, resCons, canais,...
            ref, col,  estPe);
        
        % renomeando varivel para facilitar comando.
        z = dat2{1,1}{1,1};
               
         %impressao dos dados apos modificaço da altura. parametros da altur. 
        arqAlt = fopen('aarqIterSearGrasIao','a');
        impressao(arqAlt,[z.starWide z.endWide z.intPart z.heighRet ...
            z.half z.maxPart z.minPart z.height z.pos z.compMeta]);
        fclose(arqAlt);
        
        % impressão dos parâmetros de interesse: percentuais e valores de
        % métricas. Descrição realizada pela chamada à função 'impress'. 
        [apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
            resApxArtIcc, resApxArtIsc,  somPartZ, somPartArtIcc, ...
            somPartArtIsc] = impress(dat2{4,1}, dat2{3,1}, dat2{1,1}, ...
            'aarqIterSearGrasIss');
            
        % descrição dos canais na nova solução. 
        ch2 = searCha(dat2{1,1}{1,1}.starWide, dat2{1,1}{1,1}.endWide,...
            dat2{1,1}{1,1}.compostos);
        [dat2{1,1}{1,1}(:).ch] = ch2';
        
        %impressao do arquivo 
        [resMet1, resMet2] = metrica(dat2);
        metMin = escPerce(dat2, metMin, resMet2, flag);
        if resMet1 < medIni && t < tamLista
            lista{t,1} = dat2;
            t = t + 1;
            medIni = resMet1;
            strSta = num2str(t);
            conca = strcat('***ins._list._bus._GRASP_enl***', strSta, '\n');
            fprintf(conca);
            pause(1);
        end
        iter = iter + 1;
        str5 = num2str(iter);
        aviso = strcat('**************_iter_', str5, '_search_GRASP****\n' );
        fprintf(aviso);
    end
    
    if t ~= 1
        alea = randi([1 t-1],1,1);
        resCons = lista{alea,1};
        resSear = resCons;
        fprintf('escolheu_busca_lista_GRASP \n');
    end
    fprintf('*********termino_iteração_busca_GRASP****************\n');
    pause(1);
end

% término da busca. Comandos a seguir são para armazenamento dos dados de
% saída em arquivos texto. 

arqLarg = fopen('aarqLar','a');
impressao(arqLarg,...
            [0 0 0 0 0 0]);
fclose(arqLarg);
fprintf('***********termino_busca_GRASP***********\n');
pause(2);

end


