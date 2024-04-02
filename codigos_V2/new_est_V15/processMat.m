function [matRet] = processMat(mat,perce)
%% função para calcular os valores de precisão dos valores de estimativa 
% função para calcular os valores de estimativas de precisão dos valores de
% entrada dos compostos. 

tamPerce = size(perce);
tamMat = size(mat);
matRet = zeros(tamMat(1,1), (2*tamMat(1,2) - 2));
pont = 1;
for k = 1 : ((2*tamPerce(1,2)))
    if mod(k,2) == 1 
        for l = 1 : tamMat(1,1)
            matRet(l,k+1) = abs((mat(l,pont) - perce(1,pont)))...
                / ((perce(1,pont)));
        end
        matRet(:,k) = mat(:,pont);
        pont = pont + 1;
    end
end

for l = (tamPerce(1,2) + 1) : tamMat(1,2)
    matRet(:,k+1) = mat(:,l);
    k = k + 1;
end
end

