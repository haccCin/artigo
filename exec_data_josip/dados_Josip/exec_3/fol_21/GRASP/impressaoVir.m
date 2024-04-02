function impressaoVir( arquivo,matriz )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tamMat = size(matriz);
for i = 1 : tamMat(1,1)
    for j = 1 : tamMat(1,2)
        fprintf(arquivo,'%d,', matriz(i,j));
    end
    fprintf(arquivo,'\n ');
end


end