function [matOrd] = ordPart(mat)
%ORDPART Summary of this function goes here
%   Detailed explanation goes here

tamMat = size(mat);
indMin = 0;
min = +Inf;
for i = 1 :tamMat(1,1) - 1
    for j = i+1 :tamMat(1,1)
        if mat(i,1) > mat(j,1)
            temp = mat(i,:);
            mat(i,:) = mat(j,:);
            mat(j,:) = temp;
        end
    end
end
matOrd = mat;
end

