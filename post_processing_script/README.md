<!-- Title -->
# CYGNSS Post Processing Script Documention
The folder contains the .m files/scripts used to post processing of CYGNSS data

## Folder Contents
.m files
* crop_DDM.m
* Load_CYGNSS_netCDF_Land_Level1.m
* Load_CYGNSS_netCDF_Level1.m
* plot_FFT_DDMs_binary1.m
* Plot_rawIF_Tracks_land.m
* Plot_rawIF_Tracks.m
* process_rawIF_metadata.m

.mat
* mapworld.mat

## Dependencies
Not all scripts run in Matlab error free as they are written for Octave.

## Processing instructions

### plot_FFT_DDMs_binary1.m
Used to plots processed DDM. Not yet studied if this script work as is.

### crop_DDM
Used by plot_FFT_DDMs_binary1.m to crop processed DDMs.

### Plot_rawIF_Tracks_land.m
Run script to get a track of rawIF samples taken by a given CYGNSS satellite over land. Not yet updated. Need to be updated to support call to process_rawIF_metadata.

### Load_CYGNSS_netCDF_Land_Level1.m
Used to load CYGNSS netCDF data from observations over land. Not yet studied if this script work as is.

### Plot_rawIF_Tracks.m
Run script to get a track of rawIF samples taken by a given CYGNSS satellite. Specific path to .meta and level1 .nc file. The meta file is needed to get the time of the raw IF samples. The .nc file for getting information about the latitude and longitude among other things. 

### Load_CYGNSS_netCDF_Level1.m
Used to load CYGNSS netCDF data from observations. 

### process_rawIF_metadata
Callable function used by Plot_rawIF_Tracks.m and Plot_rawIF_Tracks_land in the future.

### process_rawIF_metadata
* Run the script after modifying path the the raw IF samples and the corresponding meta data .bin files 
* Output is info about the data from the bin files: Satellites ID, sampling rate, length of data, date/time of sampling, channels used etc.
