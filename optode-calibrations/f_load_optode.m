function [optode, floc] = f_load_optode(dataPath, fstart)
% F_LOAD_OPTODE  Load Aanderaa oxygen optode data into a named table
%
% Syntax: optode = f_load_optode(dataPath)
%
% Parameters:
%   dataPath - the directory path where the optode data is saved.
%   fstart - where in the file to start reading (for files with data
%       already loaded)
% 
% Returns:
%   optode - a named table with the parsed optode data with timestamps
%
% Other m-files required: None
% Subfunctions: None
% MAT-files required: None
%
% Author: Andrew Reed
% Work: OOI-CGSN, Woods Hole Oceanographic Institution
% Email: areed@whoi.edu
% April 2021

% ------------- BEGIN CODE -------------
fid = fopen(dataPath);

if exist('fstart', 'var')
    fseek(fid, fstart, 'bof');
end

% Initialize the data
timestamps = [];
data = [];
i = 1;

% Set the variable names for the output table
varNames = ["timestamp", "model", "serialNumber", "oxygenConcentration",...
    "oxygenSaturation", "temperature", "calibratedPhase",...
    "tempcompensatedCalibratedPhase", "bluePhase", "redPhase",...
    "blueAmplitude", "redAmplitude", "rawTemperature"];

% Iterate through the file line-by-line and parse the optode data
while ~feof(fid)
    fline = fgetl(fid);
    if isempty(fline)
        continue
    end
    % Get the timestamp of the measurement
    ind1 = strfind(fline, "[");
    ind2 = strfind(fline, "]");
    timestamp = datenum(fline(ind1+1:ind2-1));
    timestamps(i,1) = timestamp;
    % Read in the other data
    fline = replace(fline, "!", "");
    fline = fline(ind2+1:end);
    data(i,:) = sscanf(fline, '%f')';
    i = i+1;
end

% Get where the file is closed out
floc = ftell(fid);

% Close the file
fclose(fid)

% Parse the data into a table
data = [timestamps, data];
optode = array2table(data);
optode.Properties.VariableNames = varNames;
% ------------- END CODE -------------