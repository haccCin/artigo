function impressaoVir( arquivo,matriz )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tamMat = size(matriz);
for i = 1 : tamMat(1,1)
    for j = 1 : tamMat(1,2)
        escri = strjoin(arrayfun(@(x) num2str(x),matriz(i,j),...
            'UniformOutput', false),',');
        fprintf(arquivo,escri);
        if j~= tamMat(1,2)
            fprintf(arquivo,',');
        end
    end
    fprintf(arquivo,'\n ');
end


end