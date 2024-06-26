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
%   - type: stringa che contiene l'indice, scelto dall'utente, da voler
%        calcolare;
%
% OUTPUT:
%   - i: vettore contenente gli indici dei nodi, con il valore più alto di
%        centralità;
%   - val: vettore contenente i valori di centralità corrispondenti ai nodi
%          presenti all'interno di i;

function [i, val] = temp_net(T, m, type)

    % In n andrò a salvare il numero di righe, e implicitamente di colonne,
    % di ogni matrice A[k] contenuta in T. Mentre in t, andrò a salvare il
    % numero di matrici contenute in T.
    [n,~,t] = size(T);

    % Inizializzazione del vettore rho per memorizzare i raggi spettrali
    rho_vector = zeros(t,1);
    
    % Calcolo del raggio spettrale per ogni matrice A[k]
    for i=1:t
        rho_vector(i) = abs(eigs(T(:,:,i),1,'largestabs'));
    end

    % Salvo il rho più grande, tra tutti i diversi istanti temporali
    rho = max(rho_vector);

    % Scelta di alpha:
    % alpha < inv(max_eig), ma è preferibile utilizzare un valore , per 
    % alpha, statico che sia compreso tra 0 e 1/max_eig.
    alpha = 0.9/rho;

    B = zeros(t*n);

    for i=1:t
        B((n*(i-1))+1:n*i,(n*(i-1))+1:n*i) = alpha*T(:,:,i);
    end

    % Fisso il valore di Beta a 1, in quanto è sufficiente una matrice 
    % identità traslata

    % Creo una matrice sparsa che abbia 1 sulla diagonale superiore e 0 
    % altrove
    upperI = sparse(n+1:n*t, 1:n*t-n, 1, n*t, n*t);
    upperI = upperI.';

    % Aggiungo la matrice upperI per aggiungere i collegamenti tra i nodi
    % consecutivi all'interno di B
    B = B + upperI;

    % I due vettori, vt e vn, saranno poi utilizzati per calcolare, poi 
    % dopo, il prodotto di Kronecker:
    % - vt : rappresenta il numero di matrici contenute in T;
    % - vn : rappresenta il nnumero di righe e colonne per ogni 
    %        matrice contenuta in T; 
    vt = zeros(t,1);
    vn = ones(n,1);

    switch(type)
        case 'Broadcast'
            % Per la broadcast, inizializzo vt(t) a 1 per considerare
            % l'informazione che parte dal nodo al tempo t e si diffonde 
            % nella rete negli istanti di tempo successivi
            vt(t) = 1;

            % Kron(vt, vn) esegue il prodotto di Kronecker tra i due 
            % vettori,vettori vt e vn.
            E = kron(vt,vn);

            % Risolvo il sistema per la Broadcast per la X
            % (I-B)x = E -> X = (I-B) \ E
            xbig = (eye(size(B)) - B) \ E;
            xbig = xbig(1:10);

        case 'Receive'
            % Per la Receive, inizializzo vt(1) a 1 per considerare 
            % l'informazione che arriva al nodo al tempo 1 e si accumula 
            % nel nodo negli istanti di tempo successivi
            vt(1) = 1;

            % Kron(vt, vn) esegue il prodotto di Kronecker tra i due 
            % vettori,vettori vt e vn.
            E = kron(vt,vn);

            % Risolvo il sistema per la Receive per la X
            % (I-B)^Tx = E -> X = (I-B)^T \ E
            xbig = (eye(size(B)) - B).' \ E;
            xbig = xbig((t-1) * n + 1:n * t);
    end

    % Ordinamento dei nodi per centralità decrescente
    [val, i] = sort(xbig, 'descend');
    i = i(1:m);
    val = val(1:m);
    
end
