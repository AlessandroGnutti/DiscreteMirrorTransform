clear
close all
clc

% Setup of the experiment parameters
num_signals = 5000;
N = 64;
numbKeptCoeff = 5:13;
snrArray = 40:-2:20;

% Transforms
x = rand(num_signals,N);
T = cell(num_signals,1);
n0_table = cell(num_signals,1);
for ii = 1:num_signals
    [T{ii}, ~, n0_table{ii}] = mirrorTransform_v3_just_half_n0(x(ii,:));
end

% Exp on collisions
X = cell(length(numbKeptCoeff),num_signals);
for kk = 1:length(numbKeptCoeff)
    for qq = 1:num_signals
        Tq = nonLinApp(T{qq}, numbKeptCoeff(kk));
        [~, albero_rec] = inverseMirrorTransform_v3_senza_n0_just_half_n0(Tq, n0_table{qq});
        [~, seq_albero, ~, ~] = generateTreeForDecoding.m(albero_rec);
        X{kk,qq} = seq_albero;
    end
end

% Exp on noise adding
X_noise = cell(length(snrArray),length(numbKeptCoeff),num_signals);
for ii = 1:length(snrArray)
    disp(ii)
    x_noise = awgn(x,snrArray(ii),'measured');
    T_noise = cell(num_signals,1);
    n0_table_noise = cell(num_signals,1);
    for jj = 1:num_signals
        [T_noise{jj}, ~, n0_table_noise{jj}] = mirrorTransform_v3_just_half_n0(x_noise(jj,:));
    end
    for kk = 1:length(numbKeptCoeff)
        for qq = 1:num_signals
            Tq_noise = nonLinApp(T_noise{qq}, numbKeptCoeff(kk));
            [~, albero_rec] = inverseMirrorTransform_v3_senza_n0_just_half_n0(Tq_noise, n0_table_noise{qq});
            [~, seq_albero, ~, ~] = generateTreeForDecoding.m(albero_rec);
            X_noise{ii,kk,qq} = seq_albero;
        end
    end
end
% save('Out/Data2.mat', 'N', 'numbKeptCoeff', 'snrArray','X', 'X_noise')

% analysis_cripto