%% TEMP_NET CON BROADCAST E RECEIVE DYNAMIC CENTRALITY
%
% DESCRIZIONE:
% Questo codice calcola la Broadcast Centrality e la Receive Centrality per
% una rete temporale rappresentata dal tensore T. Utilizza un parametro 
% alpha calcolato dinamicamente come l’inverso del massimo raggio spettrale
% tra tutte le matrici T(:,:,k). Infine, restituisce gli indici e i valori 
% degli m nodi più importanti, dove lgimportanza di un nodo è data dalla 
% somma delle sue centralità di broadcast e receive. 
%
% INPUT:
%   - T: tensore 3d contenente M matrici di adiacenza A[k];
%   - m: il numero di nodi, con il valore più alto di centralità, da
%        restituire;
%
% OUTPUT:
%   - i: vettore contenente gli indici dei nodi, con il valore più alto di
%        centralità;
%   - val: vettore contenente i valori di centralità corrispondenti ai nodi
%          presenti all'interno di i;

function [i, val] = temp_net(T, m)

    % Numero di "fette" temporali
    M = size(T, 3);  % Numero di matrici in T

    % Dimensione di ogni matrice A[k] presente in T
    n = size(T, 1);

    % Inizializzazione del vettore rho per memorizzare i raggi spettrali
    rho = zeros(1, M);

    % Calcolo del raggio spettrale per ogni matrice A[k]
    for k = 1:M
        rho(k) = max(abs(eig(T(:,:,k))));
    end

    % Calcolo di alpha come l'inverso del massimo raggio spettrale
    alpha = 0.1;
    
    % Inizializzazione del tensore 3D, Q, per la Broadcast Centrality
    Q = zeros(n, n, M);
    Q(:,:,1) = eye(n);  % Q[0] = I
    
    % Calcolo della Broadcast Centrality per ogni matrice A[k]
    for k = 2:M
        Q(:,:,k) = Q(:,:,k-1) * inv(eye(n) - alpha * T(:,:,k-1));
    end
    
    % Inizializzazione della matrice, r, per la Receive Centrality
    r = zeros(n, M);
    r(:,1) = ones(n, 1);  % r[0] = 1

    % Calcolo della Receive Centrality per ogni matrice A[k]
    for k = 2:M
        r(:,k) = (r(:,k-1)') * inv(eye(n) - alpha * T(:,:,k-1)');
    end
    
    % Calcolo degli indici e dei valori degli m nodi più importanti
    [val, i] = maxk(sum(Q(:,:,end), 2) + sum(r(:,end), 2), m);
end
