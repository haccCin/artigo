function [ P ] = dire(No_of_Bits)
%DIRECOES Summary of this function goes here
%   Detailed explanation goes here

% função para determinar o número de direções. 
A = [-1 0 1];
P = permn(A,No_of_Bits);



end

