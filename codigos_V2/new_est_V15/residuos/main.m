function [resid, residMat, somComp, somTot, newTot, canais, esc, ...
    retorno] = main(col, dados, inp)
%MAIN Summary of this function goes here
%   Detailed explanation goes here

% percentuais dos compostos:
% agua = 0.2
% sal = 0.3
% oleo = 0.2
% gas = 0.3

%% Oganização dos dados
% O cell contendo os dados de entrada estão com os seus percentuais
% organizados na seguinte ordem: Am Co Cs e Na. Os percentuais definidos
% abaixo são para a ordem descrita acima. Os valores pesquisados estarão na
% primeira celula de 'dat'. Cria-se uma legenda para o gráfico dos dados, e
% depois desenha-se o gáfico. 

% Procura-se a região de maior resíduo à procura de regiões de fotopico,
% Dada uma substância que se deseja reproduzir, entre as substÂncias
% básicas dadas, a reprodução da substâncias que se deseja reproduzir, a
% falta dessa subsTância que se deseja reproduzir esteja mais sensivelmente
% descrita na partição em que o resíduo seja máximo , ou seja, 

% Dada uma substância total, deseja-se saber suas componentes. SAbe-se que
% desse total, supondo três componentes conhecidas, e uma desconhecida,
% deseja-se saber o percentual dessa  substância desconhecida no vaor das
% contagens totais. O resíduo será definido como a diferença entre o total
% real e o total estimado (Total estimado é a aproximação pelos mínimos
% quadrados, como uma combinação linear dos componentes, incluindo a
% desconhecida). O total real é informado, fornecido como espectro lido do
% equipamento, cujos componentes são desconhecidos. A teçnica utilizada
% consiste em propor uma substância fictícia para desempenha o papel da
% desconhecida. As três conhecidas, propõe-se a quarta substância (fictícia)
% como desconhecida. As partições das abscissas são escolhidas associadas à
% a fotopicos. Escolhidos os vetores de partições,  procura-se as regiões
% de abscissas correspondentes aos fotopicos. Localiza-se a região de 
% fotopico. Para encontrar a melhor
% partição, considera-se uma partição como janela, deixando-se deslizar ao
% longo das substâncias, olhando os mínimos quadrados como. Na região de
% maior resíduo é aquela na qual a descrição do total mais sente 'falta'
% dessa quarta substância tomada como fictícia. Então, como resultado das
% implementação da busca por partições, será retornada a partição que tenha
% maior resíduo relativamente aos mínimos quadrados, pois essa partição é a
% partição em que ocorre maior sensibilidde em relação à substância
% fictócia. Em dat{1,1}, ao se pedir para carregar 'dados.mat', existem os
% compostos 'Am', 'Co', 'Cs', e 'Na'. Em dat{2,1}, existem os compostos que
% foram trabalhados durante o mestrado. Na matriz em que se encontram as
% contagens espectrais dos compostos em 'dat{1,1}', tem - se na seguinte
% ordem da esquerda para direita: 'Am', com participação de 20%; 'Co', com
% participação de 50%; 'Cs', com participação de 20% e, por ultimo, o
% sódio, com participação de 10%. Por isso, essa matriz em 'dat{1,1}',
% cujos compostos já se encontram multiplicados pelos seus percentuais,
% precisam retornar para suas constagens espectrais originais,
% multiplicando pelo inverso das frações percentuais originais. A variável
% 'newDat' irá conter os valores de contagens espectrais dos compostos 
% já multiplicados pelos suas frações percentuais; Na variável 'newDat1', 
% irá conter s valores de contagens espectrais sem a multiplicação pelas
% suas frações percentuais. 

load dados.mat;
perce1 = [1 1 1 1];

if inp == 1
    perce2 = [0.334 0.495 0.171];  
end
if inp == 2
    perce2 = [0.436 0.17 0.394]; 
end

newDat1  = dados;
tamNewDat = size(newDat1);
newDat = newDat1;

% dados dos elementos.
if inp == 1
    for u = 2 : tamNewDat(1,2)
        newDat(:,u) = newDat1(:,u) * ((1)/(perce2(1,u-1)));
    end
end

% se os dados forem os compostos. 
%if inp == 2
%    for u = 2 : tamNewDat(1,2)
%        newDat(:,u) = newDat1(:,u) * ((perce2(1,u-1)));
%    end
%end

% legenda dos compostos.
if inp == 2
    legenDefi = {'Ar_';'Água_';'Óleo'};
end

% legenda dos elementos.
if inp == 1
    legenDefi = {'Ar_';'Água_';'Óleo'};
