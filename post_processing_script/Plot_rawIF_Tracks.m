%
% Plot_rawIF_Tracks.m
%
% STG, Sept 2017
% Updated Aug 2020 to account for 2Hz DDMs
close all
clear all
clc
format long

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse meta data file

% Set path and file name of meta data for this collection
%fid = fopen('../Input_DMR_Data_2Hz/cyg03_raw_if_s20200810_201245_e20200810_201345_meta.bin');

%process_rawIF_metadata
%fclose(fid);
file_path       = '/Users/thb/Library/CloudStorage/OneDrive-NTNU/Prosjekter/GNSS-R/CYGNSS data';
meta_file       = 'cyg01_raw_if_s20180822_142659_e20180822_142759_meta.bin';
level1_file     = 'cyg01.ddmi.s20180822-000000-e20180822-235959.l1.power-brcs.a32.d33.nc'; % must end with .l1.power-brcs.aXX.dXX.nc
[satID_FM,gpsweek, gpssecs]  = process_rawIF_metadata( file_path, meta_file );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colors = ['c', 'k', 'b', 'g', 'r', 'm'];

if(exist('gpssecs_ddm','var') == 0)

  % 2Hz CYGNSS Level 1 netcdf file
  %filename = '../Input_DMR_Data_2Hz/cyg03.ddmi.s20200810-000000-e20200810-235959.l1.power-brcs.a21.d21.nc'; % SLV, 2Hz
  filename = fullfile( file_path, level1_file );
  
  Load_CYGNSS_netCDF_Level1
end

% start gpssecond of rawIF collection
start_raw_gpssec = gpssecs;
rawIF_duration = 60; % seconds
% For 1Hz data
%samples_per_second = 1;
% For 2Hz data
samples_per_second = 2;

% UTC hours  ... sort of useful
utc_hour = utc_time./3600;

% find the index for this second in L1 netcdf file on the same day as the rawIF
start_rawIF_idx = find(round(gpssecs_ddm) == start_raw_gpssec);

% fix for 2Hz darta: double number of samples, 2 per second, 120 total for 60s collection
end_rawIF_idx = start_rawIF_idx + rawIF_duration*samples_per_second;

rawIF_idxs = [start_rawIF_idx:end_rawIF_idx];
UTC_hours_rawIF = utc_hour(rawIF_idxs);

% Grab SP locations for all 4 channels ... brut force ugly way
SP_lat_1        = sp_lat(1,rawIF_idxs);
% SP_lon_1        = sp_lon(1,rawIF_idxs) - 360;
SP_lon_1        = sp_lon(1,rawIF_idxs);
prn_code1       = prn_code(1,rawIF_idxs);
PRN1            = prn_code1(1);
ddm_ant1        = ddm_ant(1,rawIF_idxs);
ANT1            = ddm_ant1(1);
sp_dopp1        = sp_ddmi_dopp(1,rawIF_idxs);
start_dopp1     = sp_dopp1(1);
end_dopp1       = sp_dopp1(rawIF_duration);
dopp_rate1      = (end_dopp1 - start_dopp1)/rawIF_duration;
aa              = sp_rx_gain(1,rawIF_idxs);
bb              = aa(isnan(aa)==0);
SP_mean_gain1   = mean(bb);

fprintf('Channel: 1. PRN: %d. Ant = %d. Start/Stop Dopper: %.3f/%.3f. Doppler rate: %.6f. SP mean gain: %.6f\n', PRN1, ANT1, start_dopp1, end_dopp1, dopp_rate1, SP_mean_gain1)


SP_lat_2        = sp_lat(2,rawIF_idxs);
%SP_lon_2        = sp_lon(2,rawIF_idxs) - 360;
SP_lon_2        = sp_lon(2,rawIF_idxs);
prn_code2       = prn_code(2,rawIF_idxs);
PRN2            = prn_code2(1);
ddm_ant2        = ddm_ant(2,rawIF_idxs);
ANT2            = ddm_ant2(1);
sp_dopp2        = sp_ddmi_dopp(2,rawIF_idxs);
start_dopp2     = sp_dopp2(1);
end_dopp2       = sp_dopp2(rawIF_duration);
dopp_rate2      = (end_dopp2 - start_dopp2)/rawIF_duration;
aa              = sp_rx_gain(2,rawIF_idxs);
bb              = aa(isnan(aa)==0);
SP_mean_gain2   = mean(bb);

fprintf('Channel: 2. PRN: %d. Ant = %d. Start/Stop Dopper: %.3f/%.3f. Doppler rate: %.6f. SP mean gain: %.6f\n', PRN2, ANT2, start_dopp2, end_dopp2, dopp_rate2, SP_mean_gain2)


SP_lat_3 = sp_lat(3,rawIF_idxs);
%SP_lon_3 = sp_lon(3,rawIF_idxs) - 360;
SP_lon_3 = sp_lon(3,rawIF_idxs);
prn_code3 = prn_code(3,rawIF_idxs);
PRN3 = prn_code3(1);
ddm_ant3 = ddm_ant(3,rawIF_idxs);
ANT3 = ddm_ant3(1);
sp_dopp3 = sp_ddmi_dopp(3,rawIF_idxs);
start_dopp3 = sp_dopp3(1);
end_dopp3 = sp_dopp3(rawIF_duration);
dopp_rate3 = (end_dopp3 - start_dopp3)/rawIF_duration;
aa = sp_rx_gain(3,rawIF_idxs);
bb = aa(isnan(aa)==0);
SP_mean_gain3 = mean(bb);

