function [resul, metMinLG, minLG]=linkagem(start, target, canais, numMin,...
    passo, ref, col, estPe, partEsc, min, metMinSC2)
%LINKAGEM Summary of this function goes here
%   Detailed explanation goes here

% linkegem nos canais 
[linkChann, metMinLin1, minLi1] = link(start, target, canais, numMin, ref,...
    col, estPe, partEsc, min, metMinSC2);

% linkagem na altura. 
[resul, metMinLG, minLG] = linkAlt (linkChann, target, canais, numMin, ...
    passo, col, metMinLin1 ,minLi1);
end

