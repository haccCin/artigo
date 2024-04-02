function [ constru, minRes, minDif] = construct(matPerc, somAprox ,x, fun,...
    dimen, h, minBox, maxBox, alpha, col, minRes, minDif)
%Construção de uma solução
%   Função que tratará da construção de uma solução. Parâmetros de entrada:
%   'x', valor advindo do passo inicial do GRASP;'fun': valor da função que
%   virá a partir do GRASP;'dimen': dimensionalidade do problema; 'h': grid
%   do problema; 'l','u': Minimo e maximo do box que conterá a solução
%   determinada; 'alpha': Valor de percentual para determinar se uma
%   solução entrará na lista de candidatos restrita. 

% dúvidas: Como fazer o lineSearch? Ao se salvar na RCL o valor da
% coordenada, salva-se também o valor de 'zj'? O que será a 'f()'?

%% Criação da matriz que determinará a dimensionalidade do problema:
% Valores de dimensionalidade a serem preenchidos em uma matriz.

S = zeros(dimen,1);
for i = 1 : dimen
    S(i,1) = i;
end

%% Número de direções em que a construção ocorrerá.

a = dire(dimen);  
%% Laço que executará até o valor máximo de dimensionalidade. 


pont2 = dimen;

while ~isempty(S)
    % irá setar os valores de máximo e mínimo
    min = + inf; % ponteiro de verificação para isnerção na lista.
    max = - inf; % ponteiro de verificação para inserção na lista. 
    zi = cell(1,1); % valor no ponto considerado.
    gi = cell(1,1); % valor da métrica no ponto considerado.     
    for i = 1 : dimen
        
        % Faz uma busca ao longo de uma determinada dimensão, deixando
        % as outras dimensões fixas. Procurará um valor que minimiza a
        % função 'fun' objetivo. Após encontrar esse valor, ele
        % determinará o valor da função objetivo nesse ponto. Se faz
        % necessário implementação do código 'lineSearch'. A
        % 'lineSearch' é executada para cada coordenada não fixa 'i',
        % enquanto que as outras coordenadas são mantidas fixas. O
        % valor 'zi' para a 'i'-ésima coordenada que minimiza a função
        % objetivo é salva, assim como também a função objetivo 'gi'. A
        % função 'lineSearch' irá simplesmente executar a função
        % 'deteralt' em um direção específica.
        
        if ~isempty(find(S(i,1),1))
                
            %% falta um parâmetro 
                
            % A chamada à função lineSearch deve receber o inbox de uma 
            % determinada direção. então, na chamada do lineSearch, já deve
            % ser passado os valores de máximo e mínimo de um determinada
            % direção. Provavelmente deve-se implementar uma função para o
            % cálculo dessas direções. 
                
            [partOut, somAproxOut, matPercOut, minRes, minDif]=...
                lineSearch(matPerc, somAprox, x, h, fun, col, a, minRes,...
                minDif);
                                    % vai realizar a busca em cada uma das
                                    % direções determinado pelo vetor 'a'.
            ziRe = {partOut; matPercOut(:,1); somAproxOut; matPercOut};
            zi{i,1} = ziRe;   
            metri = ziRe{3,1}{1,1}.somAprPart2 + ...
            ziRe{3,1}{2,1}.somAprPart2 + ...
            ziRe{3,1}{3,1}.somAprPart2 + ziRe{3,1}{4,1}.somAprPart2;
            gi{i,1} = metri;
            va = any(ziRe{4,1}(:,4)<0);
            if metri < min && va == 0
                min = metri;
            end
            if metri > max && va == 0
                max = metri;
            end
        end
        strSta = num2str(i);
        conca = strcat('dimen_construct_', strSta, '\n');
        fprintf(conca );
    end

    %% A partir daqui, cria-se a lista de candidatos restritos
    % Após a ' line search' ser executada para cada coordenada não fixa, 
    % a lista de restrita de candidatos que contém as coordendas não fixas
    % 'i' cujos 'gi' valores são menores que ou iguais a 'alpha*max +
    % (1-alpha)*min', onde 'max'e 'min' são o máximo são, respectivamente,
    % o máximo e o mínimo  valores de 'gi' sobre todas coordendas não fixas
    % de 'x', e [0,1] é um parâmetro definido pelo usuário. 
    
    RCL = 0;
    for k = 1 : pont2
        pont = 1; 
        bo = ~isempty(find(S(k,1) == k));
        if bo == 1 && gi{k,1} <= (1-alpha) * min + alpha * max
            RCL(pont,1) = k;
            pont = pont + 1;
            strSta = num2str(k);
            conca = strcat('inser_lista_construct_', strSta, '\n');
            fprintf(conca );
        end
        if RCL == 0
            RCL(1,1) = 1;
        end
        
    end
    
    
    %% Escolha da coordenada
    % A partir RCL, escolhe-se uma coordenada aleatoriamente, 'j' \in RCL, 
    % setar 'xj' igual a 'zj', e fixa-se coordenada 'j' de 'x'. Escolhendo
    % uma coordeanda neste caminho assegura-se a fase de construção.
    % Continuando-se esse procedimento até todas as 'n' coordenadas de ''x'
    % serem fixadas. 'x' é retornado a partir do passo de construção. 
    
    tamRCL = size(RCL);
    valAlea = randi([1 tamRCL(1,1)],1,1);
    constru = zi{RCL(valAlea),1};
%     var1 = constru{3,1}{1,1}.somAprPart2 + constru{3,1}{2,1}.somAprPart2+...
%         constru{3,1}{3,1}.somAprPart2 + constru{3,1}{4,1}.somAprPart2;
%     var2 = x{3,1}{1,1}.somAprPart2 + x{3,1}{2,1}.somAprPart2+...
%         x{3,1}{3,1}.somAprPart2 + x{3,1}{4,1}.somAprPart2;
%     arqEstconstruc = fopen('aarqConsInCgrasp','a');
%     impressao(arqEstconstruc,[var1 var2]);
%     fclose(arqEstconstruc);
    S(valAlea) = [];
    
end
[apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
    resApxArtIcc, resApxArtIsc, somPartZ, somPartArtIcc, somPartArtIsc] =...
    impress(matPercOut,  somAproxOut, partOut,'aarqConsInCgrasp');
end


