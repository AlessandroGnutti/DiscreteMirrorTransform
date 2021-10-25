function [node_left, node_right, n0, flag] = n0Search_v3_just_half_n0(x, articifial_n0)

% Come n0Search_v3, ma ammetto solo n0 tra due pixel

N = length(x);
tol = 10^-6;

if N == 1
    node_left = x;
    node_right = [];
    n0 = 's';
    flag = 's'; % Single
    return;
else
    % Conv and n0
    if sum(x.^2)<tol
        n0 = (N+1)/2;
        z = conv(x,x);
    else
        z = conv(x,x);
        [~, iM] = max(abs(z));
        n0 = (iM+1)/2;
    end
    
    % Aggiunto per mainSameClassSignalsGeneration
    if nargin == 2
        n0 = articifial_n0;
    end
    
    if mod(n0,1)==0 
        if n0==1
            n0 = n0 + 0.5;
        elseif n0==N
            n0 = n0 - 0.5;
        else
            [~, next_iM] = max(abs(z([n0-1, n0+1])));
            if next_iM == 1
                n0 = n0 - 0.5;
            else
                n0 = n0 + 0.5;
            end
        end
    end
    flag = fromn0toflag(n0, N);
    
    % Even/odd decomposition
    if n0 == 1 % Special case: n0 is equal to 1
        node_left = x(1);
        node_right = x(2:end);
        return
    elseif n0 == N % Special case: n0 is equal to N
        node_left = x(1:end-1);
        node_right = x(end);
        return
    else
        [xe_c, xo_c, tail] = ter_evenOddDecomposition(x, n0);
        % La funzione ter_evenOddDecomposition restituisce le parti " a
        % sinistra", mentre la funzione recomposition_v2 ricostruisce come
        % se le i nodi avessero salvate le parti "a destra". Quindi flippo.
        xe_c = xe_c(end:-1:1);
        xo_c = -xo_c(end:-1:1);
        if n0 <= (N+1)/2
            node_left = [xe_c, tail];
            node_right = xo_c;
        elseif n0 > (N+1)/2
            node_left = xe_c;
            node_right = [tail, xo_c]; 
        end
    end
end