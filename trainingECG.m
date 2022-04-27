clear
close all
clc

fld_ecg = 'Set ECG training/';
dirinfo = dir(fld_ecg);
dirinfo = dirinfo(3:end);
subdirinfo = cell(1,length(dirinfo));

% 400-sample windows
L = 400;

total = 0;
for K = 1 : length(dirinfo)
    thisdir = dirinfo(K).name;
    subdirinfo{K} = dir(fullfile(strcat(fld_ecg,thisdir), '*.mat'));
    total = total + length(subdirinfo{K});
end
total = total*3600/L;

X = zeros(total,L);

count = 1;
for jj = 1:length(subdirinfo)
    ecgbase = subdirinfo{jj};
    for ii = 1:length(ecgbase)

        str = ecgbase(ii).name;
        disp(str)
        x = load(strcat(fld_ecg,dirinfo(jj).name,'/',str)).val;
        x = x-min(x);
        x = x/max(x);
        for kk = 1:floor(length(x)/L)
            X(count,:) = x((kk-1)*L+1:kk*L);
            count = count + 1;
        end

    end
end

C = cov(X);
[K,D] = eig(C);
% save('In/Training ECG sequences.mat','X')
% save('In/KLT_ECG.mat','K')