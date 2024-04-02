function [ constru, metMin, minimo] = construct(matPerc, somAprox ,x, fun,...
    dimen, h,  alpha, col, metMin)
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

% nao perder a referenciacia de fun
minimo = fun;

% flag
flag = 7;

S = zeros(dimen,1);
for i = 1 : dimen
    S(i,1) = i;
end

%% Número de direções em que a construção ocorrerá.

a = dire(dimen);  

pont2 = dimen;

while ~isempty(S)
    % irá setar os valores de máximo e mínimo para a fixação de direção. 
    min = + inf; 
    max = - inf;
    
    % valor do domínio da função.
    zi = cell(1,1); 
    
    % valor da função, dada o domínio no comando anterior. 
    gi = cell(1,1);  
    
    for i = 1 : dimen
                      
        if ~isempty(find(S(i,1),1))
                
            % Busca ao longo de uma direção.    
            [partOut, somAproxOut, matPercOut, newMetMin, metMin]=...
                lineSearch(matPerc, somAprox, x, h, fun, col, a, metMin);
            
            % Parâmetros da partição. Posteriormente armazenada em um cell.
            ziRe = {partOut; matPercOut(:,1); somAproxOut; matPercOut};
            zi{i,1} = ziRe; 
            
            % verificando a solucao
            [metri, inpuEscPerce ] = metrica(ziRe);
            if metri < minimo && any(matPercOut(:,4) < 0) == 0
               minimo = metri; 
               constru = ziRe;
            end
            
            % impressao dos valores.
            cd ..;
            cd GRASP;
            metMin = escPerce( ziRe, metMin, inpuEscPerce, 7);
            cd ..;
            cd C_GRASP;
            
            % valor da função. 
            gi{i,1} = metri;
            
            % verifica se existe percentual negativo. 
            va = any(ziRe{4,1}(:,4)<0);
            
            % verificam os valores de máximo e mínimo. 
            if metri < min && va == 0
                min = metri;
            end
            if metri > max && va == 0
                max = metri;
            end
        end
        
        % impressão
        strSta = num2str(i);
        conca = strcat('**Construct_CGRASP_dimen_construct_', strSta, '\n');
        fprintf(conca );
        pause(1); 
    end

    %% A partir daqui, cria-se a lista de candidatos restritos
    % Após a ' line search' ser executada para cada coordenada não fixa, 
    % a lista de restrita de candidatos que contém as coordendas não fixas
    % 'i' cujos 'gi' valores são menores que ou iguais a 'alpha*max +
    % (1-alpha)*min', onde 'max'e 'min' são o máximo são, respectivamente,
    % o máximo e o mínimo  valores de 'gi' sobre todas coordendas não fixas
    % de 'x', e [0,1] é um parâmetro definido pelo usuário. 
    
    % inicia a lista de candidatos restritos. 
    RCL = 0;
    
    % procura ao longo de todas as direções.  
    for k = 1 : pont2
        pont = 1; 
        bo = ~isempty(find(S(k,1) == k));
        % se uma determinada direção obedece ao critério, inserido na lista.  
        if bo == 1 && gi{k,1} <= (1-alpha) * min + alpha * max
            RCL(pont,1) = k;
            pont = pont + 1;
            strSta = num2str(k);
            conca = strcat('**inser_lista_construct_CGRASP', strSta, '\n**');
            fprintf(conca );
            pause(1);
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
    
    % verifica o tamanho da lista
    tamRCL = size(RCL);
    
    % escolhe aleatoriamente um valor para indexar posição na lista
    valAlea = randi([1 tamRCL(1,1)],1,1);
    
    % trata como solução corrente
    constru = zi{RCL(valAlea),1};
    
    % apaga do vetor de direções a solução associada no comando anterior.
    S(valAlea) = [];
    
end

% imprime os percentuais e as métricas. 
[apxPart, toPart, pontNeg, condMatApx, resApxMMQ, resApxZ, ...
    resApxArtIcc, resApxArtIsc, somPartZ, somPartArtIcc, somPartArtIsc] =...
    impress(matPercOut,  somAproxOut, partOut,'aarqConsInCgrasp');

fprintf('****término_construção_CGRASP******\n');
pause(1);
end


