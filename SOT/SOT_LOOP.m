% Copyright Osman G. Sezer and Onur G. Guleryuz 2015
%
% Routines that generate the transforms derived in:
%
% Sezer, O.G.; Guleryuz, O.G.; Altunbasak, Y., "Approximation and Compression With Sparse Orthonormal Transforms," in Image Processing,
% IEEE Transactions on , vol.24, no.8, pp.2328-2343, Aug. 2015
%
% http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7065257&isnumber=7086144
%
function [E,X] = SOT_LOOP(E,X)

Lambdas = [800 500 200 100 50 30 20 5]/400;
Lambdas = Lambdas.*Lambdas;

for count=1:length(Lambdas)
    disp(count)

    Lambda = Lambdas(count);

    % Find optimum bases using cost minimization algorithm
    E = SOT_SINGLE(Lambda,X,E);


end



