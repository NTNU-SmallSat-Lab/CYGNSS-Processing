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
Not all scripts run in Matlab error free as they are written from Octave

## Processing instructions

### crop_DDM
...

### Load_CYGNSS_netCDF_Land_Level1.m
...

### Load_CYGNSS_netCDF_Level1.m
...

### plot_FFT_DDMs_binary1.m
...

### Plot_rawIF_Tracks_land.m
...

### Plot_rawIF_Tracks.m
...

### process_rawIF_metadata
* Run the script after modifying path the the raw IF samples and the corresponding meta data .bin files 
* Output is info about the data from the bin files: Satellites ID, sampling rate, length of data, date/time of sampling, channels used
