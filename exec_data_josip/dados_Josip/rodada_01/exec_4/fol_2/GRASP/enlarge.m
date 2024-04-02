function [ retur ] = enlarge( resCons,numMin )
%ENLARGE Summary of this function goes here
%   Detailed explanation goes here

%% Função para determinar a variação de largura na busca 

% função para determinar a variação na largura da partição escolhida.
% Recebe como parâmetro a solução construída. 'varPerLar' determinar a
% variação na largura da partição, 'ter' indica o término da partição de
% escolha da solução atual. 'ini' indica o início da partição da solução
% atual. 'numCha' indica o número de canais inseridos na partição de
% escolha atual. 'varLar' indicará a variação percentual na largura da
% partição atual, sendo esse valor arredondado para cima.  'acLar' será um
% valor sorteado aleatoriamente para indicar se a variação na largura da
% partição será uma variação positica (adicionando canais ), ou será uma
% variação negativa (retirando canais) . 'esc' indica os canais inseridos
% na partição atual. Se a variação na largura da partição exceder os canais
% da partição escolhida, essa variação será setada para o limite esquerdo
% ou direito da partição. 

tamCh = size(resCons{1,1}{1,1}.ch);
chan = resCons{1,1}{1,1}.ch;
newChan = chan;
ter = chan(end,1);
ini = chan(1,1);
numCha = tamCh(1,1);
esc = resCons{1,1}{1,1}.partEsc;
parou  =  false;
arq = fopen('aarqIndices','a');
impressao(arq,[0, 0, 0.00000001*10^-5, 0, 0, 0]);
fclose(arq);        
while parou ==  false
    acLar = randi([0 1],1,1);
    if acLar == 1
        varPerLar = (randi([1 100],1,1))/100;
        varLar = ceil((varPerLar * numCha)/(2));
        if  ini - varLar <= esc(1,1)
            newIni = esc(1,1);
        else
            newIni = ini - varLar;
        end
        if ter + varLar >= esc(1,2)
            newTer = esc(1,2);
        else
            newTer = ter + varLar;
        end
        mat1 = [newIni:ini-1]';  %#ok<NBRAK>
        mat2 = [ter+1:newTer]';  %#ok<NBRAK>
        newChan = [mat1;chan;mat2];
        indice1 = newChan(1,1);
        indice2 = newChan(end,1);
    else
        varPerLar = (randi([1 100],1,1))/100;
        varLar = ceil((varPerLar * numCha)/(2));
        while (tamCh - 2 * varLar) < numMin
            varLar = varLar - 1;
        end
        indIni = 1;
        indTer = tamCh(1,1);
        if  indIni + varLar >= indTer
            newIndIni = indTer;
        else
            newIndIni = indIni + varLar;
        end
        if indTer - varLar <= indIni
            newIndTer = indIni;
        else
            newIndTer = indTer - varLar;
        end
        if newIndIni > newIndTer
            temp = newIndIni;
            newIndIni = newIndTer;
            newIndTer = temp;
        end
        newChan = chan(newIndIni:newIndTer,1);
        newTer = newChan(end,1);
        newIni = newChan(1,1);
        indice1 = newChan(1,1);
        indice2 = newChan(end,1);

    end
    if newTer <= esc(1,2) && newIni >= esc(1,1) && newTer ~= newIni
        parou =  true;
    end
end
arq = fopen('aarqIndices','a');
impressao(arq,[indice1 indice2 varPerLar acLar 1 varLar]);
fclose(arq);
pos = resCons{1,1}{1,1}.pos;
partEsc = resCons{1,1}{1,1}.partEsc;
fim = newTer - newIni;
retur = struct('starWide', newIni,'endWide', newTer, 'pos', ...
    pos, 'partEsc', partEsc,'fim',fim,'newCha',newChan);
end

