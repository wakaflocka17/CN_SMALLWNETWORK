function test_temp_net()
    
    clc
    clearvars
    close all

    % Numero di "fette" temporali
    M = 3;

    % Dimensione di ogni matrice (nxn)
    n = 10;

    % Generazione del tensore T
    T = rand(n, n, M);

    % Chiede all'utente quale indice vorrebbe calcolare
    index = '<strong>SCELTA DELL''INDICE DA CALCOLARE</strong>\n1. Broadcast Dynamic Centrality\n2. Receive Dynamic Centrality\nInserisci qui la scelta: ';
    index_choice = input(index);
    
    % Chiede all'utente quanti nodi importanti vuole individuare
    m = input('\n\n<strong>NODI IMPORTANTI DA INDIVIDUARE</strong>\nQuanti nodi importanti vorresti individuare?\nInserisci qui la quantità: ');
    
    switch(index_choice)
        case 1 
            % Chiamata alla funzione temp_net per calcolare la Broadcast C.
            [Nodo, Valore] = temp_net(T, m, 'Broadcast');
        case 2
            % Chiamata alla funzione temp_net per calcolare la Receive C.
            [Nodo, Valore] = temp_net(T, m, 'Receive');
        otherwise
            error('<strong>SCELTA NON CORRETTA DELLA CENTRALITY</strong>: RIAVVIARE LO SCRIPT!');
    end
    
    % Stampa dei risultati
    fprintf('\n\n<strong>INDICI DEI NODI E VALORI DI CENTRALITA INDIVIDUATI</strong>\n');
    disp(table(Nodo, Valore));
    
end