fprintf('Channel: 3. PRN: %d. Ant = %d. Start/Stop Dopper: %.3f/%.3f. Doppler rate: %.6f. SP mean gain: %.6f\n', PRN3, ANT3, start_dopp3, end_dopp3, dopp_rate3, SP_mean_gain3)


SP_lat_4        = sp_lat(4,rawIF_idxs);
% SP_lon_4        = sp_lon(4,rawIF_idxs) - 360;
SP_lon_4        = sp_lon(4,rawIF_idxs);
prn_code4       = prn_code(4,rawIF_idxs);
PRN4            = prn_code4(1);
ddm_ant4        = ddm_ant(4,rawIF_idxs);
ANT4            = ddm_ant4(1);
sp_dopp4        = sp_ddmi_dopp(4,rawIF_idxs);
start_dopp4     = sp_dopp4(4);
end_dopp4       = sp_dopp4(rawIF_duration);
dopp_rate4      = (end_dopp4 - start_dopp4)/rawIF_duration;
aa              = sp_rx_gain(4,rawIF_idxs);
bb              = aa(isnan(aa)==0);
SP_mean_gain4   = mean(bb);

fprintf('Channel: 4. PRN: %d. Ant = %d. Start/Stop Dopper: %.3f/%.3f. Doppler rate: %.6f. SP mean gain: %.6f\n', PRN4, ANT4, start_dopp4, end_dopp4, dopp_rate4, SP_mean_gain4)


%% New matlab colors
black         = "#FFFFFF";
new_blue      = "#0072BD";
new_red       = "#D95319";
new_yellow    = "#EDB120";
new_purple    = "#7E2F8E";
new_green     = "#77AC30";
new_cyan      = "#4DBEEE";
new_burgundy  = "#A2142F";

%linemarker        = '*'
linemarker        = '.';

figure(1)
hold on
load('mapworld.mat')
plot(world_lon,world_lat)
plot(SP_lon_1,SP_lat_1, linemarker, 'color', black)
plot(SP_lon_2,SP_lat_2, linemarker, 'color', new_blue)
plot(SP_lon_3,SP_lat_3, linemarker, 'color', new_green)
plot(SP_lon_4,SP_lat_4, linemarker, 'color', new_red)
xlabel('Longitude')
ylabel('Latitude')
title('Specular Points Over Raw IF Interval')
grid on

zoom_padding_lat_lon = 35; % smaller less padding
figure(2)
hold on
load('mapworld.mat')
plot(world_lon,world_lat)
plot(SP_lon_1,SP_lat_1, linemarker, 'color', black)
plot(SP_lon_2,SP_lat_2, linemarker, 'color', new_blue)
plot(SP_lon_3,SP_lat_3, linemarker, 'color', new_green)
plot(SP_lon_4,SP_lat_4, linemarker, 'color', new_red)
xlim( [min([SP_lon_1,SP_lon_2,SP_lon_3,SP_lon_4])-zoom_padding_lat_lon max([SP_lon_1,SP_lon_2,SP_lon_3,SP_lon_4])+zoom_padding_lat_lon] )
ylim( [min([SP_lat_1,SP_lat_2,SP_lat_3,SP_lat_4])-zoom_padding_lat_lon max([SP_lat_1,SP_lat_2,SP_lat_3,SP_lat_4])+zoom_padding_lat_lon] )
xlabel('Longitude')
ylabel('Latitude')
title('Specular Points Over Raw IF Interval')
grid on

figure(3)
hold on
plot(UTC_hours_rawIF,prn_code1, linemarker, 'color', black)
plot(UTC_hours_rawIF,prn_code2, linemarker, 'color', new_blue)
plot(UTC_hours_rawIF,prn_code3, linemarker, 'color', new_green)
plot(UTC_hours_rawIF,prn_code4, linemarker, 'color', new_red)
xlabel('Time, GPS Secs or UTC Hour')
ylabel('PRN')
title('PRN Codes vs UTC Hour, Filtered Interval')
legend({'Ch 1','Ch 2','Ch 3','Ch 4'},'location','NorthWest')
grid on

figure(4)
hold on
plot(UTC_hours_rawIF,ddm_ant1, linemarker, 'color', black)
plot(UTC_hours_rawIF,ddm_ant2+0.1, linemarker, 'color', new_blue)
plot(UTC_hours_rawIF,ddm_ant3+0.2, linemarker, 'color', new_green)
plot(UTC_hours_rawIF,ddm_ant4+0.3, linemarker, 'color', new_red)
xlabel('UTC Hour')
ylabel('Antenna (with offset), Star=2, Port=3')
title('DMR Antenna vs UTC Hour, Filtered Interval')
legend({'Ch 1','Ch 2','Ch 3','Ch 4'},'location','NorthWest')
grid on

%figure(1)
