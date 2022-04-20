    % Copyright Osman G. Sezer and Onur G. Guleryuz 2015
%
% Routines that generate the transforms derived in: 
%
% Sezer, O.G.; Guleryuz, O.G.; Altunbasak, Y., "Approximation and Compression With Sparse Orthonormal Transforms," in Image Processing, 
% IEEE Transactions on , vol.24, no.8, pp.2328-2343, Aug. 2015
%
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7065257&isnumber=7086144
%

% First load the training data
load('../In/Training image blocks.mat')
% load('../In/Training audio sequences.mat')
% load('../In/Training seismic sequences.mat')
% load('../In/Training ECG sequences.mat')

X = X';
E=eye(size(X,1));

% for faster convergence
% modify diff=abs(cprev)*1e-6; to
% diff=abs(cprev)*1e-4; or lower
% in SOT_SINGLE.m
[E,X] = SOT_LOOP(E, X);
