function [ye, yo, tail, flag] = ternaryEvenOddDecomposition(y, my_n0)

% flag returns the position of the tail 
% 'r' - right, 'l' - left, 'a' absent
% 'b' - bottom, 't' top, 'aa' absent
% 's' single sample
% 'x' - n0 = 1

if isequal(size(y),[1 1])
    ye                      = y;
    yo                      = [];
    tail                    = [];
    flag                    = 's';  
    return;
end
if size(y, 2)               > 1
    if nargin == 2
        n0 = my_n0;
    elseif sum(y(:).^2)         == 0
        n0                  = (size(y,2)+1)/2;
    else
        z                   = conv2(y, y(end:-1:1, :));
        z                   = z(size(y,1), :);
        [~, iM]             = max(abs(z));
        n0                  = (iM+1)/2;
    end
    
    if n0                   < (size(y,2)+1)/2                       % n0 left
        temp                = y(:, 1:2*n0-1);
        ye                  = (sqrt(2)/2)*(temp+temp(:,end:-1:1));
        yo                  = (sqrt(2)/2)*(temp-temp(:,end:-1:1));
        tail                = y(:, 2*n0:end);
        flag                = 'r';
    elseif n0               > (size(y,2)+1)/2                       % n0 right
        temp                = y(:, 2*n0-size(y,2):end);
        ye                  = (sqrt(2)/2)*(temp+temp(:,end:-1:1));
        yo                  = (sqrt(2)/2)*(temp-temp(:,end:-1:1));
        tail                = y(:, 1:2*n0-size(y,2)-1);
        flag                = 'l';
    else                                                            %n0 middle
        ye                  = (sqrt(2)/2)*(y+y(:,end:-1:1));
        yo                  = (sqrt(2)/2)*(y-y(:,end:-1:1));
        tail                = [];
        flag                = 'a';
    end
    
    even_sup                = ceil(size(ye,2)/2);
    odd_sup                 = floor(size(yo,2)/2);
    if mod(size(ye,2),2)    == 1
        ye(:,even_sup)      = ye(:,even_sup)/sqrt(2);
    end
    ye                      = ye(:, 1:even_sup);
    yo                      = yo(:, 1:odd_sup);
else
    if nargin == 2
        n0 = my_n0;
    elseif sum(y(:).^2)         == 0
        n0                  = (size(y,1)+1)/2;
    else
        z                   = conv2(y, y(:,end:-1:1));
        z                   = z(:,size(y,2));
        [~, iM]             = max(abs(z));
        n0                  = (iM+1)/2;
    end
    
    if n0                   < (size(y,1)+1)/2                       % n0 bottom
        temp                = y(1:2*n0-1,:);
        ye                  = (sqrt(2)/2)*(temp+temp(end:-1:1,:));
        yo                  = (sqrt(2)/2)*(temp-temp(end:-1:1,:));
        tail                = y(2*n0:end,:);
        flag                = 'b';
    elseif n0               > (size(y,1)+1)/2                       % n0 top
        temp                = y(2*n0-size(y,1):end,:);
        ye                  = (sqrt(2)/2)*(temp+temp(end:-1:1,:));
        yo                  = (sqrt(2)/2)*(temp-temp(end:-1:1,:));
        tail                = y(1:2*n0-size(y,1)-1,:);
        flag                = 't';
    else                                                            % n0 middle
        ye                  = (sqrt(2)/2)*(y+y(end:-1:1,:));
        yo                  = (sqrt(2)/2)*(y-y(end:-1:1,:));
        tail                = [];
        flag                = 'aa';
    end
    
    even_sup                = ceil(size(ye,1)/2);
    odd_sup                 = floor(size(yo,1)/2);
    if mod(size(ye,1),2)    == 1
        ye(even_sup,:)      = ye(even_sup,:)/sqrt(2);
    end
    ye                      = ye(1:even_sup,:);
    yo                      = yo(1:odd_sup,:);
end
if isempty(yo)
    flag                    = strcat(flag, 'x');
end