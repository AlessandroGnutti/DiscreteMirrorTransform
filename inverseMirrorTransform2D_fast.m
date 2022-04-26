function [x_rec, albero_rec] = inverseMirrorTransform2D_fast(X, n0_table, flag_table)

albero_rec = cell(size(n0_table)+[1 0]);
albero_rec(end,:) = num2cell(X);

lev = size(n0_table, 1);
while(lev)
    ind = 1;
    for i=1:length(n0_table(lev,:))
        n0 = n0_table{lev, i};
        f = flag_table{lev, i};
        if isempty(f)
            break
        elseif strcmp(f,'s')
            albero_rec{lev,i} = albero_rec{lev+1, ind};
            ind = ind + 1;
        else
            albero_rec{lev,i} = recomposition2D(albero_rec{lev+1, ind}, albero_rec{lev+1, ind+1}, n0, f);
            ind = ind + 2;
        end
    end
    lev = lev - 1;
end
x_rec = cell2mat(albero_rec(1,1));