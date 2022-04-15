% clear
close all
clc

fld_images = 'Imageset_Completo/';
imagebase = dir(fullfile(fld_images, '*.tiff'));

dwtmode('per')
wavelet_name = 'db4';
perc = 0.01:0.01:0.15;


psnr_dmt = zeros(length(imagebase),length(perc));
psnr_odmt = zeros(length(imagebase),length(perc));
psnr_dct = zeros(length(imagebase),length(perc));
psnr_dwt = zeros(length(imagebase),length(perc));
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

end

%%%%% Plot %%%%%
plot(perc*100, mean(psnr_dwt), 'r', perc*100, mean(psnr_dct), 'k', perc*100, mean(psnr_dmt), 'b', perc*100, mean(psnr_odmt), 'b--')
grid on
legend('DWT', 'DCT','DMT','ODMT')
xlabel('% non-zero coefficients'), ylabel('PSNR')

%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%
function y = nonLinApp(x, k)
[~, ind] = sort(abs(x(:)), 'descend');
y = zeros(size(x));
y(ind(1:k)) = x(ind(1:k));
end