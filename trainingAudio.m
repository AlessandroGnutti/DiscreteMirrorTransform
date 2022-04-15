clear
close all
clc

fld_audio = 'Binario ottimo/Set audio training/';
audiobase = dir(fullfile(fld_audio, '*.wav'));

% 400-sample windows
L = 400;

% Count the number of windows
total = 0;
for ii = 1:length(audiobase)

    str = audiobase(ii).name;
    disp(str)
    [y, Fs] = audioread(strcat(fld_audio,str));
    y = mean(y,2);
    max_length = min(length(y),Fs*7); % Max 7 seconds
    y = y(1:max_length);
    total = total + floor(length(y')/L);

end

X = zeros(total,L);
count = 1;
for ii = 1:length(audiobase)

    str = audiobase(ii).name;
    disp(str)
    [y, Fs] = audioread(strcat(fld_audio,str));
    y = mean(y,2);
    max_length = min(length(y),Fs*7); % Max 7 seconds
    y = y(1:max_length);
    y = y-min(y);
    y = y/max(y);

    for jj = 1:floor(length(y)/L)

        X(count,:) = y((jj-1)*L+1:jj*L);
        count = count + 1;
    end

end

C = cov(X);
[K,D] = eig(C);
% save('In/Training audio sequences.mat','X')
% save('In/KLT_audio.mat','K')