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
        A = [-9;-8;-7;-6;-5;-4;-3;-2];
        g =[pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))... 
            pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))...
            pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))...
            pic(1,(u-tamBK(1,2))) pic(1,(u-tamBK(1,2)))];
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
div1 = tamBK(1,1);
div2 = max(BKEntra(:));
div3 = min(BKEntra(:));

% arredondamento dos valores
valo1 = round(div1,3);
valo2 = round(div2,10);
valo3 = round(div3,10);
miV = -0.1;
maV = 0.1;


%limites do gráfico
% xlim([0 (valo1) + 0.05 * valo1]);
% xticks(0 : round((valo1+0.05*valo1)/(10),0) : round((valo1 + 0.05 * valo1),0));
% ylim([(valo3 - miV * valo3) (valo2 + maV * valo2)]);
% yticks(valo3 - 0.05*valo3:((valo2 + 0.05*valo2) - (valo3 - 0.05*valo3)) / ...
%     (10) : (valo2 + 0.05*valo2));
hold off;                                               
title(titulo,'fontsize', 22);                        
xlabel(xlab,'fontsize', 20);                                       
ylabel(ylab,'fontsize', 20);  
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

legend(strLegen, 'fontsize', 18, 'location','southeast');                       % criação da
                                                        % legenda do
                                                        % gŕafico 

                                                    
 
pos = get(gca, 'Position');
pos(1) = 0.055;
pos(3) = 0.9;
set(gca, 'Position', pos);
set(gca,'XTick',0:round((valo1+0.2*valo1)/(10),0):tamBK(1,1));


grid on;
orient('landscape');
palaPDF = strcat(salvar,'port');
print(palaPDF,'-dpdf','-bestfit');                                                       
                                                        
                                                        
% grid on;
% pala = strcat(salvar,'.pdf');
% saveas(gcf,pala);

end

