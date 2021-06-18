function X = f_exp_smooth(X, ts, tau)
% F_EXP_SMOOTH  Exponential smooth timeseries
% 
% Syntax: X = f_load_barometer(X, ts, tau)
%
% Parameters:
%   X - vector with evenly spaced input data
%   ts - sampling rate of X in seconds
%   tau - response time in seconds (time to 63.2%)
%
% Returns:
%   X - the vector with smoothed data
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Andrew Reed
% Work: OOI-CGSN, Woods Hole Oceanographic Institution
% Email: areed@whoi.edu
% May 2021

% ------------- BEGIN CODE --------------
% Compute the smoothing constant
alpha = exp(-ts/tau);

% Find lenght of data
N = length(X);

% Smooth the data
for n = 2:N
    % Apply the filter
    X(n) = alpha*X(n-1) + (1 - alpha)*X(n);
end
% -------------- END CODE ---------------
    