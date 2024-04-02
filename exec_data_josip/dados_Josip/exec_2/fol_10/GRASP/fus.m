function [ result ] = fus( mat1, mat2, newTot, comp,...
    canais, partEsc, iden, perce, ref, col, estPe)
%FUS Summary of this function goes here
%   Detailed explanation goes here

%% Função para fundir duas partições, dadas como entrada nos parâmetros.

% Função para fundir duas partições dadas como parâmetros de entrada. Essa
% fusão ocorrerá. as duas partições são disjuntas e tentar-se-á definir uma
% nova partição a partir das duas partições disjuntas. 


if iden == 0
    channels = mat1;
    matComp = mat2;
    copComp = comp;
    copTot = newTot;
    tamChan = size(matComp);
    for i = 1 : tamChan(1,1)
        if isempty(find(channels == matComp(i,1),1))
            canal = matComp(i,1);
            copTot(canal,1) = -1;
            copComp(canal,:) = -1;
        end
    end
    part = defPart(matComp(1,1), matComp(end,1), copTot, copComp, ...
        canais, partEsc, perce, ref, col, estPe );
    ch = mat1;
    result = struct('part',part, 'tot', copTot, 'comp',copComp,'ch',...
        ch);
else
    copComp = comp;
    copTot = newTot;
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
        canais, partEsc , perce, ref, col, estPe);
    ch = mat1;
    result = struct('part',part, 'tot', copTot, 'comp',copComp,'ch',...
        ch);
end
end

