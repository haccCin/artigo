function [resul, minRes, minDif]=linkagem(start, target, canais, numMin,...
    passo, ref, col, minRes, minDif, estPe)
%LINKAGEM Summary of this function goes here
%   Detailed explanation goes here

[linkChann, minRes, minDif] = link(start, target, canais, numMin, ref, col,...
    minRes, minDif, estPe);
[resul, minRes, minDif] = linkAlt (linkChann, target, canais, numMin, passo, ...
    col, minRes, minDif);
end

