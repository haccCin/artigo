function [val] = difArea(input)
%DIFAREA Summary of this function goes here
%   Detailed explanation goes here

b = input{1,1};
q = input{2,1};
f = input{3,1};
v = input{4,1};
val = abs((b.somTot + q.somTot + f.somTot + v.somTot) - ...
          (b.somAprPart2 + q.somAprPart2 + f.somAprPart2 + v.somAprPart2));       
                              
end

