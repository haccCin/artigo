function [newEst] = ART( matriz, chutes, matTotal, relax, maxIter)
%ART para solução de sistemas de equações
%   Detailed explanation goes here

%% ART-solução de sistemas de equações 

% Método para solução de sistemas de equações lineares. Envolve os
% seguintes passos (pixels parametrizados por 'j', j = 1, 2, ...N; raios
% parametrizados por 'i', i = 1, 2, ..., M). Parâmetros de entrada são:
% Matriz espectral contendo as contagens espectrais em cada uma das
% partições; 'chutes', contendo os valores de chutes iniciais; 'matTotal',
% contendo os valores de contagem espectral total para cada uma das
% partiçõs. 'relax' está compreendido entre 0 e 2 

% 1 - Criar uma matriz inicial com N elementos (número de pixels, no nosso 
% caso, o número de compostos, sendo as partições fazendo o papel do número
% de raios), sendo esses 'N' aleatórios ou nulos. Início da primeira
% iteração (k = 1)

% 2 - Calcular as projeções 'P'(i)' para todos os raios através da fórmula:

% \sum_{j=1}^{N}f'(j) \cdot W_{ij} = P'_{i}, i = 1, 2, 3, ..., M (raios).

% Nesse caso, quem será o valor inicial de f'(j)??

% 3 - Para cada raio 'i' (no caso, para cada partição) calcular a diferença
% entre a projeção original P(i) e a  reconstruída P'_{i}

% \delta P = P(i) - P'(i) 

% 4 - Calcular o somatório de todos os pesos ao longo de cada raio

% W_{i} = \sum_{j = 1}^{N}w^{2}_{ij}

% 5 - Obter a correção para cada raio 

%  \alpha_{i} = \dfrac{\deltaP_{i}}{W_{i}}

% 6 - Aplicar a correção a cada célula 'j' ao longo do raio 'i'.

% f'_{k}(j) = f'_{k-1}(j) + \lambda \cdot w_{ij} \cdot \alpha_{i}

% 7 - Repetir os passos 2 ao 6 para todos os raios (No casso, para todos os
% as partições)

% 8 - Achar a soma da convergênci de todos os pixels da imagem (No caso,
% compostos)

% \bigtriangleup f = \sum_{j=1}^{N} \dfrac{f'_{k} - f'_{k-1}}{f'_{k}}

% 9 - Finalizar a iteração 'k'.

% 10 - iterações são realizadas quando \bigtriangleup f chegar a um valor
% pré-estabelecido. Muitos autores estabelecem um critério de
% \bigtriangleup f <= 0,01%. caso o critério não tenha sido cumprido, uma
% nova iteração é iniciada no passo 2.

%% Dados para o passo 1
tamMat = size(matriz);
est = chutes;
parou  = false;
cont = 0;
while parou == false
    for h = 1 : tamMat(1,1)
        %% Passo 2- Projeções para um dado raio

        % Cálculo de todas as projeções. Na expressão matemática para esse 
        % passo, 'i' indexa raios, que no nosso caso, são as partições. E o 
        % 'j' indexa os pixels, no nosso caso, os compostos. 
        proj = zeros(tamMat(1,1),1);
        temp = 0;
        for k = 1 : tamMat(1,2)
            temp = temp + chutes(k,1) * matriz(h,k);  
        end
        proj = temp;
        

        %% passo 3 - Para raio arbitrário calcular a diferença 

        % Para cada raio calcular a diferença entre a projeção original e a
        % reconstruída. 

        dif = matTotal(h,1) - proj;
        

        %% passo 4 - Somatório de todos os pesos ao longo de raio arbirário 

        soma = 0;
        for g = 1 : tamMat(1,2)
            soma = soma + matriz(h,g);
        end
        somPe = soma;
        

        %% passo 5 - Obtendo a correção para cada partição
        % se essas correções forem negativas ??

        
        
        corr = dif / somPe;
        

        %% Passo 6 - Aplicando a correção composto j partição i

        newEst = zeros(tamMat(1,2),1);
        for q = 1 : tamMat(1,2)
            newEst(q,1) = est(q,1) + relax * matriz(h,q) * corr;
        end
    end
    %% passo 8 - Achar a soma da convergência dos compostos
    
    deltaConv = 0;
    for l = 1 : tamMat(1,2)
        deltaConv = deltaConv + (newEst(l,1) - est(l,1)) / (newEst(l,1));
    end
    est = newEst;
    if abs(deltaConv) < 0.0001 || cont > maxIter
        parou = true; 
    end
    cont = cont + 1;
   
    
end
end
