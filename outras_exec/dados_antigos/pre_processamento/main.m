function [dat_process, espec_tot]  = main
%MAIN Summary of this function goes here
%   Detailed explanation goes here

% o parâmetro 'perc_bck' mede o percentual de background adicionado ao
% total


load dados.mat

% os dados serão utilizados com os percentuais aplicados
dat_process = bib_mul(dados(:, (2:end)), [0.2 0.5 0.2 0.1]);

%o total é gerado com 1% adicionalmente para background 
espec_tot = ger_tot(dat_process, 1);
end

