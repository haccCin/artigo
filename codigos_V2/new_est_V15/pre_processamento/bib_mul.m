function [dat_convert] = bib_mul(dat, percen)
%BIB_MUL Summary of this function goes here
%   Detailed explanation goes here

%função para pre-processamento dos dados. O pre-processamento inclue a
%multiplicação das bilbiotecas pelas suas frações em peso, e posterior
%geração do total. 



tamDat = size(dat);
temp = zeros(tamDat(1,1), tamDat(1,2));
for i = 1 : tamDat(1,2)
    temp(:,i)  = dat(:,i) * percen(1,i);
end
dat_convert = [(1:tamDat(1,1))' temp];
end

