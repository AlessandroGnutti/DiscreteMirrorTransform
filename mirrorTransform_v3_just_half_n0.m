function [X, albero, n0_table, flag_table] = mirrorTransform_v3_just_half_n0(x)

albero = {x};
n0_table = {[]};
flag_table = {[]};
lev = 0; 
bol = true;

while(bol) 
    bol = false;
    lev = lev + 1;
    count = 1;
    numb = 1;
    for k = 1:length(albero(lev,:)) 
        [node_left, node_right, n0, flag] = n0Search_v3_just_half_n0(albero{lev,k});
        if isnumeric(n0)
            bol = true;
        end
        albero{lev+1,count} = node_left;
        count = count + 1;
        if ~isempty(node_right)
            albero{lev+1,count} = node_right;
            count = count + 1;
        end
        n0_table{lev, numb} = n0;                 
        flag_table{lev, numb} = flag;
        numb = numb + 1; 
    end
end
% I can delete the last row
albero = albero(1:end-1, :);
n0_table = n0_table(1:end-1, :);
flag_table = flag_table(1:end-1, :);
X = cell2mat(albero(end,:));