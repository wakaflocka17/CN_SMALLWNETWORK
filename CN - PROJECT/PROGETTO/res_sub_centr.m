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

    % Vettore di n righe, necessario, per memorizzare le diverse centralità
    % di Katz ottenute
    x = ones(n, 1);
    
    % Calcolo dell'autovalore con massima magnitudine (o più grande)
    lambda = eigs(A, 1, 'largestabs');

    % Calcola il valore assoluto dell'autovalore precedente
    rho = abs(lambda);

    % Scelta di alpha:
    % alpha < inv(max_eig), ma è preferibile utilizzare un valore , per 
    % alpha, statico che sia compreso tra 0 e 1/max_eig.
    alpha = 0.9/rho;

    for i=1:n
        % Genero il vettore e_i di n righe, necessario, per calcolare il sistema di
        % Katz; questo, ad ogni iterazione, rappresenta l'i-esima colonna
        % dell'Identità (I).
        e_i = zeros(n, 1);

        % L'i-esimo elemento viene impostato a 1 ad ogni iterazione; si fa
        % ciò per selezionare poi, successivamente, l'i-esimo nodo da
        % valutare.
        e_i(i) = 1;
    
        % Calcolo della risolvente della matrice di adiacenza
        % (I - alpha * A)^-1 * e_i
        y = inv(eye(n) - alpha * A) * e_i;
        
        x(i) = y(i);
    end

    % Ordinamento dei nodi per centralità decrescente
    [~, i] = sort(x, 'descend');
    i = i(1:m);
    val = x(i);

end
