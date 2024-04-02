function [minRes, minDif] = divMetGrasp( perc, resi, dif, condi, ...
    minRes, minDif)
%DIVMETCGRASP Summary of this function goes here
%   Detailed explanation goes here

% função que irá escrever os valores de percentuais associados a um
% determinada métrica menor que 'ref'. As métricas são os valores de
% contagens espectrais asspciados a cada uma das aproximações de compostos
% por diferentes métodos contidos na função 'data'. Entre os métodos,
% pode-se citar: Métodos dos mínimos quadrados, método ART, método 'z' do
% matlab. Dada uma métrica, será impressa os valores de frações percentuais
% e condicionamento da matriz associada a melhora da métrica. As entradas
% são: O valor 'ref' de referência que será buscado como meta; os valores
% de frações, e será impresso o valor associado à métrica; o arquivo 'arq'
% que deve ser escrito, e que foi inicializado na chamada da função
% principal 'CGrasp'; e o número de condicionamento associado à essa
% solução. 
tamPerc = size(perc);
if tamPerc(1,2) < 10
    keyboard;
end
tamRes = size(resi);
for i = 1 : tamRes(1,2)
    if resi(1,i) < minRes(1,i)
        if i == 1 && (any(perc(:,4) < 0) == 0)
            file1 = fopen('aarqMelResiMMQGra','a');
            impressao(file1, [perc(:,4)' resi(1,i) log(condi)]);
            fclose(file1);
            minRes(1,i) = resi(1,i);
        end
                    % verifica se a primeira posição da matriz de resíduos
                    % contendo o mesmo para difentes métodos é menor que o
                    % valor contendo o ponteiro para o resíduo associado. 
                    
        if i == 2 && (any(perc(:,5) < 0) == 0)
            file2 = fopen('aarqMelResiZGra','a');
            impressao(file2, [perc(:,5)' resi(1,i) log(condi)]);
            fclose(file2);
            minRes(1,i) = resi(1,i);
        end
        if i == 3 && (any(perc(:,9) < 0) == 0)
            file3 = fopen('aarqMelResiART1Gra','a');
            impressao(file3, [perc(:,9)' resi(1,i) log(condi)]);
            fclose(file3);
            minRes(1,i) = resi(1,i);
        end
        if i == 4 && (any(perc(:,10) < 0) == 0)
            file4 = fopen('aarqMelResiARTGra','a');
            impressao(file4, [perc(:,10)' resi(1,i) log(condi)]);
            fclose(file4);
            minRes(1,i) = resi(1,i);
        end
    end
    if abs(dif(1,i)) < minDif(1,i) 
        if i == 1 && (any(perc(:,4) < 0) == 0)
            file5 = fopen('aarqMelDifMMQGra','a');
            impressao(file5, [perc(:,4)' dif(1,i) log(condi)]);
            fclose(file5);
            minDif(1,i) = dif(1,i);
        end
        if i == 2 && (any(perc(:,5) < 0) == 0)
            file6 = fopen('aarqMelDifZGra','a');
            impressao(file6, [perc(:,5)' dif(1,i) log(condi)]);
            fclose(file6);
            minDif(1,i) = dif(1,i);
        end
        if i == 3 && (any(perc(:,9) < 0) == 0)
            file7 = fopen('aarqMelDifART1Gra','a');
            impressao(file7, [perc(:,9)' dif(1,i) log(condi)]);
            fclose(file7);
            minDif(1,i) = dif(1,i);
        end
        if i == 4 && (any(perc(:,10) < 0) == 0)
            file8 = fopen('aarqMelDifARTGra','a');
            impressao(file8, [perc(:,10)' dif(1,i) log(condi)]);
            fclose(file8);
            minDif(1,i) = dif(1,i);
        end
    end
end
end

