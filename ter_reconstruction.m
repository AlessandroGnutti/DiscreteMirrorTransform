function [y, incr] = ter_reconstruction(x, flag)

switch flag
    
    case 's'                                % Single sample
        y                       = x{1};
        incr                    = 1;
        
    case {'r', 'l', 'a'}                    % Right/left/no tail
        a                       = x{1};
        b                       = x{2};
        if isequal(size(a), size(b))
            a2                  = horzcat(a, a(:, end:-1:1))/sqrt(2);
            b2                  = horzcat(b, -b(:, end:-1:1))/sqrt(2);
        else
            a2                  = horzcat(a, a(:, end-1:-1:1))/sqrt(2);
            a2(:,ceil(end/2))   = a2(:,ceil(end/2))*sqrt(2);
            b2                  = horzcat(b, zeros(size(b,1), 1), -b(:, end:-1:1))/sqrt(2);                   
        end
        if strcmp(flag, 'r')
            y                   = horzcat(a2+b2, x{3});
            incr                = 3;
        elseif strcmp(flag, 'l')
            y                   = horzcat(x{3}, a2+b2);
            incr                = 3;
        else
            y                   = a2+b2;
            incr                = 2;
        end
        
    case {'b', 't', 'aa'}                   % Bottom/top/no tail
        a                       = x{1};
        b                       = x{2};
        if isequal(size(a), size(b))
            a2                  = vertcat(a, a(end:-1:1,:))/sqrt(2);
            b2                  = vertcat(b, -b(end:-1:1,:))/sqrt(2);
        else
            a2                  = vertcat(a, a(end-1:-1:1,:))/sqrt(2);
            a2(ceil(end/2),:)   = a2(ceil(end/2),:)*sqrt(2);
            b2                  = vertcat(b, zeros(1,size(b,2)), -b(end:-1:1,:))/sqrt(2);                   
        end
        if strcmp(flag, 'b')
            y                   = vertcat(a2+b2, x{3});
            incr                = 3;
        elseif strcmp(flag, 't')
            y                   = vertcat(x{3}, a2+b2);
            incr                = 3;
        else
            y                   = a2+b2;
            incr                = 2;
        end

    case{'rx'}                              % Vertical axis, n0 first col
        y                       = horzcat(x{1}, x{2});
        incr                    = 2;
        
    case{'lx'}                              % Vertical axis, n0 last col
        y                       = horzcat(x{2}, x{1});
        incr                    = 2;
        
    case{'bx'}                              % Horizontal axis, n0 first row
        y                       = vertcat(x{1}, x{2});
        incr                    = 2;
        
    case{'tx'}                              % Horizontal axis, n0 last row
        y                       = vertcat(x{2}, x{1});
        incr                    = 2;
        
end