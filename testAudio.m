clear
close all
clc

klt_basis = load('In/KLT_audio.mat');
sot_basis = load('In/SOT_audio.mat');
length_windows = length(klt_basis.K);

dwtmode('per')
wavelet_name = 'db20';

fld_audio = 'Set audio testing/';
audiobase = dir(fullfile(fld_audio, '*.wav'));

perc = 0.01:0.01:0.15;
mse_dmt = zeros(length(audiobase),length(perc));
mse_dct = zeros(length(audiobase),length(perc));    
mse_dwt = zeros(length(audiobase),length(perc));
mse_klt = zeros(length(audiobase),length(perc));    
mse_sot = zeros(length(audiobase),length(perc));
for ii = 1:length(audiobase)
    
    str = audiobase(ii).name;
    disp(str)
    [y, Fs] = audioread(strcat(fld_audio,str));
    x = mean(y,2);
    max_length = min(length(x),Fs*7); % Max 7 seconds
    x = x(1:max_length);
    M = floor(length(x)/length_windows);
    x = x(1:M*length_windows);
    x = x - min(x);
    x = x/max(x);
     
    %%%% DMT %%%%%
    fprintf('Mirror Transform loading...\n')
    [X_dmt, n0_table, flag_table] = mirrorTransform2D_fast(x,'dmt');
    fprintf('Mirror Transform computed.\n')
    
    for k = 1:length(perc)
        K = round(perc(k)*numel(x));
        X_nonlinapp = nonLinApp(X_dmt, K);
        %x_dmt_rec = inverseMirrorTransform2D(X_nonlinapp, n0_table, flag_table);
        mse_dmt(ii,k) = sum((X_dmt-X_nonlinapp).^2)/numel(x);
    end
    
    %%%%% DCT %%%%%
    X_dct = dct(x);
    for k = 1:length(perc)
        K = round(perc(k)*numel(x));
        X_dct_nonlinapp = nonLinApp(X_dct, K);
        x_dct_rec = idct(X_dct_nonlinapp);
        mse_dct(ii,k) = sum((x-x_dct_rec).^2)/numel(x);
    end
    
    %%%%% DWT %%%%%
    L = wmaxlev(size(x),wavelet_name);
    [C,S] = wavedec(x,L,wavelet_name);
    for k = 1:length(perc)
        K = round(perc(k)*numel(x));
        C_nonlinapp = nonLinApp(C, K);
        x_dwt_rec =  waverec(C_nonlinapp, S, wavelet_name);
        mse_dwt(ii,k) = sum((x-x_dwt_rec).^2)/numel(x);
    end

    %%%%% KLT and SOT %%%%%
    for k = 1:length(perc)
        K = round(perc(k)*length_windows);
        mse_total_klt = 0;
        mse_total_sot = 0;
        for ww = 1:M
            x_w = x((ww-1)*length_windows+1:ww*length_windows);

            X_w = klt_basis.K'*x_w;
            X_nonlinapp = nonLinApp(X_w, K);
            mse_total_klt = mse_total_klt + sum((X_w-X_nonlinapp).^2);

            X_w = sot_basis.E'*x_w;
            X_nonlinapp = nonLinApp(X_w, K);
            mse_total_sot = mse_total_sot + sum((X_w-X_nonlinapp).^2);


        end
        mse_klt(ii,k) = mse_total_klt/numel(x);
        mse_sot(ii,k) = mse_total_sot/numel(x);
    end
    
end

%%%%% Plot %%%%%
figure
plot(perc*100, mean(mse_dwt), 'r','LineWidth',1.2)
hold on
plot(perc*100, mean(mse_dct), 'k','LineWidth',1.2)
plot(perc*100, mean(mse_klt), 'm','LineWidth',1.2)
plot(perc*100, mean(mse_sot),'LineWidth',1.2,'Color',[0.4660 0.6740 0.1880])
plot(perc*100, mean(mse_dmt), 'b','LineWidth',1.2)
grid on
legend('DWT', 'DCT','KLT','SOT','DMT','Location','northeast')
xlabel('% non-zero coefficients'), ylabel('MSE')
xlim([1 15]), ylim([0 4]*1e-3)

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
function y = nonLinApp(x, k)
[~, ind] = sort(abs(x), 'descend');
y = zeros(size(x));
y(ind(1:k)) = x(ind(1:k));
end