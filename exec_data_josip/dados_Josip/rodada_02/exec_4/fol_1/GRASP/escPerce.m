function [ newMini ] = escPerce( est, minimos, metCalc )
%ESCPERCE Summary of this function goes here
%   Detailed explanation goes here

percen = est{4,1}; sizePercen = size(est{4,1});
newMini = minimos;
if metCalc(1,1) < (minimos(1,1))
    if ~any(percen(:,1) <= 0)
        arqPerce = fopen('aarqPerce','a');
        impressao(arqPerce, [(percen(:,1))' metCalc(1,1)...
           log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerce);
        newMini(1,1) =  metCalc(1,1);
    end
end
if metCalc(2,1) < (minimos(2,1))
    if ~any(percen(:,2) <= 0)
        arqPerceLSQLin = fopen('aarqPerceLSQLin','a');
        impressao(arqPerceLSQLin, [(percen(:,2))' metCalc(2,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceLSQLin);
        newMini(2,1) =  metCalc(2,1);
    end
end
if metCalc(3,1) < (minimos(3,1))
    if ~any(percen(:,3) <= 0)
        arqPerceLSQNonneg= fopen('aarqPerceLSQNonneg','a');
        impressao(arqPerceLSQNonneg, [(percen(:,3))' metCalc(3,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceLSQNonneg);
        newMini(3,1) =  metCalc(3,1);
    end
end
if metCalc(4,1) < (minimos(4,1))
    if ~any(percen(:,4) <= 0)
        arqPerceAprPart2= fopen('aarqPerceAprPart2','a');
        impressao(arqPerceAprPart2, [(percen(:,4))' metCalc(4,1)...
           log(cond(est{1,1}{4,1}.matSomAprox)) ]);
        fclose(arqPerceAprPart2);
        newMini(4,1) =  metCalc(4,1);
    end
end
if metCalc(5,1) < (minimos(5,1))
    if ~any(percen(:,5) <= 0)
        arqPerceLSQLin2 = fopen('aarqPerceLSQLin2','a');
        impressao(arqPerceLSQLin2, [(percen(:,5))' metCalc(5,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceLSQLin2);
        newMini(5,1) =  metCalc(5,1); 
    end
end
if metCalc(6,1) < (minimos(6,1))
    if ~any(percen(:,6) <= 0)
        arqPerceLSQNonneg2 = fopen('aarqPerceLSQNonneg2','a');
        impressao(arqPerceLSQNonneg2, [(percen(:,6))' metCalc(6,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceLSQNonneg2);
        newMini(6,1) =  metCalc(6,1);
    end
end
if metCalc(7,1) < (minimos(7,1))
    if ~any(percen(:,7) <= 0)
        arqPerceART21 = fopen('aarqSubArtICC','a');
        impressao(arqPerceART21, [(percen(:,7))' metCalc(7,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceART21);
        newMini(7,1) =  metCalc(7,1);
    end
end
if metCalc(8,1) < (minimos(8,1))
    if ~any(percen(:,8) <= 0)
        arqPerceART22 = fopen('aarqSubArtISC','a');
        impressao(arqPerceART22, [(percen(:,8))' metCalc(8,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceART22);
        newMini(8,1) =  metCalc(8,1);
    end
end
if metCalc(9,1) < (minimos(9,1))
    if ~any(percen(:,9) <= 0)
        arqPerceART25 = fopen('aarqAproxaArtICC','a');
        impressao(arqPerceART25, [(percen(:,9))' metCalc(9,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceART25);
        newMini(9,1) =  metCalc(9,1);
    end
end
if metCalc(10,1) < (minimos(10,1))
    if ~any(percen(:,10) <= 0)
        arqPerceART26 = fopen('aarqAproxaArtISC','a');
        impressao(arqPerceART26, [(percen(:,10))' metCalc(10,1)...
            log(cond(est{1,1}{4,1}.matSomAprox))]);
        fclose(arqPerceART26);
        newMini(10,1) =  metCalc(10,1);
    end
end

end


