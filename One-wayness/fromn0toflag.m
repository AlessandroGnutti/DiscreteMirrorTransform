function flag = fromn0toflag(n0, N)

% if n0==1 && N > 2
%     flag = 'l';
%     return;
% elseif n0==N && N > 2
%     flag = 'r';
%     return;
% end

if (N/2+0.5)==n0
    if mod(n0,1) % Half
        flag = 'h';
    else
        flag = 'i';
    end
    return;
end

if mod(n0, 1) % Half
    if n0>=(N/2+1)
        flag = 'hr';
    else
        flag = 'hl';
    end
else % Integer
    if n0>=(N/2+1)
        flag = 'ir';
    else
        flag = 'il';
    end
end

end