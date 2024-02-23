%% SMALL WORLD NETWORK

clc
clear
close all

% Genera una rete complessa di dimensione casuale tra 10 e 200
n = randi([10, 200]);
A = smallw(n, 3, 0.1); % Usa la funzione smallw per generare la rete

% Stampa il numero di nodi e archi
fprintf('Numero di nodi: %d\n', n);
fprintf('Numero di archi: %d\n', nnz(A)/2);

% Crea il grafo e visualizza la rete
G = graph(A);
plot(G);

% Menu di scelta per l'indice di centralità
prompt = 'Scegli un indice di centralità:\n1. Degree centrality\n2. Closeness centrality\n3. Betweenness centrality\n4. Eigenvector centrality\n5. PageRank\n6. Exponential subgraph centrality\n7. Resolvent subgraph centrality\n8. Katz centrality\n';
choice = input(prompt);

% Chiede all'utente quanti nodi importanti vuole individuare
m = input('Quanti nodi importanti vuoi individuare? ');

% Calcola l'indice di centralità in base alla scelta dell'utente
switch choice
    case 1
        centrality_values = centrality(G, 'degree');
    case 2
        centrality_values = centrality(G, 'closeness');
    case 3
        centrality_values = centrality(G, 'betweenness');
    case 4
        centrality_values = centrality(G, 'eigenvector');
    case 5
        centrality_values = centrality(G, 'pagerank');
    case 6
        [i, centrality_values] = exp_sub_centr(A, m);
    case 7
        [i, centrality_values] = res_sub_centr(A, m);
    case 8
        [i, centrality_values] = katz_centr(A, m);
end

% Stampa gli indici dei nodi più importanti e il loro valore di centralità
[~, idx] = sort(centrality_values, 'descend');
important_nodes = idx(1:m);
fprintf('Nodi importanti:\n');
disp(important_nodes);
fprintf('Valori di centralità:\n');
disp(centrality_values(important_nodes));
