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

## Input Data Files
CYGNSS Raw IF files that are used as input for this processing can be downloaded from the PO.DAAC at [https://podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF](https://podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF)

Recommended download site: [NASA EarthData CMR Virtual Directories](https://cmr.earthdata.nasa.gov/virtual-directory/collections/C2036882037-POCLOUD/temporal)