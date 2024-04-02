function  graficoDif( BKEntra,salvar,legenda,chutes,titulo,xlab,ylab)
%GRAFICO Summary of this function goes here
%   Detailed explanation goes here

%função para plotagem dos valores de background. O parâmetro de entrada
%constará o parâmetro ('BKEntra'), que constará os valores de estimação de
%background para todas as linhas, que representam os canais. Cada coluna de
%('BKEntra') contém o valor de background para cada um dos compostos da
%variável ('BKDeter') e ('BKDeter') advindos da chamada da função 'back'.


%%
cores = ['r','g','m','c','k','y','c'];               
                                                      % paleta de cores.

%%

tamBK = size(BKEntra);                                % tamanho da entrada


%%
f = [1:tamBK(1,1)];   
                                                      % Matriz contendo o 
                                                      % número de ordem de
                                                      % cada um dos canais.
%%
for u = 1 :  tamBK(1,2)
    g = log((BKEntra(:,u)));                             
    plot(f,g,cores(1,u));                             
    hold on;                                          
end
                                                      % trecho de código on
                                                      % de irá ocorrer a
                                                      % plotagem do gŕafico
                                                      % A plotagem irá
                                                      % ocorrer para cada
                                                      % uma das colunas da 
                                                      % entrada, em função
                                                      % do número de ordem
                                                      % do canal.
                                                      
%% 

div1 = tamBK(1,1);
div2 = max(BKEntra(:));
div3 = min(BKEntra(:));

% arredondamento dos valores
valo1 = round(div1,3);
valo2 = round(div2,10);
valo3 = round(div3,10);

hold off;                                              
title(titulo,'fontsize', 18); 
xlabel(xlab,'fontsize', 16);                                       
ylabel(ylab,'fontsize', 16); 
                                                      % Geração dos títulos
                                                      % do gráfico. Label
                                                      % horizontal descrito
                                                      % como canal, e o ver
                                                      % tical descrito como
                                                      % logaritmo do
                                                      % background. 


%% 
tamLegen = size(legenda);
strLegen = cell(1,tamBK(1,2)); 
ponteiro = 1;
for n = 1 :tamLegen(1,1)                              
    strAconc = int2str(n); 
    if ponteiro <= tamLegen(1,1)
        chute1 = num2str(chutes(1,n));
        ponteiro = ponteiro + 1;
    else
       chute1 = 1; 
    end
    compostoAtual = strcat(legenda{n,1},'-',chute1);
    strLegen{1,n} = compostoAtual;
end

                                                      % Trecho de código
                                                      % para criar a
                                                      % legenda do gráfico.


%%

legend(strLegen, 'fontsize', 16);                        % criação da
                                                        % legenda do
                                                        % gráfico
pos = get(gca, 'Position');
pos(1) = 0.055;
pos(3) = 0.9;
set(gca, 'Position', pos);
set(gca,'XTick',0:round((valo1+0.2*valo1)/(10),0):tamBK(1,1));


grid on;
orient('landscape');
palaPDF = strcat(salvar,'port');
print(palaPDF,'-dpdf','-bestfit');  
end

