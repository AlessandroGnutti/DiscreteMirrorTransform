function [X, n0_table, flag_table] = mirrorTransform2D_fast(x,mode)

albero = {x};
albero_next_lev = {};
n0_table = {[]};
flag_table = {[]};
lev = 0; 
bol = true;

while(bol) 
    bol = false;
    lev = lev + 1;
    count = 1;
    numb = 1;
    for k = 1:length(albero) 
        [node_left, node_right, n0, flag] = n0Search2D(albero{k}, mode);
        if ~strcmp(flag,'s')
            bol = true;
        end
        albero_next_lev{count} = node_left;
        count = count + 1;
        if ~isempty(node_right)
            albero_next_lev{count} = node_right;
            count = count + 1;
        end
        n0_table{lev, numb} = n0;                 
        flag_table{lev, numb} = flag;
        numb = numb + 1; 
    end
    albero = albero_next_lev;
end
% I can delete the last row
n0_table = n0_table(1:end-1, :);
flag_table = flag_table(1:end-1, :);
X = cell2mat(albero);