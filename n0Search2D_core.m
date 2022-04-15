function [node_left, node_right, n0] = n0Search2D_core(x)

tol = 10^-6;
N = size(x,2);

% Conv and n0
if sum(x(:).^2)<tol
    n0 = (N+1)/2;
else
    z = conv2(x, x(end:-1:1,:));
    z = z(size(x,1),:);
    [~, iM] = max(abs(z));
    n0 = (iM+1)/2;
end

% Even/odd decomposition
if n0 == 1 % Special case: n0 is equal to 1
    node_left = x(:,1);
    node_right = x(:,2:end);
    return
elseif n0 == N % Special case: n0 is equal to N
    node_left = x(:,end);
    node_right = x(:,1:end-1);
    return
elseif n0 <= (N+1)/2 % n0 on left or central
    padding = N - 2*n0 + 1;
    x_pad = [zeros(size(x,1),padding), x];
else % n0 on right
    padding = 2*n0 - N - 1;
    x_pad = [x, zeros(size(x,1),padding)];
end
xe = (x_pad + x_pad(:,end:-1:1))/2;
xo = (x_pad - x_pad(:,end:-1:1))/2;

% Causal parts
if mod(size(xe,2), 2) % odd length -> n0 is a sample
    %         xe_c = xe((length(xe)+1)/2:end);
    xe_c = [xe(:,(size(xe,2)+1)/2), sqrt(2)*xe(:,(size(xe,2)+1)/2+1:end)];
    xo_c = sqrt(2)*xo(:,(size(xe,2)+1)/2+1:end); % The sample in the middle is always equal to zero thus it is removed
else
    xe_c = sqrt(2)*xe(:,size(xe,2)/2+1:end);
    xo_c = sqrt(2)*xo(:,size(xo,2)/2+1:end);
end

% Nodes computation
if sum(xe_c(:).^2) >= sum(xo_c(:).^2)
    node_left = [xe_c(:,1:end-padding), sqrt(2)*xe_c(:,end-padding+1:end)];
    node_right = xo_c(:,1:end-padding);
else
    node_left = xe_c(:,1:end-padding);
    node_right = [xo_c(:,1:end-padding),  sqrt(2)*xo_c(:,end-padding+1:end)];
end
