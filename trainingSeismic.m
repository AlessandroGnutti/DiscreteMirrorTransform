clear
close all
clc

fld_seismic = 'Set seism training/';
seismicbase = dir(fullfile(fld_seismic, '*.sac'));

% 400-sample windows
L = 400;

% Count the number of windows
total = 0;
for ii = 1:length(seismicbase)

    str = seismicbase(ii).name;
    disp(str)
    x = rdsac(strcat(fld_seismic,str));
    x = x.d;
    total = total + floor(length(x)/L);

end

X = zeros(total,L);
count = 1;
for ii = 1:length(seismicbase)

    str = seismicbase(ii).name;
    disp(str)
    x = rdsac(strcat(fld_seismic,str));
    x = x.d;
    x = x-min(x);
    x = x/max(x);

    for jj = 1:floor(length(x)/L)

        X(count,:) = x((jj-1)*L+1:jj*L);
        count = count + 1;
    end

end

C = cov(X);
[K,D] = eig(C);
save('In/Training seismic sequences.mat','X')
save('In/KLT_seismic.mat','K')