function [ valor4,resul ] = metrica( est )
%METRICA Summary of this function goes here
%   Detailed explanation goes here

%% função para calcular a métrica de para comparação de soluções

% Essa função irá calcular a métrica para comparação de qualidade de
% soluções. Essa qualidade será verificada em função da soma de resíduo de
% aŕeas para cada uma das partições, tanto a de escolha como a partição de
% referência. A variável de entrada será uma estrutura 'est' contendo as
% constagens espectrais totais para cada uma das partições. Será calculada a
% diferença de constagens esptectrais em cada uma das partições, e somada.
% O retorno da função será essa soma das diferenças de contagens espectrais
% nas partições.


% calculando o espectro estimado:
% qtdPart = size(est{1,1});
% for i = 1 : qtdPart(1,1)
%     if est{}
%     canais = est
% end


tamEst = size(est{3,1});
valor1 = 0;
valor2 = 0;
valor3 = 0;
valor4 = 0;
valor5 = 0;
valor6 = 0;
valor7 = 0;
valor8 = 0;
valor9 = 0;
valor10= 0;
valor11= 0;
valor12= 0;
valor13= 0;
valor14= 0;
valor15= 0;
for i = 1 : tamEst(1,1)
    x = (est{3,1}{i,1}.somAprPart);
    y = (est{3,1}{i,1}.somTot);
    z = (est{3,1}{i,1}.somLSQNonneg);
    j = (est{3,1}{i,1}.somLSQLin);
    m = (est{3,1}{i,1}.somAprPart2);
    p = (est{3,1}{i,1}.somLSQNonneg2);
    u = (est{3,1}{i,1}.somLSQLin2);
    %gi = (est{3,1}{i,1}.soSubartHCC);
    %ga = (est{3,1}{i,1}.soSubartHSC);
    ge = (est{3,1}{i,1}.soSubArtICC);
    gh = (est{3,1}{i,1}.soSubArtISC);
    %gu = (est{3,1}{i,1}.soAproxaartHCC);
    %gt = (est{3,1}{i,1}.soAproxaartHSC);
    gr = (est{3,1}{i,1}.soAproxaartICC);
    gw = (est{3,1}{i,1}.soAproxaartISC);
    dif1 = abs(x - y);
    dif2 = abs(z - y);
    dif3 = abs(j - y);
    dif4 = abs(m - y);
    dif5 = abs(p - y);
    dif6 = abs(u - y);
    %dif7 = abs(gi - y);
    %dif8 = abs(ga - y);
    dif9 = abs(ge - y);
    dif10 = abs(gh - y);
    %dif11 = abs(gu - y);
    %dif12 = abs(gt - y);
    dif13 = abs(gr - y);
    dif14 = abs(gw - y);
    valor1 = valor1 + dif1;
    valor2 = valor2 + dif2;
    valor3 = valor3 + dif3;
    valor4 = valor4 + dif4;
    valor5 = valor5 + dif5;
    valor6 = valor6 + dif6;
    %valor7 = valor7 + dif7;
    %valor8 = valor8 + dif8;
    valor9 = valor9 + dif9;
    valor10 = valor10 + dif10;
    %valor11 = valor11 + dif11;
    %valor12 = valor12 + dif12;
    valor13 = valor13 + dif13;
    valor14 = valor14 + dif14;
       
  
end
  resul = [valor1;valor2;valor3;valor4;valor5;valor6; valor9;valor10;...
        valor13;valor14];
end

