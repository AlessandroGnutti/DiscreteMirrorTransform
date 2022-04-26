clear
close all
clc

% Setup of the experiment parameters
num_signals = 5000;
N = 64;
snrArray = 5:2:30;

% Transforms
x = rand(num_signals,N);
T = cell(num_signals,1);
n0_table = cell(num_signals,1);
albero = cell(num_signals,1);
for ii = 1:num_signals
    [T{ii}, ~, n0_table{ii}] = mirrorTransform_v3_just_half_n0(x(ii,:));
end

% Exp on collisions
table_ok = zeros(size(snrArray));
for kk = 1:length(snrArray)
    kk
    for qq = 1:num_signals
        Tq = T{qq};
%         [~, i_m] = min(Tq);
%         Tq(i_m) = awgn(Tq(i_m), snrArray(kk),'measured');
        Tq(1) = awgn(Tq(1), snrArray(kk),'measured');
        x_rec = inverseMirrorTransform_v3_senza_n0_just_half_n0(Tq, n0_table{qq});
        [~, ~, n0_table_new] = mirrorTransform_v3_just_half_n0(x_rec);
        table_ok(kk) = table_ok(kk) + isequal(n0_table{qq}, n0_table_new);
    end
end

