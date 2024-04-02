function [ val ] = envelo( compNor, total, percen )
%ENVELO Summary of this function goes here
%   Detailed explanation goes here


tamCom = size(compNor);
tamPerce = size(percen);
val = cell(2,1);
for i = 1 : tamPerce(1,2)
    for j = 1 : tamCom(1,2)
        for k = 1 : tamCom(1,1)
            desc = (total(k,1))/(percen(1,i)) - ...
                ((1-percen(1,i))/(percen(1,i)))*(compNor(k,j));
            val{i,1}(k,j) = desc; 
        end
    end
end

end

