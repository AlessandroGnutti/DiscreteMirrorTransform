function z = ter_iist(z, table)

lev                         = size(z,1)-1;
while(lev)
    numb                    = 1;
    for i=1:length(table(lev,:))
        if isempty(table{lev, i})
            break;
        end
        [z{lev,i}, incr]    = ter_reconstruction(z(lev+1, numb:end), table{lev, i});
        numb                = numb + incr;
    end
    lev                     = lev - 1;
end