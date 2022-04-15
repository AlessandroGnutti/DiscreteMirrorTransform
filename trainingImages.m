clear
close
clc

fld_images = 'Set mage training/';
imagebase = dir(fullfile(fld_images, '*.tiff'));

tot_pixel = 0;
for ii = 1:length(imagebase)
    str = imagebase(ii).name;
    disp(str)
    x = imread(strcat(fld_images,str));
    if length(size(x))==3
        x = rgb2gray(x);
    end
    tot_pixel = tot_pixel + numel(x);
end

N = 8;
X = zeros(tot_pixel/N^2,N^2);
count = 1;
for ii = 1:length(imagebase)
    str = imagebase(ii).name;
    disp(str)
    x = imread(strcat(fld_images,str));
    if length(size(x))==3
        x = rgb2gray(x);
    end
    x = double(x);
    for r = 1:size(x,1)/N
        for c = 1:size(x,2)/N
            B = x(N*(r-1)+1:N*r,N*(c-1)+1:N*c);
            X(count,:) = B(:)';
            count = count + 1;
        end
    end
end

C = cov(X);
[K,D] = eig(C);
% save('In/KLT_image.mat','K')
% save('In/Training image blocks.mat','X')
