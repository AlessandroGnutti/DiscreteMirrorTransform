function [X, table] = mirrorTransform2D_slow(x)

X                                   = {x};
table                               = {[]};
lev                                 = 0; 
bol                                 = true;
while(bol)   
    lev                             = lev + 1;
    count                           = 1;
    numb                            = 1;
    for k = 1:size(X(lev,:),2)   
        y                           = X{lev,k};
        [ye, yo, tail, flag]        = ternaryEvenOddDecomposition(y);
        X{lev+1,count}              = ye;                   
        count                       = count + 1;
        if ~isempty(yo)
            X{lev+1,count}          = yo;                   
            count                   = count + 1;
        end
        if ~isempty(tail)
            X{lev+1,count}          = tail;                 
            count                   = count + 1;
        end
        table{lev, numb}            = flag;                 
        numb                        = numb + 1;       
    end  
    M                               = max(cellfun('length', X(lev+1,:)));
    if M                            == 1
        bol                         = false;
    end
end