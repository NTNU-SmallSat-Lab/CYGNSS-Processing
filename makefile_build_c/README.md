<!-- Title -->
# CYGNSS Raw IF Processing Code Build instruction
The folder contains the c-code for processing the raw IF samples from CYGNSS

## Folder Contents
C-files
* mainwindow.c
* CYGNSS_DDMP_Processing.c 
* CYGNSS_DDMP_Main.c 
* fftw_acquire.c
* code_table.c


## Dependencies
* libfftw3-dev
* math (default included in using linux)

## Build instructions
### Build natively in Linux
* Run 
```
make
```
in terminal. See top level build instructions for more details.

### Using Docker 
Docker is recommended using Mac and Windows (Windows Subsystem for Linux (WSL)). Works just as fine for Linux

* Install Docker see  [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
* Start Docker
* Make cygnss.sh executable
```
chmod +x cygnss.sh 
```
* Build with Docker container by running 
```
./cygnss.sh build
```
in terminal. Bash script is handling the dependencies and any updates of these.

### Using Docker with WSL
You can simply download and install Docker for Windows, and link it to your WSL distro. Some useful information is found here: 
* Install Docker for Windows: https://docs.docker.com/desktop/setup/install/windows-install/
* Docker only works on WSL2, so make sure you have that, or convert your install: https://ericsysmin.com/2019/07/13/converting-wsl-1-operating-systems-to-wsl-2-on-windows/
* Enable docker for WSL: https://docs.docker.com/desktop/features/wsl/

## Run instructions
* Update line starting with ^F in your '.dat' config file of choice an point to where you have placed the the '.bin' you would like to process file. 

### Process natively in Linux
* Run 
```
./CYGNSS_DDM_Processor
```
in terminal

### Process using Docker container
* Note: If you have created a new folder for the raw IF data (.bin) inside 'makefile_build_c' rebuild the container first with
```
./cygnss.sh build
```
* Run 
```
./cygnss.sh run
```
in terminal to run processing based on config in 'CYGNSS_DDMP_config.dat' on or
```
 ./cygnss.sh run ANOTHERDATFILE.dat'
```
in the terminal to specify another .dat that used when building process via the container.
* For first time use it is recommended to run 
```
 ./cygnss.sh run CYGNSS_DDMP_config_ex_cyg08_raw_if_s20170825_141629.dat'
```
which will process 'RawIFData/cyg08_raw_if_s20170825_141629_e20170825_141729_data.bin'.
### Output
* Output file is 'Processed_DDMs.bin

## Get DDM picture
* run 
```
plot_FFT_DDMs_binary1.m 
```
in MATLAB or Octave. If 'RawIFData/cyg08_raw_if_s20170825_141629_e20170825_141729_data.bin' is processed with the settings in the example config, then the cropped DDM output will look like this:
![Processed_DDMs_cropped_ddm1](https://github.com/user-attachments/assets/d388644a-e0d6-45f5-90f4-fa2ab15511d4)
