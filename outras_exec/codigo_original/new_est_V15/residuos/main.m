function [resid, residMat, somComp, somTot, newTot, canais, esc, ...
    retorno] = main(col, dat_josip)
%MAIN Summary of this function goes here
%   Detailed explanation goes here

% percentuais dos compostos:
% Am = 0.2
% Cs = 0.2
% Co = 0.5
% Na = 0.1

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

%load dados.mat;
perce1 = [1 1 1 1];
perce2 = [0.2 0.5 0.2 0.1];
newDat1  = dat_josip;
tamNewDat = size(newDat1);
newDat = newDat1;
for u = 2 : tamNewDat(1,2)
    newDat(:,u) = newDat1(:,u) * ((1)/(perce2(1,u-1)));
end
legenDefi = {'Am_';'Co_';'Cs_';'Na_'};
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

primeiDeri = deri(newDat(:,2:end));
segunDeri = deri(primeiDeri);
pic = picos(primeiDeri(:,[1:(col-1),(col+1):end]), ...
    segunDeri(:,[1:(col-1),(col+1):end]));                 
                                                           % linha modifica
                                                           % da para
                                                           % verificar a
                                                           % viabilidade
                                                           % agora com o
                                                           % cobalto como
                                                           % composto
                                                           % suprimido. 
matEnt = newDat(1:900,2:end);
newLe = {legenDefi{[1:(col-1),(col+1):end],1}}';
graficoDif2(matEnt(:,[1:(col-1),(col+1):end]),'novosDados',...
    newLe, perce1, pic, 'Compostos', 'Canais', 'Log Contagens');

%% Geração do total para os novos dados

% é calculado o total para os novos dados. Esses novos dados tem os
% percentuais definidos acima. 

cont = newDat1(1:786,2:end);
newTot = gerTotal(perce1 , cont);
legenda2 = {'total'};
graficoDif((newTot), 'resultado2', legenda2, (1), 'Contagem total', ...
    'Canais','Log Contagens');
tamCont = size(cont);



%% Trecho de código para trazer os canais de referência nos picos

% Trecho de código que irá trazer os intervalos de referência contendo os
% picos dos compostos conhecidos. 

[multi, canais] = mult(tamCont(1,1), 60);
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

newDat2 = newDat(:,2:end);
[resid, residMat ,somComp, somTot, retorno]  = resi(esc, canais, ...
    newDat2(1:786,[1:(col-1),(col+1):end]), newTot,[1 1 1 1], perce1);
legenda2 = {'res'; 'resM';'Am';'Cs';'Na';'tot'};  
legenda = {'Res';'Am'; 'Co'; 'Cs';'Na';'Tot'};
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
    legenda([1:((col+1)-1),((col+1)+1):end],:), ...
    [ 1  perce2(:,[(1:col-1),(col + 1:end)]) 5], ...
    'Partições X Log Soma Contagens','Partições','Log Contagens');

end

