function [ retur ] = enlarge( resCons,numMin)
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

% verifica o número de canais na partição
tamCh = size(resCons{1,1}{1,1}.ch);

% descreve os canais inseridos na partição 
chan = resCons{1,1}{1,1}.ch;

% variável para armazenar novo início
newChan = chan;

% variável temporária para armazenar o ultimo canal. 
ter = chan(end,1);

% variável para armazenar o primeiro canal corrente.
ini = chan(1,1);

% variável para armazenar o número corrente de canais.
numCha = tamCh(1,1);

% partição de maior resíduo.
esc = resCons{1,1}{1,1}.partEsc;

% ponterio que determinará o término do laço. 
parou  =  false;

% abertura do arquivo de impressão.
arq = fopen('aarqIndices','a');
impressao(arq,[0, 0, 0.00000001*10^-5, 0, 0, 0]);
fclose(arq);        

while parou ==  false
    % determinaçao aleatória da ação a ser tomada. 
    acLar = randi([0 1],1,1);
    
    % ação de alargar o intervalo.
    if acLar == 1
        % percentual em torno do qual o intervalo deve aumentar.
        varPerLar = (randi([1 100],1,1))/100;
        % numero de canais a serem inseridos.
        varLar = ceil((varPerLar * numCha)/(2));
        
        % verifica se o aumento irá ser menor que o menor canal da part.
        if  ini - varLar <= esc(1,1)
            newIni = esc(1,1);
        else
            newIni = ini - varLar;
        end
        
        % verifica se o aumento será maior que o maior canal da partição 
        if ter + varLar >= esc(1,2)
            newTer = esc(1,2);
        else
            newTer = ter + varLar;
        end
        
        % variáveis para aumentar os canais
        mat1 = [newIni:ini-1]';  %#ok<NBRAK>
        mat2 = [ter+1:newTer]';  %#ok<NBRAK>
        newChan = [mat1;chan;mat2];
        indice1 = newChan(1,1);
        indice2 = newChan(end,1);
    
        % ação de encurtar o intervalo
    else
        % variação no encurtamento dos canais 
        varPerLar = (randi([1 100],1,1))/100;
        
        % quantidade de canais a serem extraídos
        varLar = ceil((varPerLar * numCha)/(2));
        
        % laço para diminuir a delta no número de canais para que se tenha
        % um valor mínimo de 10 canais nas partições. 
        while (tamCh(1,1) - 2 * varLar) < numMin
            varLar = varLar - 1;
        end
        
        % se o estreitamento dos canais for maior que o ultimo canal,
        % adota-se como novo canal inicial o canal de término. 
        indIni = 1;
        indTer = tamCh(1,1);
        if  indIni + varLar >= indTer
            newIndIni = indTer;
        else
            newIndIni = indIni + varLar;
        end
        
        % se o estreitamento do ultimo canal for menor que o primeir canal.
        % adota-se como término o primeiro canal. 
        if indTer - varLar <= indIni
            newIndTer = indIni;
        else
            newIndTer = indTer - varLar;
        end
        
        % trocam-se os canais caso o novo canal de início seja maior que o
        % novo canal de término. 
        if newIndIni > newIndTer
            temp = newIndIni;
            newIndIni = newIndTer;
            newIndTer = temp;
        end
        
        % descrição dos canais.
        newChan = chan(newIndIni:newIndTer,1);
        
        % novo canal terminal.
        newTer = newChan(end,1);
        
        % novo canal inicial.
        newIni = newChan(1,1);
        
        % variável para impressão
        indice1 = newChan(1,1);
        
        % variável para impressão. 
        indice2 = newChan(end,1);

    end
    
    % verifica se o canal terminal é menor que o maior canal da partição;
    % se o canal inicial é maior que o menor canal da partição e se o novo
    % primeiro canal inicial é menor que o ultimo canal. 
    if newTer <= esc(1,2) && newIni >= esc(1,1) && newTer ~= newIni
        parou =  true;
    end
end

% impressão
arq = fopen('aarqIndices','a');
impressao(arq,[indice1 indice2 varPerLar acLar 1 varLar]);
fclose(arq);


pos = resCons{1,1}{1,1}.pos;
partEsc = resCons{1,1}{1,1}.partEsc;

% número de canais modificados. 
fim = newTer - newIni;
retur = struct('starWide', newIni,'endWide', newTer, 'pos', ...
    pos, 'partEsc', partEsc,'fim',fim,'newCha',newChan);
end

