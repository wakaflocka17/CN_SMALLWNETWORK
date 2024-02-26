%% SMALL WORLD NETWORK

clc
clear
close all

% Stampa, nella console, il numero di nodi e archi presenti
network = '<strong>SCELTA DELLA GENERAZIONE DELLA RETE</strong>\n1. Statica\n2. Dinamica\nInserisci qui la scelta: ';
network_choice = input(network);

switch(network_choice)
    case 1
        %##################################################################
        % GENERAZIONE STATICA DELLA RETE:
        %
        % Fissa il seed del generatore di numeri casuali
            rng(1);
        %
        % Genera una rete complessa di dimensione fissa
            n = 100;
            A = smallw(n, 3, 0.1);
        %
        %##################################################################
    
    case 2
        %##################################################################
        % GENERAZIONE DINAMICA DELLA RETE:
        %
        % Genera una rete complessa di dimensione casuale tra 10 e 200
        n = randi([10, 200]);
        A = smallw(n, 3, 0.1);
        %
        %##################################################################
    
    otherwise
        error('<strong>SCELTA NON CORRETTA DELLA RETE</strong>: RIAVVIARE LO SCRIPT!');
end

% Stampa, nella console, il numero di nodi e archi presenti
fprintf('\n\n<strong>NUMERO DI ARCHI E NODI TOTALI</strong>\n');
fprintf('Numero di nodi: %d\n', n);
fprintf('Numero di archi: %d\n\n\n', nnz(A)/2);

% Creazione del grafo e inizializzazione del vettore dei colori per i nodi
% trovati
G = graph(A);
node_colors = zeros(n, 1);

% Menu di scelta per l'indice di centralità; la scelta fatta viene salvata
% nella variabile su cui poi si baserà la scelta all'interno dello
% switch-case
menu = '<strong>INDICI DI CENTRALITA</strong>\n1. Degree Centrality\n2. Closeness Centrality\n3. Betweenness Centrality\n4. Eigenvector Centrality\n5. PageRank\n6. Exponential Subgraph Centrality\n7. Katz Centrality\n8. Resolvent Subgraph Centrality\nInserisci qui la scelta: ';
choice = input(menu);

% Chiede all'utente quanti nodi importanti vuole individuare
m = input('\n\n<strong>NODI IMPORTANTI DA INDIVIDUARE</strong>\nQuanti nodi importanti vorresti individuare?\nInserisci qui la quantità: ');

% Calcola l'indice di centralità in base alla scelta precedente
% fatta dall'utente
switch choice
    case 1
        centrality_values = centrality(G, 'degree');
        name = 'Degree Centrality';
    case 2
        centrality_values = centrality(G, 'closeness');
        name = 'Closeness Centrality';
    case 3
        centrality_values = centrality(G, 'betweenness');
        name = 'Betweenness Centrality';
    case 4
        centrality_values = centrality(G, 'eigenvector');
        name = 'Eigenvector Centrality';
    case 5
        centrality_values = centrality(G, 'pagerank');
        name = 'Pagerank Centrality';
    case 6
        [i, centrality_values] = exp_sub_centr(A, m);
        name = 'Exponential Subgraph Centrality';
    case 7
        [i, centrality_values] = katz_centr(A, m);
        name = 'Katz Centrality';
    case 8
        [i, centrality_values] = res_sub_centr(A, m);
        name = 'Resolvent Subgraph Centrality';

    otherwise
        error('<strong>SCELTA NON CORRETTA DELLA CENTRALITY</strong>: RIAVVIARE LO SCRIPT!');
end

% In questo caso per le funzioni built-in di matlab verrà eseguito
% l'ordinamento dopo aver ottenuto i valori di centralità; ed inseguito si
% estrarrà anche l'indice degli m valori trovati. Invece, ciò non accade
% per le funzioni create (Exp, Katz, etc.) perché l'ordinamento avviene già
% all'interno delle funzioni stesse.
if (choice >= 1 && choice <= 5)
    [~, i] = sort(centrality_values, 'descend');
    important_nodes = i(1:m);
    centrality_values = centrality_values(important_nodes);
else
    important_nodes = i;
end

node_colors(important_nodes) = centrality_values;

% Visualizzazione del grafo della rete e dei livelli di centralità dei nodi
figure('Name', 'CONGIU F. - RETE SMALLW');

subplot(1, 2, 1);
h = plot(G, 'MarkerSize', 6, 'NodeLabel', arrayfun(@num2str, 1:n, 'UniformOutput', false));
title('Grafo della Rete');

subplot(1, 2, 2);
h_colored = plot(G, 'NodeCData', node_colors, 'MarkerSize', 6, 'NodeLabel', arrayfun(@num2str, 1:n, 'UniformOutput', false));
title(['Centralità dei Nodi per ', name]);
% Settaggio della colorbar utilizzata per distinguere i diversi valori di
% centralità ottenuti
colormap('parula');
colorbar;

% Stampa, nella console, gli indici dei nodi più importanti e il loro valore di centralità
fprintf('\n\n<strong>INDICI DEI NODI E VALORI DI CENTRALITA INDIVIDUATI</strong>\nNodi importanti:\n');
disp(important_nodes');
fprintf('Valori di centralità:\n');
disp(centrality_values');
