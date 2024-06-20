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

## Run instructions
* Update line 22 in 'CYGNSS_DDMP_config.dat' with downloaded .bin file containing raw IF samples

### Process natively in Linux
* Run 
```
./CYGNSS_DDM_Processor
```
in terminal

### Process using Docker container
* Run 
```
./cygnss.sh run
```
in terminal to run processing based on config in 'CYGNSS_DDMP_config.dat' on or
```
 ./cygnss.sh run ANOTHERDATFILE.dat'
```
in the terminal to specify another .dat that used when building process via the container.
### Output
* Output file is 'Processed_DDMs.bin

## Get DDM picture
* run 
```
plot_FFT_DDMs_binary1.m 
```
in Octave. plot_FFT_DDMs_binary1.m is not compatible with Matlab