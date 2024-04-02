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
    set(gca,'FontSize',22.5)
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
title(titulo,'fontsize', 26);                        
xlabel(xlab,'fontsize', 24);                                       
ylabel(ylab,'fontsize', 24); 
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

legend(strLegen, 'fontsize', 20, 'location','southeast');                                 
                                                        % criação da
                                                        % legenda do
                                                        % gráfico

                                                        
grid on;
orient('landscape');
pala = strcat(salvar,'.pdf');
print(pala,'-dpdf','-bestfit'); 
% pala2 = strcat(salvar, '.png');
% saveas(gcf,pala);
% saveas(gcf, pala2);

end

