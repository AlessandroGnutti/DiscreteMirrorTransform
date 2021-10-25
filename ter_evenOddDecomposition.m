function [ye, yo, tail, flag] = ter_evenOddDecomposition(y, my_n0)

% flag mi restituisce la posizione della tail
% 'r' a destra, 'l' a sinistra e 'a' assente
% 'b' sotto, 't' sopra e 'aa' assente
% 's' singolo campione.
% '-x' n0=1

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
    
    if n0                   < (size(y,2)+1)/2                       % n0 a sinistra
        temp                = y(:, 1:2*n0-1);
        ye                  = (sqrt(2)/2)*(temp+temp(:,end:-1:1));
        yo                  = (sqrt(2)/2)*(temp-temp(:,end:-1:1));
        tail                = y(:, 2*n0:end);
        flag                = 'r';
    elseif n0               > (size(y,2)+1)/2                       % n0 a destra
        temp                = y(:, 2*n0-size(y,2):end);
        ye                  = (sqrt(2)/2)*(temp+temp(:,end:-1:1));
        yo                  = (sqrt(2)/2)*(temp-temp(:,end:-1:1));
        tail                = y(:, 1:2*n0-size(y,2)-1);
        flag                = 'l';
    else                                                            %n0 centrale
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
    
    if n0                   < (size(y,1)+1)/2                       % n0 in basso
        temp                = y(1:2*n0-1,:);
        ye                  = (sqrt(2)/2)*(temp+temp(end:-1:1,:));
        yo                  = (sqrt(2)/2)*(temp-temp(end:-1:1,:));
        tail                = y(2*n0:end,:);
        flag                = 'b';
    elseif n0               > (size(y,1)+1)/2                       % n0 in alto
        temp                = y(2*n0-size(y,1):end,:);
        ye                  = (sqrt(2)/2)*(temp+temp(end:-1:1,:));
        yo                  = (sqrt(2)/2)*(temp-temp(end:-1:1,:));
        tail                = y(1:2*n0-size(y,1)-1,:);
        flag                = 't';
    else                                                            % n0 centrale
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