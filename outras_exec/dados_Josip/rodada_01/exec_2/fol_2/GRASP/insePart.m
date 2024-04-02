function [matPartOrd] = ordePart(matPart, canais)
% função para ordenar as partições

tamRef = size(matPart);
v = canais;
for h  = 1 : tamRef(1,1)
    if h<tamRef(1,1) && v(1,1)>matPart(h,1) && v(1,1)<matPart((h+1),1)  
        temp = [matPart([1:h], :); parEsc];
        matPartOrd = [temp; matPart([h+1], :)];
    end
    if (h == 1 && v(1,1) < matPart(h,1))
        matPartOrd = [v ; matPart];
    end
    if (h == tamRef(1,1) && v(1,1) > matPart(h,1))
        matPartOrd = [matPart;v];
    end
end   

end

