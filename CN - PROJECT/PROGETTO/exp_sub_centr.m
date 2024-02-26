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

    % Numero di nodi nel grafo
    n = size(A, 1);

    %Definisco la soglia per cui poi devo fermarmi
    tol = 1e-5;

    %Definisco il vettore gs che conterrà le centralità
    gs = zeros(n,1);

    for i=1:n

        %Genero il vettore u che è ogni volta l'i-esima colonna della matrice
        %identita
        u = zeros(n,1); 
        u(i)=1;

        kmax = n; %Non posso andare oltre la dimensione della matrice che ho fissato
        g = 0;
        k = 0;
    
        %Definisco u di partenza
        u0=zeros(n,1);
        beta=0;
    
        U=u; %U inizia con u e basta
    
        flag = 1;
    
        while flag
            k = k+1;
            g0 =  g;
            alpha = u' * A * u;
            utilde = A * u - alpha * u - beta*u0;
            beta = norm(utilde);
            u0 = u;
            if beta < 1e-10
                warning('beta troppo piccolo!')
            else
                u = utilde/beta;
            end
    
            J(k,k) = alpha;
            J(k+1,k) = beta;
            J(k,k+1) = beta;
    
            U = [U u];
    
            Jk = J(1:k,1:k);
        
            % CALCOLO DELL'ESPONENZIALE MATRICIALE
            % expm(Jk) è definita come la serie di Taylor:
            % expm(Jk) = I * Jk * Jk^2/2! * [...] * Jk^n/n!.
            % Con l'esponenziale normale (exp(Jk)), invece, avremmo 
            % ottenuto "l'esponenziale puntuale"
            E = expm(Jk);  
            g = E(1,1); 
        
            flag = abs(g-g0) > tol * abs(g) && k < kmax;  %&& beta > 1e-10; %Bisogna sempre fissare un numero massimo di iterazioni 
        end
    
        gs(i)=g;
    end

    % Ordinamento dei nodi per centralità decrescente
    [~, i] = sort(gs, 'descend');
    i = i(1:m);
    val = gs(i);
end