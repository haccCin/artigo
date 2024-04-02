function box(dados, labX, labY, tit, salvar, colum, tam, custom, pos)
%% função para criar um boxplot dos dados 

% função para criar um boxplot dos dados. 'dados' serão os dados de entrada
% 'labX' serão os rótulos do eixo 'x', um cell contendo os rotulos de cada 
% coluna ...
% 'labY' será o label do eixo Y e 'title'
% será o título do boxplot. Os parêmetros de entrada na chamada da função
% necessitam estar enif coman == 1

tamDat = size(dados);
x = [];
g = [];
for i = 1 : tamDat(1,1)
    data = sort(dados{i,1}(:,colum));
    tamX = size(data);
    for u = 1 : (ceil(tam * tamX(1,1)))
        if colum==5 
            x = [x;data(u,1)];
            g = [g;repmat(labX{1,i},[size(data(u,1)),1])]; 
        end
        if  colum==6 
            x = [x;data(u,1)];
            g = [g;repmat(labX{1,i},[size(data(u,1)),1])]; 
        end
        if colum ~= 5 && colum ~=6
            x = [x;data(u,1)];
            g = [g;repmat(labX{1,i},[size(data(u,1)),1])]; 
        end
    end
end
boxplot(x,g);
set(gca, 'FontSize', 22);
pos1 = get(gca, 'Position');
pos1(1) = 0.0992;
pos1(3) = 0.9;
set(gca, 'Position', pos1);
% hax = gca;
% getXlab = get(hax, 'Xlabel');
% getYlab = get(hax, 'Ylabel');
% set(getXlab,'FontSize', 28);
% set(getYlab,'FontSize', 16);
if custom ~= 0
    tamPos = size(pos);
    for y = 1 : tamPos(1,1)
        lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
        set(lines((-pos + tamDat(1,1)+1),1), 'Color', 'g');
    end
end
grid on;
ylabel(labY,'fontsize', 24);
title(tit,'fontsize', 26);
orient('landscape');
palaPDF = strcat(salvar,'box');
print(palaPDF,'-dpdf','-bestfit');

end