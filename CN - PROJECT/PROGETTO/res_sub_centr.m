%% RESOLVENT SUBGRAPH CENTRALITY
%
% DESCRIZIONE:
% La funzione res_sub_centr calcola la centralità del sottografo risolvente
% per un dato grafo G rappresentato dalla matrice di adiacenza A. 
% La centralità del sottografo risolvente valuta l'importanza di un nodo 
% considerando la somma dei cammini di lunghezza finita nel grafo,
% attribuendo un peso decrescente ai cammini più lunghi. 
% Inoltre, l'algoritmo utilizza la risolvente della matrice di adiacenza 
% per calcolare la centralità.
%
% INPUT:
%   - A: la matrice di adiacenza del grafo G;
%   - m: il numero di nodi, con il valore più alto di centralità, da
%        restituire;
%
% OUTPUT:
%   - i: vettore contenente gli indici dei nodi, con il valore più alto di centralità, ordinati per
%        centralità decrescente (i primi m valori più grandi);
%   - val: vettore contenente i valori di centralità corrispondenti ai nodi
%          presenti all'interno di i;

function [i, val] = res_sub_centr(A, m)

    % Numero di nodi nel grafo
    n = size(A, 1);

    % Scelta di alpha:
    % alpha < inv(max_eig), ma è preferibile utilizzare un valore , per 
    % alpha, statico che sia compreso tra 0 e 1/max_eig.
    alpha = 0.1;

    % Calcolo della risolvente della matrice di adiacenza
    % (I-alpha*A)^-1
    resolvent = inv(eye(n) - alpha * A);

    % Calcolo della centralità del sottografo risolvente
    centr_res = sum(resolvent, 2);

    % Ordinamento dei nodi per centralità decrescente
    [~, i] = sort(centr_res, 'descend');
    i = i(1:m);
    val = centr_res(i);

end
