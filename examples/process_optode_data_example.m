% Script to process the optode data
clear all; close all;
addpath("..")  

%% ===================================================================== %%
% Set the location to where the optode and barometric data are stored
optPath = "examples/results/507/optode/2021-06-09.log";
barPath = "examples/results/507/barometer/2021-06-09.CSV";

% Load the optode and barometer data
optode = f_load_optode(optPath);
barometer = f_load_barometer(barPath);

% Interpolate the barometer data to the optode timestamps
barometer = f_interp_barometer(barometer, optode);

% Create a time variable of elapsed minutes
optode.minutes = etime(datevec(optode.timestamp), datevec(optode.timestamp(1)))/60;
barometer.minutes = etime(datevec(barometer.timestamp), datevec(barometer.timestamp(1)))/60;

%% ===================================================================== %%
% Calculate the oxygen solubility values
solO2 = f_O2sol(0, optode.temperature);

% Calculate the predicted dissolved oxygen based on the solubility and
% atmospheric pressure (converting from mbar to atm)
DO = (barometer.pressure ./ 1013.25) .* solO2;

%% ===================================================================== %%
% Filter the data using an exponential filter
%   Response times for Aanderaa optode
%       T = 10 seconds
%       O2 = 25 seconds
%   Sampling period = 2 seconds
cO2 = f_exp_smooth(optode.oxygenConcentration, 2, 25);
T = f_exp_smooth(optode.temperature, 2, 10);

%% ===================================================================== %%
% Plot the optode dissolved oxygen and temperature
yyaxis left
s1 = scatter(optode.minutes, optode.oxygenConcentration, "b.");
hold on
s2 = scatter(optode.minutes, cO2, "g.");
s5 = plot(optode.minutes, DO, "k:");
xlabel("Elapsed time [minutes]")
ylabel("Oxygen Concentration [umol/kg]")
yyaxis right
s3 = scatter(optode.minutes, optode.temperature, "r.");
hold on
s4 = scatter(optode.minutes, T, "y.");
legend([s1, s2, s3, s4, s5], ["Optode O2","Filtered O2","Optode T","Filtered T", "Calculated DO"])
ylabel("Optode Temperature [\circC]")


%% ========================================================================
% Fit 100% saturated values
%   1. Using the plot, identify a start and end time based on stable
%      temperature and oxygen readings
tstart = 50;
tend = 55;

%   2. Get the data within the identified start and end times
data = optode.oxygenConcentration(optode.minutes >= tstart & optode.minutes <= tend);
phase = optode.tempcompensatedCalibratedPhase(optode.minutes >= tstart & optode.minutes <= tend);
temp = optode.temperature(optode.minutes >= tstart & optode.minutes <= tend);
pres = barometer.pressure(barometer.minutes >= tstart & barometer.minutes < tend);

%   3. Calculate the mean and standard deviation of the selected data
avgSat = mean(data)
stdSat = std(data)

%   3a. Also calculate the phase values (for the calibration history)
avgPhase = mean(phase)
stdPhase = std(phase)

%   3b. Calculate the temperature values
avgT = mean(temp)
stdT = std(temp)

%   3c. Calculate the barometric pressure values
avgP = mean(pres)
stdP = std(pres)

%   4. Calculate the mean and standard deviation of the estimated DO
data = DO(optode.minutes >= tstart & optode.minutes <= tend);
avgSol = mean(data)
stdSol = std(data)

%% ===================================================================== %%
% Fit zero-point value
%   1. Using the plot, find a five-minute time span where the temperature 
%      is stable.
tstart = 100;
tend = 105;

%   2. Get the data within the identified start and end times
data = optode.oxygenConcentration(optode.minutes >= tstart & optode.minutes <= tend);
phase = optode.tempcompensatedCalibratedPhase(optode.minutes >= tstart & optode.minutes <= tend);
temp = optode.temperature(optode.minutes >= tstart & optode.minutes <= tend);
pres = barometer.pressure(barometer.minutes >= tstart & barometer.minutes < tend);

%   3. Calculate the mean and standard deviation of the selected data
avgZero = mean(data)
stdZero = std(data)

%   3a. Calculate the phase values
avgPhase0 = mean(phase)
stdPhase0 = std(phase)

%   3b. Calculate the temp values
avgT0 = mean(temp)
stdT0 = std(temp)

%   3c. Calculate the barometric pressure values
avgP0 = mean(pres)
stdP0 = std(pres)

%% ===================================================================== %%
% Next, fit a regression of the measured data to the expected DO values 
X = [avgZero, avgSat]   % Measured values
y = [0, avgSol]         % Expected dissolved oxygen
fitlm(X, y)             % Fit a linear regression to the data

% An alternative to using regressionn matrix algebra: y = bX -> b = X\y
y = [avgSol; 0]             % Expected dissolved oxygen
X = [1 avgSat; 1 avgZero]   % Measured values; ones allow for intercept
b = X\y                     % This is the slope and offset.