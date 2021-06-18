# Optode Calibrations

The MatLab scripts and tools in this directory are written to faciliate the two-point calibration of oxygen optodes in the lab. The SOP is outlined in Two-Point Oxygen Optode Calibration Procedure (DCN 3305-00715) with supporting Calibration Log (3305-00715-00000) and Oxygen Optode Calibration Form (3305-01715).

## Usage
An example matlab script and dataset is provided in the examples subfolder. The code was developed on MatLab version ```R2021a``` and requires installation of the ```Statistics``` toolbox. 

The primary processing script is ```process_optode_data.m```. Supporting function and subfunction names all begin with  ```f_```. When starting the ```processing_optode_data.m``` ensure that the supporting functions are added to the path.

Similarly, the paths to the optode and barometer data will need to be amended to point to the location of the data you want to process.


## Meta
Author: Andrew Reed
Email: areed@whoi.edu
Version: 1.0
