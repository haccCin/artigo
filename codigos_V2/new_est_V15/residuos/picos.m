function [ pic ] = picos( N, dados, primeDeri, segunDeri, canais )
%PICOS Summary of this function goes here
%   Detailed explanation goes here

%% Função para detecção dos picos.

% Função para detecção dos picos. A função tem como entrada os valores da
% primeira derivada que verifica o valor da variação dos compostos básicos.
% Se o valor da derivada mudar de sinal, provavelmente ocorre um máximo. O
% sinal da segunda derivada é usado para verificar a concavidade do pico.
% Se o sinal da segunda derivada for negativo, a concavidade é voltada para
% baixo.  Exclue-se o primeiro canal, pois esse está dando como pico para
% todos os compostos básicos. 
tamCan = size(canais);
tamPri = size(primeDeri);
tamDat = size(dados);
pic = zeros(2, tamDat(1,2));
for t = 1 : tamDat(1,2)
    max = 0;
    i = N - floor(N/2);
    while i <= (tamDat(1,1) - ceil(N/2))
        media = mean(dados((i-floor(N/2)): (i + floor(N/2)),t));
        desvio = std(dados((i-floor(N/2)): (i + floor(N/2)),t));
        if media + desvio > max && (i < tamPri(1,1)-1) && ((primeDeri(i+1,t)<0 ...
                && primeDeri(i,t)>=0))&& (segunDeri(i,t)<0) && (i~=1)
            pert = false;
            if ~ismember(i, pic)     
                for e = 1 : tamCan(1,1)
                    inter = [canais(e,1) canais(e,2)];
                    for w = 1 : tamDat(1,2)
                        provPic = pic(1,w);
                        if provPic >= inter(1,1) && provPic <= inter(1,2)
                            if i >= inter(1,1) && i <= inter(1,2)
                                pert = true;
                            end
                        end
                    end
                end
                if pert == false
                    pico = i ;
                    max = media + desvio;
                end
            else
                for u = 1 : tamCan(1,1) 
                    if i > canais(u,1) && i <= canais(u,2)
                        i = canais(u+1,1);
                    end
                end
            end
            i = i + 1;
        else
            i = i + 1;
        end
    end
    pic(1,t) = pico;
    pic(2,t) = max;
end

