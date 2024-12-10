<!-- Title -->
# CYGNSS Raw IF Processing Code
This repo contains the code needed for processing and analyzing CYGNSS Raw IF Collections

## About CYGNSS
CYGNSS is a NASA Earth Venture mission led by the Department of Climate and Space Sciences and Engineering in the University of Michigan’s College of Engineering. 

CYGNSS consists of eight satellites that measure surface wind speed in tropical cyclones to improve storm forecasting. 

For more about CYGNSS see [https://podaac.jpl.nasa.gov/CYGNSSF]( https://podaac.jpl.nasa.gov/CYGNSS) and [https://cygnss.engin.umich.edu](https://cygnss.engin.umich.edu)

GYGNSS samples at 16.036200 MHz. The sampling frequency is derived from post processing of raw data files. See bottom of the page.
The processing code in this repo uses Inphase sample only (only I, not Q)

Normal use/data format (default for most collections):
* Channel 1,2,3, I samples only

Unusual use/data format (should be doubled checked)
* Channel 1, I samples only
* Channel 1 and 2, I samples only
* Channel 1,2. I and Q samples. Will not work with processor (found in Makefile Build C).

Erroneous data format:
* Channel 1,2,3,4 I samples only. There is no channel 4 connected.

See the post processing scripts for check to check the data format.

## Repo Contents

### Documentation
Instructions for building the C code and an example of how to perform the processing on a Raw IF collection

### Makefile Build C
C code and Makefile for processing the binary Raw IF files. Instructions for how to create the build environment to build the code can be found in the 'documentation' directory

See README in makefile_build_c folder for a guide on how build and run the c-code processing using Docker container.

### Post Processing Scripts
Matlab/Octave code for analyzing on the results of the C code

Note: Not all post-processing scripts are compatible with current Matlab versions. Octave is recommended.

## Raw intermediate frequency (IF) sample input data files
CYGNSS Raw IF files that are used as input for this processing can be downloaded from the PO.DAAC at [https://podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF](https://podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF)

Recommended download site is [Search Granules](https://search.earthdata.nasa.gov/search/granules?p=C2036882037-POCLOUD) where one can search for for specific data products. An alternative is [NASA EarthData CMR Virtual Directories: CYGNSS Level 1 Raw Intermediate Frequency Data Record](https://cmr.earthdata.nasa.gov/virtual-directory/collections/C2036882037-POCLOUD/temporal) where one is clicking trough the published data by year, month and day.

For batch download of multiple data [podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF)](https://podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF) and more specifically [Search Granules](https://search.earthdata.nasa.gov/search/granules?p=C2036882037-POCLOUD) is recommended.

### Download procedure
* Create an account at [urs.earthdata.nasa.gov](https://urs.earthdata.nasa.gov/) and login
* Go to [Search Granules](https://search.earthdata.nasa.gov/search/granules?p=C2036882037-POCLOUD) and search for the data you would like
* Hit the + on a given data file to enable download. 
* When your have choosen your data hit the green Download button in the bottom of the screen. It will indicate how many data Granule ID (data and meta files) your have chosen. If you would like to download all data, do not choose any files and hit the green Download All.
* If your are logged in you will be redirected. Choose a project name of your own choice. E.g. CYGNSS-data. Then hit Download Data
* You will now be have several download options. If you have chosen only a few Granule IDs (data and meta files) you can hit the links listed under Download Files and accept then download if your system request that of you. If you have choosen several Granule IDs, hit Download Script instead. Then hit Save that in top right of the preview box of the script content. Follow the guide written for Linux (also works on Mac) or Windows enabling to execute the script. If you are a Windows user [Windows WSL](https://learn.microsoft.com/en-us/windows/wsl/) is recommended.
* Execute the script in the folder of your choice. Enter your username (at [urs.earthdata.nasa.gov](https://urs.earthdata.nasa.gov/)) and hit enter. Then enter your password and hit enter. 
The files (*data.bin and *meta.bin) is download to said folder. The download can take considerable time.

## Other data products.
University of Michigan (UMICH) is listing all of the CYGNSS data products [https://cygnss.engin.umich.edu/data-products/ ](ttps://cygnss.engin.umich.edu/data-products/)

To download:
* Go to [https://cygnss.engin.umich.edu/data-products/ ](ttps://cygnss.engin.umich.edu/data-products/)
* Click on the data product of choice.
* Then hit 'Data Access'
* Click link under 'Search Granules' and do the search.