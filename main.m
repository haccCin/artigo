function [dat_process, espec_tot]  = main(dados)
%MAIN Summary of this function goes here
%   Detailed explanation goes here

% o parâmetro 'perc_bck' mede o percentual de background adicionado ao
% total




% os dados serão utilizados com os percentuais aplicados
dat_process_noise  = bib_mul(dados(:, (2:end)), [1 1 1 1]);
dat_process_temp = smoothdata(dat_process_noise(:,2:end),1);
dat_process = [dat_process_noise(:,1) dat_process_temp(:,1:end)];

%o total é gerado com 1% adicionalmente para background 
espec_tot = ger_tot(dat_process, 1);
end

