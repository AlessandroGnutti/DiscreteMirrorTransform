function [y, seq_albero, lunghezze, new_albero] = genera_albero_per_decodificatore(albero)

tol = 10^(-3);

new_albero = albero;

lev = size(albero, 1);

for ii = lev-2:-1:1
    ref_nodes = albero(ii, :);
    this_nodes = albero(ii+1,:);
    count = 1;
    for jj = 1:length(ref_nodes)
        genitore = ref_nodes{jj};
        genitore = genitore(:);
        if isempty(genitore)
            break;
        elseif length(genitore)==1 % Il genitore ha un campione, sicuramente l'albero stoppa da lì in poi
            new_albero{ii+1, count} = [];
            count = count + 1;
        elseif length(genitore)>1 && sum(abs(genitore))>tol % Nodo non nullo con lunghezza > 1
            if length(this_nodes{count}(:))==1 % Se un figlio ha singolo campione segnalo 's'
                new_albero{ii+1, count} = 2;
            else 
                if sum(abs(this_nodes{count}(:)))<tol % Un figlio ha tanti zeri, allora piazzo lo zero 
                    new_albero{ii+1, count} = 0;
                else % Caso standard di un nodo con alcuni campioni
                    new_albero{ii+1, count} = 1;
                end
            end
            if length(this_nodes{count+1}(:))==1
                new_albero{ii+1, count+1} = 2;
            else 
                if sum(abs(this_nodes{count+1}(:)))<tol % Un figlio ha tanti zeri, allora piazzo lo zero 
                    new_albero{ii+1, count+1} = 0;
                else % Caso standard di un nodo con alcuni campioni
                    new_albero{ii+1, count+1} = 1;
                end
            end
            count = count + 2;
        elseif length(genitore)>1 && sum(abs(genitore))<tol % Nodo nullo con lunghezza > 1
            new_albero{ii+1, count} = [];
            new_albero{ii+1, count+1} = [];
            count = count + 2;
        end
    end
end
new_albero{1,1} = 1;
%%% Elimino livelli superflui
number_levels_todelete = 0;
for ii = size(new_albero,1):-1:1
    temp = cell2mat(new_albero(ii,:));
    if ismember(1,temp) % Se contiene solo 's', inutile
        break;
    else
        number_levels_todelete = number_levels_todelete + 1;
    end
end
new_albero = new_albero(1:end-number_levels_todelete,:);

% Seconda parte: genero sequenze dell'albero, coefficienti e lunghezze
count_lun = 1;
y = cell2mat(albero(end,:));
lunghezze = (abs(cell2mat(albero(end,:)))+1)*Inf;
count_alb = 1;
seq_albero = [];
for ii = 1:size(new_albero, 1)
    zeri = 0;
    count = 1;
    for jj = 1:size(new_albero, 2)
        if new_albero{ii,jj}==0
            % Albero
            seq_albero(count_alb) = 0;
            count_alb = count_alb + 1;
            % Zeri e run-length
            zeri = zeri + 1;
            lun = length(albero{ii,jj});
            lunghezze(count_lun) = lun;
            count_lun = count_lun + 1;
            % Coefficienti
            y(count:count+lun-1) = Inf;
            count = count + lun;
        elseif new_albero{ii,jj}==2
            % Albero
            seq_albero(count_alb) = 2;
            count_alb = count_alb + 1;
            % Coefficienti
            count = count + 1;
        elseif new_albero{ii,jj}==1
            seq_albero(count_alb) = 1;
            count_alb = count_alb + 1;
            % Coefficienti
            count = count + length(albero{ii,jj});
        elseif isempty(new_albero{ii,jj})
            % Coefficienti
            count = count + length(albero{ii,jj});
        end
    end
%     if zeri == 1
%         count_lun = count_lun - 1;
%         lunghezze(count_lun) = Inf;
%     end
end
y(y==Inf) = [];
lunghezze(lunghezze==Inf) = [];