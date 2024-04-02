function  org
%ORG Summary of this function goes here
%   Detailed explanation goes here
% função para obtenção dos dados de icaro em uma estrutura de dados única.
% percentuais de total 1
% water = 495
% oil = 171
% air = 334
% percentuais de total 2
% water = 436
% oil = 170
% air = 394
ai = load('air1000_less5.csv');
wa = load('water1000_less5.csv');
oi = load('oil1000_less5.csv');
to1 = load('total1.csv');
to2 = load('total2.csv');

dat1 = [];
dat2 = [];
dat3 = [];
dat4 = [];
dat5 = [];
dat6 = [];

libra = {ai ; wa ; oi};
daGer = {dat1;dat2;dat3;dat4;dat5;dat6};

tamDat = size(ai);

for i = 1 : tamDat(1,2)
    for j = 1 : 3
       daGer{i,1}(:,j) = libra{j,1}(:,i);
    end
    daGer{i,1}(:,j+1) = to1;
    daGer{i,1}(:,j+2) = to2;
end
save daGer; 
end

