function  graficoDif2( BKEntra,salvar,legenda,chutes,pic, titulo, xlab, ...
    ylab)
%GRAFICO Summary of this function goes here
%   Detailed explanation goes here

%função para plotagem dos valores de background. O parâmetro de entrada
%constará o parâmetro ('BKEntra'), que constará os valores de estimação de
%background para todas as linhas, que representam os canais. Cada coluna de
%('BKEntra') contém o valor de background para cada um dos compostos da
%variável ('BKDeter') e ('BKDeter') advindos da chamada da função 'back'.


%%
cores = ['r','g','b','c','m','y','k'];               
                                                      % paleta de cores.

%%

tamBK = size(BKEntra);                                % tamanho da entrada


%%
f = [1:tamBK(1,1)];   
                                                      % Matriz contendo o 
                                                      % número de ordem de
                                                      % cada um dos canais.
%%
for u = 1 :  2*tamBK(1,2) 
     
    if u <= tamBK(1,2)
        g = log((BKEntra(:,u)));
        plot(f,g,cores(1,u));
    else
         A = [0;0.01;0.02;0.03;0.033;0.37;0.4;0.41];
         g =[pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))... 
             pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))...
             pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))...
             pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))];
%           A = [0.2 0.3 0.4 0.5];
%           g =[pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))... 
%                 pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))];
        plot(g, A, cores(1,u-tamBK(1,2)));
    end
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
hold off;                                              
title(titulo);                        
xlabel(xlab);                                       
ylabel(ylab);  
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

legend(strLegen);                                       % criação da
                                                        % legenda do
                                                        % gŕafico 
grid on;
pala = strcat(salvar,'.pdf');
pala2 = strcat(salvar,'.png')
saveas(gcf,pala);
saveas(gcf, pala2);

end

