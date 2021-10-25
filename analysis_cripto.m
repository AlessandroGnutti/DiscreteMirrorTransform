clear
close all
clc

load('Out/Data2.mat', 'N', 'numbKeptCoeff', 'snrArray', 'X', 'X_noise')
num_signals = size(X,2);

% Exp on collisions
table_collisions = zeros(1, length(numbKeptCoeff));
for kk = 1:length(numbKeptCoeff)
    for qq = 1:num_signals
        for zz = qq+1:num_signals
            table_collisions(kk) = table_collisions(kk) + isequal(X{kk,qq}, X{kk,zz});
        end
    end
end
figure
plot(numbKeptCoeff,table_collisions)
xlabel('Kept coefficients')
ylabel('Number of collisions')
title([num2str(num_signals), ' ', num2str(N), '-length signals'])
grid on
xticks(numbKeptCoeff)

% Exp on adding noise
table_cong = zeros(length(snrArray), length(numbKeptCoeff));
for ii = 1:4 % Plotto solo snr = 40, 36, 32 e 38 (occhio agli indici di X_noise) 
    for kk = 1:length(numbKeptCoeff)
        for qq = 1:num_signals
            table_cong(ii,kk) = table_cong(ii,kk) + isequal(X{kk,qq}, X_noise{ii*2-1,kk,qq});
        end
    end
    subplot(2,2,ii)
    plot(numbKeptCoeff,table_cong(ii,:))
    xlabel('Kept coefficients')
    ylabel('Number of non-changing trees')
    title(['SNR: ', num2str(snrArray(ii)), ' dB'])
    grid on
    xticks(numbKeptCoeff)
end