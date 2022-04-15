function [node_left, node_right, n0, flag] = n0Search2D(x,mode)

% Singolo campione?
if numel(x)==1
    node_left = x;
    node_right = [];
    n0 = 1;
    flag = 's';
    return;
end

if size(x,2) > 1
    % Studio simmetrie rispetto ad un asse verticale
    [node_left_v, node_right_v, n0_v] = n0Search2D_core(x);
else
    % Vettore colonna, opero solo in questa direzione
    [node_left_h, node_right_h, n0] = n0Search2D_core(x');
    node_left = node_left_h';
    node_right = node_right_h';
    flag = 'h';
    return;
end

if size(x,1) > 1
    % Studio simmetrie rispetto ad un asse orizzontale
    [node_left_h, node_right_h, n0_h] = n0Search2D_core(x');
else % Vettore riga, tengo la scomposizione fatta precedentemente rispetto all'asse verticale
    node_left = node_left_v;
    node_right = node_right_v;
    n0 = n0_v;
    flag = 'v';
    return;
end

% Ho effettuato entrambe le scomposizioni: who wins?
[~, ind] = max([sum(node_left_v(:).^2), sum(node_right_v(:).^2), sum(node_left_h(:).^2), sum(node_right_h(:).^2)]);
if ind <= 2 || strcmp(mode,'dmt')
    node_left = node_left_v;
    node_right = node_right_v;
    n0 = n0_v;
    flag = 'v';
else
    node_left = node_left_h';
    node_right = node_right_h';
    n0 = n0_h;
    flag = 'h';
end
