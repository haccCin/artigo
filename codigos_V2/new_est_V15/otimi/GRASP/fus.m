function [ result ] = fus( mat1, mat2, newTot, comp,...
    canais, partEsc, iden, perce, ref, col, partMex, estPe)
%FUS Summary of this function goes here
%   Detailed explanation goes here

%% Função para fundir duas partições, dadas como entrada nos parâmetros.

% Função para fundir duas partições dadas como parâmetros de entrada. Essa
% fusão ocorrerá. as duas partições são disjuntas e tentar-se-á definir uma
% nova partição a partir das duas partições disjuntas. 


if iden == 0
    % vetor com o canal excluido 
    channels = mat1;
    
    % vetor inteiro.
    matComp = mat2;
    
    % copia do vetor de contagem espectra.
    copComp = comp;
    
    % copia do vetor espectral total.
    copTot = newTot;
    tamChan = size(matComp);
    
    for i = 1 : tamChan(1,1)
        
        % se o canal estiver presente em matComp e ausente em channels
        if isempty(find(channels == matComp(i,1),1))
            canal = matComp(i,1);
            copTot(canal,1) = -1;
            copComp(canal,:) = -1;
        end
    end
    
    % redefine a partição.
    part = defPart(matComp(1,1), matComp(end,1), copTot, copComp, ...
        canais, partEsc, perce, ref, col, partMex, estPe);
    ch = mat1;
    
    % variável de retorno.
    result = struct('part',part, 'tot', copTot, 'comp',copComp,'ch',...
        ch);
else
    % copia do vetor de contagem espectral elementar
    copComp = comp;
    
    % copia do vetor de contagem espectral total.
    copTot = newTot;
    
    % matriz de compotos. 
    matComp = mat1;
    valor = matComp(1,1);
    parou = false;
    while parou == false
        if isempty(find(matComp ==  valor,1)) && valor <= matComp(end,1) 
            canal = valor;
            copTot(canal,1) = -1;
            copComp(canal,:) = -1;
        end 
        if valor > matComp(end,1)
            parou = true;
        end
        valor = valor + 1;
    end
    part = defPart(matComp(1,1), matComp(end,1), copTot, copComp, ...
        canais, partEsc , perce, ref, col, partMex, estPe);
    ch = mat1;
    result = struct('part',part, 'tot', copTot, 'comp',copComp,'ch',...
        ch);
end
end

