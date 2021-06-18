% Script to plot the optode data as it comes in
clear all; close all;
addpath("..")  

%% ===================================================================== %%
% Set the location to where the optode and barometric data are stored
optPath = "../data/optode/2021-05-21.log";

% Load the optode data
if exist('floc')
    % Read in the newest data
    [new_data, floc] = f_load_optode(optPath, floc);
    % Append the newest data
    optode = [optode; new_data];
    new_flag = 1;
else
    [optode, floc] = f_load_optode(optPath);
end

% Calculate a elapsed time vector
optode.minutes = etime(datevec(optode.timestamp), datevec(optode.timestamp(1)))/60;

% Exponentially smooth the data
cO2 = f_exp_smooth(optode.oxygenConcentration, 2, 25);
T = f_exp_smooth(optode.temperature, 2, 10);

%% ===================================================================== %%
% Plot the optode dissolved oxygen and temperature
yyaxis left
scatter(optode.minutes, optode.oxygenConcentration, "b.")
hold on
scatter(optode.minutes, cO2, "g.")
ylabel("Optode Oxygen Concentration [umol/kg]")
yyaxis right
scatter(optode.minutes, optode.temperature, "r.")
scatter(optode.minutes, T, "k.")
ylabel("Optode Temperature [\circC]")

%% ========================================================================
% Next, calculate the target saturation
DO = f_pred_oxygen(0, optode.temperature, 1031, "mbar");

%% ========================================================================
% Now predict temperature stability
target_T = 25;
dTdt = zeros(size(T));
delT = zeros(size(T));
dt = 2/60;
N = length(T);

for n = 2:N
    dTdt(n) = (T(n) - T(n-1)) / dt;
    avgT = (T(n) + T(n-1))/2;
    dTdt(n) = (dTdt(n)/avgT)*100;
    delT(n) = abs(T(n) - target_T) / dt;
    delT(n) = (delT(n) / target_T)*100;
end

% Plot the stability predictor
figure;

yyaxis left
scatter(optode.minutes, dTdt, "b.")
ylabel("dT / dt")
grid on

yyaxis right
scatter(optode.minutes, delT, "r.")
ylabel("\DeltaT / dt")

% Calculate moving average filter
smooth_dTdt = movavg(