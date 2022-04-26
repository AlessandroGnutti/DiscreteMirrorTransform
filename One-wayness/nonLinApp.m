function y = nonLinApp(x, k)
    [~, ind] = sort(abs(x(:)), 'descend');
    y = zeros(size(x));
    y(ind(1:k)) = x(ind(1:k));
end