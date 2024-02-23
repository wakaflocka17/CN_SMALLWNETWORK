%% KATZ CENTRALITY
%
% DESCRIZIONE:
% La funzione katz_centr calcola la centralità, come se fosse un sistema
% lineare, di Katz per un grafo rappresentato dalla matrice di adiacenza A.
% Questa misura l'importanza di ogni nodo presente all'interno del grafo 
% considerando il numero di cammini che passano attraverso un dato nodo in 
% analisi, attribuendo un peso (in maniera dinamica) decrescente ai cammini
% più lunghi.
%
% INPUT:
%   - A: la matrice di adiacenza del grafo G;
%   - m: il numero di nodi, con il valore più alto di centralità, da
%        restituire;
%
% OUTPUT:
%   - i: vettore contenente gli indici dei nodi, con il valore più alto di 
%       centralità, ordinati per centralità decrescente (i primi m valori 
%       più grandi);
%   - val: vettore contenente i valori di centralità corrispondenti ai nodi
%          presenti all'interno di i;

function [i, val] = katz_centr(A, m)
    
    % Numero di nodi nel grafo
    n = size(A, 1);

    % Vettore di n righe che verrà utilizzato per calcolare il sistema di
    % Katz
    e_i = ones(n, 1);
    
    % Calcolo dell'autovalore con massima magnitudine (o più grande)
    lambda = eigs(A, 1, 'largestabs');

    % Calcola il valore assoluto dell'autovalore precedente
    rho = abs(lambda);

    % Scelta di alpha:
    % alpha < inv(max_eig), ma è preferibile utilizzare un valore , per 
    % alpha, statico che sia compreso tra 0 e 1/max_eig.
    alpha = 0.9/rho;

    % Calcolo di (I - alpha * A)^-1 * e_i
    val = inv(eye(n) - alpha * A) * e_i;

    % Ordinamento dei nodi per centralità decrescente
    [~, i] = sort(val, 'descend');
    i = i(1:m);
    val = val(i);

end

