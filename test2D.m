clear
close all
clc

temp = load('In\KLT_image.mat'); K = temp.K;
temp = load('In\SOT_image.mat'); E = temp.E;
N = length(K);

fld_images = 'Set image testing/';
imagebase = dir(fullfile(fld_images, '*.tiff'));

dwtmode('per')
wavelet_name = 'db4';
perc = 0.01:0.01:0.15;

psnr_dmt = zeros(length(imagebase),length(perc));
psnr_dct = zeros(length(imagebase),length(perc));
psnr_dwt = zeros(length(imagebase),length(perc));
psnr_klt = zeros(length(imagebase),length(perc));
psnr_sot = zeros(length(imagebase),length(perc));
for ii = 1:length(imagebase)
    
    str = imagebase(ii).name;
    disp(str)
    x = imread(strcat(fld_images,str));
    if length(size(x))==3
        x = rgb2gray(x);
    end
    x = double(x);
 
    %%%% DMT %%%%%
    fprintf('Mirror Transform loading...\n')
    [X_dmt, ~, ~] = mirrorTransform2D_fast(x,'dmt');
    fprintf('Mirror Transform computed.\n')
    
    for k = 1:length(perc)
        K = round(perc(k)*numel(x));
        X_nonlinapp = nonLinApp(X_dmt, K);
%         [x_dmt_rec, ~] = inverseMirrorTransform2D(X_nonlinapp, n0_table, flag_table);
        my_mse = sum((X_dmt(:)-X_nonlinapp(:)).^2)/numel(x);
        psnr_dmt(ii,k) = 20*log10(255/sqrt(my_mse));
        
    end
    
    %%%%% DCT %%%%%
    X_dct = dct2(x);
    for k = 1:length(perc)
        K = round(perc(k)*numel(x));
        X_dct_nonlinapp = nonLinApp(X_dct, K);
        x_dct_rec = idct2(X_dct_nonlinapp);
        my_mse = sum((x(:)-x_dct_rec(:)).^2)/numel(x);
        psnr_dct(ii,k) = 20*log10(255/sqrt(my_mse));
    end
    
    %%%%% DWT %%%%%
    L = wmaxlev(size(x),wavelet_name);
    [C,S] = wavedec2(x,L,wavelet_name);
    for k = 1:length(perc)
        K = round(perc(k)*numel(x));
        C_nonlinapp = nonLinApp(C, K);
        x_dwt_rec =  waverec2(C_nonlinapp, S, wavelet_name);
        my_mse = sum((x(:)-x_dwt_rec(:)).^2)/numel(x);
        psnr_dwt(ii,k) = 20*log10(255/sqrt(my_mse));
    end

    %%%%% KLT and SOT %%%%%
    fun = @(block_struct) T(block_struct.data, K');
    X_klt = blockproc(x, [N, N], fun);
    fun = @(block_struct) T(block_struct.data, E');
    X_sot = blockproc(x, [N, N], fun);
    for k = 1:length(perc)
        X_klt_nonlinapp = nonLinApp(X_klt, round(perc(k)*numel(x)));
        X_sot_nonlinapp = nonLinApp(X_sot, round(perc(k)*numel(x)));
%         fun = @(block_struct) nonLinApp(block_struct.data, round(perc(k)*N^2));
%         X_klt_nonlinapp = blockproc(X_klt, [N, N], fun);
%         X_sot_nonlinapp = blockproc(X_sot, [N, N], fun);

        fun = @(block_struct) inv_T(block_struct.data,K);
        x_klt_rec =  blockproc(X_klt_nonlinapp, [N, N], fun);
        my_mse = sum((x(:)-x_klt_rec(:)).^2)/numel(x);
        psnr_klt(ii,k) = 20*log10(255/sqrt(my_mse));

        fun = @(block_struct) inv_T(block_struct.data,E);
        x_sot_rec =  blockproc(X_sot_nonlinapp, [N, N], fun);
        my_mse = sum((x(:)-x_sot_rec(:)).^2)/numel(x);
        psnr_sot(ii,k) = 20*log10(255/sqrt(my_mse));
    end

end

%%%%% Plot %%%%%
plot(perc*100, mean(psnr_dwt), 'r','LineWidth',1.2)
hold on
plot(perc*100, mean(psnr_dct), 'k','LineWidth',1.2)
plot(perc*100, mean(psnr_klt), 'm','LineWidth',1.2)
plot(perc*100, mean(psnr_sot),'LineWidth',1.2,'Color',[0.4660 0.6740 0.1880])
plot(perc*100, mean(psnr_dmt), 'b','LineWidth',1.2)
grid on
legend('DWT', 'DCT','KLT','SOT','DMT','Location','southeast')
xlabel('% non-zero coefficients'), ylabel('PSNR')
xlim([5, 15])

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
function y = T(x, M)
    N = size(x,1);
    y = reshape(M*x(:), [N, N]); 
end

function y = nonLinApp(x, k)
[~, ind] = sort(abs(x(:)), 'descend');
y = zeros(size(x));
y(ind(1:k)) = x(ind(1:k));
end

function y = inv_T(x, M)
    N = 8;
    y = reshape(M*x(:), [N, N]);
end