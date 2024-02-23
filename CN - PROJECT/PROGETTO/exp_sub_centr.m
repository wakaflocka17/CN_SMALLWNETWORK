%% EXPONENTIAL SUBGRAPH CENTRALITY
%
% DESCRIZIONE:
% La funzione exp_sub_centr calcola la centralità del sottografo 
% esponenziale, per un dato grafo G rappresentato dalla matrice di 
% adiacenza A. La centralità del sottografo esponenziale
% valuta l'importanza di ogni nodo considerando tutti i possibili percorsi 
% all'interno del grafo, attribuendo pesi crescenti ai percorsi più lunghi.
% Inoltre, l'algoritmo utilizza l'esponenziale della matrice di adiacenza 
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

function [i, val] = exp_sub_centr(A, m)

    % Calcolo della centralità esponenziale
    % expm(A) è definita come la serie di Taylor:
    % expm(A) = I * A * A^2/2! * [...] * A^n/n!
    centr_exp = expm(A) * ones(size(A, 1), 1);

    % Ordinamento dei nodi per centralità decrescente
    [~, i] = sort(centr_exp, 'descend');
    i = i(1:m);
    val = centr_exp(i);

end