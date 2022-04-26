function [x_rec, albero_rec, table_integer_case, table_half_case] =...
    inverseMirrorTransform_v3_senza_n0_just_half_n0(X, n0_table)

albero_rec = cell(size(n0_table)+[1 0]);
albero_rec(end,:) = num2cell(X);

% Statistica: in riga/colonna metto L_l, L_l+0.5, L_r+0.5, L_r+1
table_integer_case = zeros(1, 4); % I, IH, II, IIH
table_half_case = zeros(1,3); % H, HI, IIH

lev = size(n0_table, 1);
while(lev)
    ind = 1;
    for i=1:length(n0_table(lev,:))
        n0 = n0_table{lev, i};
        if isempty(n0)
            break
        elseif isnumeric(n0)   
            %%%%%%%%%%%%%%%%%%% STUDIO CASI%%%%%%%%%%%%%%%%%%%
%             n_l = albero_rec{lev+1, ind};
%             n_r = albero_rec{lev+1, ind+1};
%             if length(n_l)>1 && length(n_r)==1
%                 potential_n0 = length(n_r) + length(n_l);
%             elseif length(n_l)==1 && length(n_r)>1
%                 potential_n0 = [length(n_l), length(n_r)+0.5];
%             elseif length(n_l)==1 && length(n_r)==1
%                 potential_n0 = [1, 1.5, 2];
%             else
%                 potential_n0 = [length(n_r)+0.5, length(n_r)+1];
%             end
%             potential_n0 = unique(potential_n0);
%             I = 0;
%             H = 0;
%             for kkk = 1:length(potential_n0)
%                 n_up = recomposition_v3(n_l, n_r, potential_n0(kkk));
%                 [computed_n_l, computed_n_r, ~] = n0Search_v3_just_half_n0(n_up);
%                 if length(n_l)==length(computed_n_l) && length(n_r)==length(computed_n_r)
%                     if max(abs(n_l-computed_n_l)) < 10^-6 && max(abs(n_r-computed_n_r)) < 10^-6
%                         if mod(potential_n0(kkk),1)==0
%                             I = I +1;
%                         else
%                             H = H + 1;
%                         end
%                     end
%                 end
%             end
%             if mod(n0,1)==0 % Integer case
%                 if H==0 && I==1
%                     table_integer_case(1) = table_integer_case(1)+1;
%                 elseif H==0 && I==2
%                     table_integer_case(3) = table_integer_case(3)+1;
%                 elseif H==1 && I==1
%                     table_integer_case(2) = table_integer_case(2)+1;
%                 elseif H==1 && I==2
%                     table_integer_case(4) = table_integer_case(4)+1;
%                 end
%             else
%                 if I==0
%                     table_half_case(1) = table_half_case(1)+1;
%                 elseif I==1
%                     table_half_case(2) = table_half_case(2)+1;
%                 elseif I==2
%                     table_half_case(3) = table_half_case(3)+1;
%                 end
%             end
            %%%%%%%%%%%%%%%%%%% FINE STUDIO CASI%%%%%%%%%%%%%%%%%%%
            albero_rec{lev,i} = recomposition_v3(albero_rec{lev+1, ind}, albero_rec{lev+1, ind+1}, n0);
            ind = ind + 2;
        elseif strcmp(n0,'s')
            albero_rec{lev,i} = albero_rec{lev+1, ind};
            ind = ind + 1;
        end
    end
    lev = lev - 1;
end
x_rec = cell2mat(albero_rec(1,1));