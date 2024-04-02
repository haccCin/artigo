function [ pico ] = picos( primeDeri, segunDeri )
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

tamPri = size(primeDeri);
for i =1 : tamPri(1,2)
    maxPico = 0;
    for j = 1 : tamPri(1,1)
        if (j < tamPri(1,1)-1) && ((primeDeri(j+1,i)<0 ...
                && primeDeri(j,i)>=0))...
                && (segunDeri(j,i)<0) ...
                && (abs(primeDeri(j+1,i)-primeDeri(j,i))> maxPico) && ...
                (j~=1)
                        % irá localizar um pico se a primeira derivada
                        % mudar de sinal; se a segunda derivada for
                        % negativa e se a taxa de variação da primeira
                        % derivada for máxima no canal. 
            
            pico(1,i) = j; 
                            % variável que irá trazer os valores de canal 
                            % de pico de cada um dos compostos, na primeira
                            % linha, com os valores de taxa de variação
                            % para cada um dos picos na segunda linha. 
            maxPico = abs(primeDeri(j+1,i)-primeDeri(j,i));
            pico(2,i) = maxPico;
        end
    end
end
pont = fopen('aa_loc_pic_comp','a');
                                     % Aqui, o arquivo 'aa_loc_pic_comp' 
                                     % fornece a localização do canal 
                                     % onde o pico se encontra para cada um
                                     % dos compostos. 
impressao(pont, pico);
fclose(pont);
end

