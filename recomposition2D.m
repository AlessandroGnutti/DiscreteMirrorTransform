function node = recomposition2D(node_left, node_right, n0, f)

if strcmp(f, 'h')
    node_left = node_left';
    node_right = node_right';
end

bln = false;
if ~mod(n0,1) % n0 is an integer
    if n0 == 1 % Casi particolare
        node = [node_left, node_right];
        if strcmp(f, 'h')
            node = node';
        end
        return
    elseif n0 == size(node_left,2) + size(node_right,2)
        node = [node_right, node_left];
        if strcmp(f, 'h')
            node = node';
        end
        return
    end
    if size(node_left,2) > size(node_right,2) % Tail is in node_left
        xo_c = [zeros(size(node_right,1),1), node_right];
        xe_c = node_left(:,1:size(xo_c,2)); xe_c(:,1) = sqrt(2)*xe_c(:,1);
        tail = node_left(:,size(xe_c,2)+1:end);
    else % Tail is in node_right
        xe_c = node_left; xe_c(:,1) = sqrt(2)*xe_c(:,1); 
        xo_c = [zeros(size(node_right,1),1), node_right(:,1:size(xe_c,2)-1)];
        tail = node_right(:,size(xe_c,2):end);
        bln = true;
    end
    xe = [xe_c(:,end:-1:2), xe_c]/sqrt(2);
    xo = [-xo_c(:,end:-1:2), xo_c]/sqrt(2);
else % n0 is a half-sample
    if size(node_left,2) > size(node_right,2) % Tail is in node_left
        xo_c = node_right;
        xe_c = node_left(:,1:size(xo_c,2)); 
        tail = node_left(:,size(xe_c,2)+1:end);
    else % Tail is in node_right
        xe_c = node_left;
        xo_c = node_right(:,1:size(xe_c,2));
        tail = node_right(:,size(xo_c,2)+1:end);
        bln = true;
    end
    xe = [xe_c(:,end:-1:1), xe_c]/sqrt(2);
    xo = [-xo_c(:,end:-1:1), xo_c]/sqrt(2);
end
if n0 <= (size(xe,2)+size(tail,2))/2
    node = [xe+xo, tail];
else
    tail = tail(:,end:-1:1);
    if bln
        node = [-tail, xe+xo];
    else
        node = [tail, xe+xo];
    end
end

if strcmp(f, 'h')
    node = node';
end