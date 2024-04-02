function [ parou ] = quite( lista, built, perce )
%QUITE Summary of this function goes here
%   Detailed explanation goes here

%% Função para determinar o quão diferente são duas soluções

%  Função para determinar o quanto duas funções construídas são diferentes
%  uma da outra. Os paraêmtros de entrada são a lista e uma das soluções, 
%  e o quanto,
%  em termos percentuais, se deseja que essas soluções sejam
%  diferentes. A métrica utilizada para indicar o quanto a solução
%  construída difere em relação às soluções que estão inseridas na lista 
%  será o valor percentual do total aproximado e o total real.
%  Parâmetros de entrada: A lista do GRASP, e a solução cosntruída. O
%  retorno será um booleando indicado 'true' para uma solução ser
%  diferentes de todas as outras inseridas na lista, e 'false' para um
%  solução que não é suficientemente diferente de todas as outras inseridas
%  na lista. isso no que diz respeito à solução escolhida. Apenas declarar
%  como completamente diferente as soluções construídas se
%  difx(totAprox,totOrigin) (a diferença entre o total aproximado e o total
%  original para a solução construída) for maior que um percentual de
%  Lista{i,1}dif(totAprox,totOrigin) (a diferença entre o total aproximado
%  e o total original para cada elemento da lista). Então, esse percentual 
%  também será um parâmetro de entrada do algoritmo. Lembrando que em
%  'built', a partição escolhida será a que estiver na primeira posição das
%  partições. 

difEsc = metrica(built);
j = 1;
parou = false;
tamLista = size(lista);
if ~isempty(lista{1,1})
    parou = false;
    while parou == false &&  j <= tamLista(1,1) && ~isempty(lista{j,1}) 
        difEle = metrica(lista{j,1});
        d = max(difEsc,difEle);
        e = min(difEsc,difEle);
        div = e/d;
        if (abs(div) > (1-perce))
            parou = true;
        end
        j = j + 1; 
    end
end
end

