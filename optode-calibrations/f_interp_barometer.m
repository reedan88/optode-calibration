function barometer = f_interp_barometer(barometer, optode)
% F_LOAD_BAROMETER  Load barometer data for oxygen calibrations into a table
% 
% Syntax: barometer = f_load_barometer(dataPath)
%
% Parameters:
%   barometer - a table with the parsed barometer data
%   optode - a table with the parsed optode data
%
% Returns:
%   barometer - a table with the barometer data interpolated to the optode
%       timestamps
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Andrew Reed
% Work: OOI-CGSN, Woods Hole Oceanographic Institution
% Email: areed@whoi.edu
% April 2021

% ------------- BEGIN CODE --------------
% Interpolate the barometer data
new_t = optode.timestamp;
newP = interp1(barometer.timestamp, barometer.pressure, new_t);
newT = interp1(barometer.timestamp, barometer.temperature, new_t);
newRH = interp1(barometer.timestamp, barometer.relativeHumidity, new_t);

% Put the interpolated data into a nicely formatted table
barometer = table(new_t, newT, newP, newRH);
barometer.Properties.VariableNames = ["timestamp","temperature","pressure","relativeHumidity"];
% -------------- END CODE ---------------