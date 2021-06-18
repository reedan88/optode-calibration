function DO = f_pred_oxygen(S, T, P, units)
% F_PRED_OXYGEN  Predict dissolved oxygen concentration
% 
% Syntax: DO = f_pred_oxygen(S, T, P, "units")
%
% Parameters:
%   S - salinity (in psu)
%   T - temperature (in deg C)
%   P - barometric pressure
%   units - the units of presure (atm or mbar)
%
% Returns:
%   DO - the predicted dissolved oxygen concentration
%
% Other m-files required: f_O2sol
% Subfunctions: None
% MAT-files required: None
%
% Author: Andrew Reed
% Work: OOI-CGSN, Woods Hole Oceanographic Institution
% Email: areed@whoi.edu
% May 2021

% ------------- BEGIN CODE --------------
% Convert the pressure to atm if in mbar
if strcmp(units, "mbar")
    P = P./1013.25;
end

% Calculate the oxygen solubility
solO2 = f_O2sol(S,T);

% Correct for atmospheric pressure
DO = P.*solO2;
% -------------- END CODE ---------------