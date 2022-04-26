function node = recomposition_v3(node_left, node_right, n0)

N = length(node_left)+length(node_right);
if ~mod(n0,1) % n0 is an integer
    if n0 == 1 || n0 == N % Casi particolare
        node = [node_left, node_right];
        return
    end
    if length(node_left) > length(node_right) % Tail is in node_left (n0<=N/2)
        xo_c = [0, node_right];
        xe_c = node_left(1:length(xo_c)); xe_c(1) = sqrt(2)*xe_c(1);
        tail = node_left(length(xe_c)+1:end);
    else % Tail is in node_right (n0>N/2)
        xe_c = node_left; xe_c(1) = sqrt(2)*xe_c(1); 
        xo_c = [0 node_right(2*n0-N:end)];
        tail = node_right(1:2*n0-N-1);
    end
    xe = [xe_c(end:-1:2), xe_c]/sqrt(2);
    xo = [-xo_c(end:-1:2), xo_c]/sqrt(2);
else % n0 is a half-sample
    if length(node_left) > length(node_right) % Tail is in node_left (n0<=N/2)
        xo_c = node_right;
        xe_c = node_left(1:length(xo_c));
        tail = node_left(length(xe_c)+1:end);
    else % Tail is in node_right (n0>N/2)
        xe_c = node_left; 
        xo_c = node_right(2*n0-N:end);
        tail = node_right(1:2*n0-N-1);
    end
    xe = [xe_c(end:-1:1), xe_c]/sqrt(2);
    xo = [-xo_c(end:-1:1), xo_c]/sqrt(2);
end
if n0 <= N/2
    node = [xe+xo, tail];
else
    node = [tail, xe+xo];
end