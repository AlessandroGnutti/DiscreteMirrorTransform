clear
close all
clc

% x = [zeros(1,10), ones(1,30), zeros(1,10), triang(41)', zeros(1,10)];
% b = 0.2:0.2:4;
t = -2:0.01:2;
x = [t.^2, zeros(1,100), 10*triang(100)', zeros(1,100), ones(1,100)];

% Trasformata
tic
[X, original_albero, n0_table] = mirrorTransform_v3_just_half_n0(x);
toc


b = 0.05:0.05:1;
new_x = zeros(length(b), length(x));

temp_even = original_albero{2,1};
temp_odd = original_albero{2,2};
E_e = sum(temp_even.^2);
E_o = sum(temp_odd.^2);
E =  E_e + E_o;
for ii = 1:length(b) 
    a = sqrt((E-b(ii)^2*E_o)/E_e);
    if ~isreal(a)
        new_x = new_x(1:ii-1,:);
        break;
    end
    new_x(ii,:) = recomposition_v3(a*temp_even, b(ii)*temp_odd, n0_table{1,1}); 
    [~, new_original_albero, new_n0_table] = mirrorTransform_v3_just_half_n0(new_x(ii,:));
    if ~isequal(n0_table{1,1}, new_n0_table{1,1})
        warning('Ocio')
    end
end

for ii = 1:size(new_x,1)
    subplot(4,5,ii), plot(new_x(ii,:))
    grid on
%     axis([-0.5 100 0 2])
end

