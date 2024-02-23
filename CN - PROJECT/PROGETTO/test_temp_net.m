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
    
    % Chiede all'utente quanti nodi importanti vuole individuare
    m = input('\n\n<strong>NODI IMPORTANTI DA INDIVIDUARE</strong>\nQuanti nodi importanti vorresti individuare?\nInserisci qui la quantità: ');
    
    % Chiamata alla funzione temp_net
    [Nodo, Indice] = temp_net(T, m);
    
    % Stampa dei risultati
    fprintf('\n\n<strong>INDICI DEI NODI E VALORI DI CENTRALITA INDIVIDUATI</strong>\n');
    disp(table(Nodo, Indice));
    
end