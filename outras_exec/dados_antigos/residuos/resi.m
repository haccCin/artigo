
function [ resid, resid2, somComp, somTot,retorno ] = resi( canRef, cana,...
    compo, newTot, perce2,perce1)
%RESI Summary of this function goes here
%   Detailed explanation goes here

%% Função para retornar os valores de resíduo. 

% Parâmetros de entrada: 'canRef', são os canais de referência; 'cana' são
% as partições do conjunto global de canais; 'compo' são os compostos e
% newTot são as contagens espectrais do total para os compostos de
% amerício, cobalto, cesio e sódio. OS parâmetros de saída são: 'resid', os
% valores de resíduos para cada um dos canais, sendo o resíduo definido
% como a diferença entre o total trazido pela estimativa dos mínimos
% quadrados e o definido como a soma do 'newTot' em cada uma das partições. 
% 'somTot' é o valor da contagem espectral total para cada uma das
% partições. A variável 'x' trará a aproximação pelos mínimos quadrados do
% próprio Matlab. Multiplica-se esses percentuais 'x' pelas somas de
% referência 'somTotRef'. Após, calcula-se o valor do resíduo pela
% variável 'diAprMat'. Foi incluída no programa a variável 'retorno', que
% incluirá os dados de cada uma das iterações, como o valor da diferença
% dos mínimos quadrados, o valor da 

% somRef tras uma matriz 3 X 3, onde nas linhas se tem a soma das contagens
% espectrais para partição fixa para diferentes compostos; nas colunas,
% tem-se  a soma das contagens espectrais para compostos fixos, entre as
% diferentes partições.

% 'soma' tras as somas de contagens esepctrais para uma partição entre os
% diferentes compostos, em uma linha.

tamRef = size(canRef); % traz os canais de referencia e verifica tamanho. 
tamCan = size(cana); % traz todas as partições do universo de canais.   
somRef = somCanais(canRef, compo, 60,perce2); 
                                              % traz os valores de soma de
                                              % contagem espectral nas
                                              % partições de referência.
                                              % Aqui os valores de contagem
                                              % espectral são os originais,
                                              % sem a multiplicação de
                                              % frações percentuais. 
somTotRef = somCanais(canRef, newTot, 60,perce1); 
                                                  % soma das constagens e
                                                  % espectrais totais nos
                                                  % canais de referência.
resid = [];
resid2 = [];
somTot = zeros(tamCan(1,1),1); 
                                % variável para receber as somas totais nas
                                % diferentes partições. 
somComp = zeros(tamCan(1,1), tamRef(1,1));
                                            % variável que armazenará os v
                                            % valores de compostos nas
                                            % diferentes partições. 
retorno = cell(tamCan(1,1),1);
                                % variável que receberá os parâmetros de
                                % saída. 
maxResi = 0; % variável para armazenar o máximo valor de resíduo de saída.
maxResiMat = 0; 
                % variável para aramzenar o máximo valor de resíduo pelo 
                % mínimos quadrados do matlab
iteMMQ = 0; % variável para identificar em que partição ocorrerá o max.resi
iteMMQMat = 0;
for i = 1 : tamCan(1,1)
   soma = somCanais(cana(i,:), compo, 60, perce2); 
                                                   % soma canais na
                                                   % partição em estudo 
   somComp(i,:) = soma;                             
   somTotEsc = somCanais(cana(i,:), newTot, 60,perce1); 
                                                        % soma das
                                                        % contagens
                                                        % espectrais totais
                                                        % na partição em
                                                        % estudo. 
                                                     
   somTot(i,1) = somTotEsc;
   mat = [somRef ; soma; 1 1 1]; 
                                % constroi a matriz contendo a soma de
                                % contagens espectrais nas partições de
                                % referência e na partição em estudo no
                                % laço 'for'.
   matTot = [somTotRef; somTotEsc; 1]; 
                                      % constroi a matriz contendo a soma
                                      % de contagens espectrais totais na
                                      % partição de referência e na
                                      % partição em estudo.
   perApro = (((mat)' * mat)^(-1)) * (mat)' * matTot;
                                                     % realiza a aproxima
                                                     % ção pelos mínimos
                                                     % quadrados. 
   opts = optimoptions(@lsqlin, 'Display', 'off'); 
                                                  %opções para a
                                                  %aproximação pelos
                                                  %mínimos quadrados do
                                                  %matlab dado na linha
                                                  %seguinte. 
   x = lsqlin(mat, matTot, mat, matTot,[],[],[],[],[],opts);
   dif = abs(sum(mat(1:4,:) * perApro  - matTot(1:4) ));
                                                        % calcula o resíduo
                                                        % entre os valores
                                                        % de integral
                                                        % abaixo da curva
                                                        % determinado pelos
                                                        % mínimos quadrados
                                                        % e a integral
                                                        % abaixo da curva
                                                        % de espectro total
   diAprMat = abs(sum(mat(1:4,:) * x  - matTot(1:4) ));
                                                        % Mesmo passo da
                                                        % linha anterior,
                                                        % só que com o
                                                        % método dos
                                                        % mínimos quadrados
                                                        % do matlab. 
   resid(i,1) = dif; 
   resid2 (i,1) = diAprMat;
   if dif > maxResi
       maxResi = dif;
       iteMMQ = i;
   end
        % verifica que partição tem máximo resíduo, contando o método de
        % aproximação dos mínimos quadrados na linha 87
   
        
   if diAprMat > maxResiMat
       maxResiMat = diAprMat;
       iteMMQMat = i;
   end
        % mesma idéia da condição que se inicia na linha 115, só que
        % utilizando o método dos mínimos quadrados do matlab. 
        
   temp = struct('dif', dif, 'difMat', diAprMat,'somComp',soma,...
       'somTotEsc',somTotEsc,'maxResi',maxResi,'maxResiMat',diAprMat,...
       'iteMMQ',iteMMQ,'iteMMQMat', iteMMQMat);
   retorno{i,1} = temp;
end
end

