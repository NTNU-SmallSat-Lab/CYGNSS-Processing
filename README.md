<!-- Title -->
# CYGNSS Raw IF Processing Code
This repo contains the code needed for processing and analyzing CYGNSS Raw IF Collections

## Repo Contents

### Documentation
Instructions for building the C code and an example of how to perform the processing on a Raw IF collection

### Makefile Build C
C code and Makefile for processing the binary Raw IF files. Instructions for how to create the build environment to build the code can be found in the 'documentation' directory

See README in makefile_build_c folder for a guide on how build and run the c-code processing using Docker container.

### Post-processing Script
Matlab/Octave code for analyzing on the results of the C code

Note: Not all post-processing scripts are compatible with current Matlab versions. Octave is recommended.

## Input Data Files
CYGNSS Raw IF files that are used as input for this processing can be downloaded from the PO.DAAC at [https://podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF](https://podaac.jpl.nasa.gov/dataset/CYGNSS_L1_RAW_IF)

Recommended download site: [NASA EarthData CMR Virtual Directories](https://cmr.earthdata.nasa.gov/virtual-directory/collections/C2036882037-POCLOUD/temporal)