end
%newDat = mat2gray(newDat(:,2:end));
%newDat = [(1:tamNewDat(1,1))' newDat];
%% Detecção dos picos 

% na passagem de parâmetrs para o método 'picos', passa-se apenas as
% matrizes 'primeiDeri' da primeira coluna até a penultima, e a matriz
% 'segunDeri' a mesma coisa, pois a ultima coluna dessas duas matrizes
% dizem respeito à coluna do sódio, composto que é suprimido para sua
% posterior determinação. Na consrução do grafico pela chamada à função
% 'graficoDif2', passaram-se todas as bibliotecas, excetuando a biblioteca
% do sódio. Para essas duas funções, de primeira derivada e segunda
% derivada, passam-se as contagens espectrais originais, sem a
% multiplicação pelo seu respectivo percentual. 

% se os dados forem os elementos. 
if inp == 1
     cont = newDat1(:, 2:end);
     %cont = newDat1(1:774,2:end);
end

% se os dados forem os compostos
if inp == 2
    cont = newDat(:,2:end);
end

tamCont = size(cont);
[multi, canais] = mult(tamCont(1,1), 60);
primeiDeri = deri(newDat(:,2:end));
segunDeri = deri(primeiDeri);
inputPic = (newDat(:,2:end));
pic = picos(5, inputPic (:,[1:(col-1),(col+1):end]), ...
    primeiDeri(:,[1:(col-1),(col+1):end]),...
    segunDeri(:,[1:(col-1),(col+1):end]), canais);  
pic2 = picos(5, inputPic, primeiDeri, segunDeri, canais);
    
% se os dados forem os elementos. 
if inp == 1
    matEnt = newDat(:,2:end);
    %matEnt = newDat(1:774,2:end);
end

% se os dados forem os compostos.
if inp == 2                                                          
    matEnt = newDat(:,2:end);
end


newLe = {legenDefi{[1:(col-1),(col+1):end],1}}';
graficoDif2(matEnt(:,[1:(col-1),(col+1):end]),'novosDados',...
    newLe, perce1, pic, 'Compostos', 'Canais', 'Log Contagens');
graficoDif2(matEnt,'novosDados_geral', legenDefi, perce1, pic2, 'Compostos',...
    'Canais', 'Log Contagens');


%% Geração do total para os novos dados

% é calculado o total para os novos dados. Esses novos dados tem os
% percentuais definidos acima. 

%gerar o total para os elementos. 
if inp == 1
    cont = newDat1(:,2:end);
    %cont = newDat1(1:774,2:end);
    newTot = gerTotal(perce1 , cont);
end

%gerar o total para os compostos. 
if inp == 2
    cont = newDat(:,2:end);
    %cont = newDat(1:976,2:end);
    newTot = gerTotal(perce2 , cont);
end



legenda2 = {'total'};
graficoDif((newTot), 'resultado2', legenda2, (1), 'Contagem total', ...
    'Canais','Log Contagens');




%% Trecho de código para trazer os canais de referência nos picos

% Trecho de código que irá trazer os intervalos de referência contendo os
% picos dos compostos conhecidos. 

tamPic = size(pic);
for h = 1 : tamPic(1,2)
    tamCanais = size(canais);
    for t = 1 : tamCanais(1,1)
        if pic(1,h) > canais(t,1) && pic(1,h) < canais(t,2)
            esc(h,:) = canais(t,:);
        end
    end
end

% Ordenação do resultado do passo anterior

esc = ordenacao(esc);



%% Divisão dos canais em múltiplos de 60

% Divisão dos canais em multiplos de 60. A resposta 'multi' será o valor da
% quantidade de múltiplos de 'canais' dentro da quantidade total de canais
% dos dados de entrada. Os valores de canais de referência será dado por um
% chute no indice de 'canais'. Esse chute preferencialmente se dará nos
% índices que compreendem os 900 primeiros canais, pois aí se encontram os
% canais que tem contagem espectral diferente de zero. A partir desses
% canais, para os novos compostos, a contagem espectral vai a zero. 'resi' 
% irá calcular os valores de resíduos para todos os canais. 'somComp' será
% a soma dos compostos para cada uma das partições. 'somTot' será a soma do
% total para cada uma das partições. A variável 'residMat' trará a
% aproximação pelos mínimos quadrados do método nativo do Matlab. 

% esses são os valores normais, sem multiplicação pelos percentuais.
if inp == 1
    newDat2 = newDat(:,2:end);
    [resid, residMat ,somComp, somTot, retorno]  = resi(esc, canais, ...
        newDat2(:,[1:(col-1),(col+1):end]), newTot,perce1, perce2);
end
if inp == 2
    newDat2 = newDat(:,2:end);
    [resid, residMat ,somComp, somTot, retorno]  = resi(esc, canais, ...
        newDat2(:,[1:(col-1),(col+1):end]), newTot,perce1, perce2);
end

legenda = ['res';newLe;'tot'];  
                                                             % modificar 
                                                             % essa linha
                                                             % posteriormente
                                                             % para que
                                                             % receba como
                                                             % parâmetro os
                                                             % valores das
                                                             % strings de
                                                             % compostos
                                                             % definida em
                                                             % cima do
                                                             % código.
graficoDif([resid somComp somTot], 'resultado2', ...
    legenda, [ 1 perce2(:,[(1:col-1),(col + 1:end)]) 5], ...
    'Partições X Log Soma Contagens', 'Partições',...
    'Log Contagens');

end

