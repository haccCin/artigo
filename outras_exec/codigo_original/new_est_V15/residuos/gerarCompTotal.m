function  gerarCompTotal
%GERARCOMPTOTLA Summary of this function goes here
%   Detailed explanation goes here

load dados.mat;

%grafico dos compostos
graficoDif2((dat{1,1}(:,2:end)), 'compostos_mod', {'Am';'Co'; 'Cs'; 'Na'},...
    [0.2 0.5 0.2 0.1], [0 0 0 0], 'Compostos', 'Canais', 'log contagens');

%grafico do total 

k = dat{1,1}(:,2:end);

k(:,1) = 0.2 * k(:,1);
k(:,2) = 0.5 * k(:,2);
k(:,3) = 0.2 * k(:,3);
k(:,4) = 0.1 * k(:,4);
total  = k(:,1) + k(:,2) + k(:,3) + k(:,4);   

graficoDif2(total, 'total_mod', {'Total'},[1], [0], 'Total', 'Canais', ...
    'log Total');

end

