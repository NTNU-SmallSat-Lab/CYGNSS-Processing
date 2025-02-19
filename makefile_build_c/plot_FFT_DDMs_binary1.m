% Script to plot DDM output of CYGNSS_DDMP (aka Daaxa)
%
% plot_FFT_DDMs_binary1.m
%
% Modified by THB, 2024

close all
clear all

%%
colors = ['k' 'b' 'g' 'r' 'm' 'c'];
satid_hex2FM = [247 249 43 44 47 54 55 73];
%0xF7 (247): CYGNSS 1
%0xF9 (249): CYGNSS 2
%0x2B ( 43): CYGNSS 3
%0x2C ( 44): CYGNSS 4
%0x2F ( 47): CYGNSS 5
%0x36 ( 54): CYGNSS 6
%0x37 ( 55): CYGNSS 7
%0x49 ( 73): CYGNSS 8

%% Path Config
% path to processed DDM. Default 'Processed_DDMs.bin'
%ddm_bin_file_name = 'Processed_DDMs_cyg04_raw_if_s20171130_234500_e20171130_234600_data';
%ddm_bin_file_name = 'Processed_DDMs_cyg01_raw_if_s20180822_142659_e20180822_142759_data';
ddm_bin_file_name = 'Processed_DDMs';
%ddm_bin_file_name = 'Processed_DDMs_cyg08_raw_if_s20171230_000830_e20171230_000930_data';


%meta_data_path          = '/Users/thb/Kode/NTNU/CYGNSS-Processing/makefile_build_c/RawIFData'; % path of the processed raw if data's meta
meta_data_path          = '/Users/thb/Kode/NTNU/gnssr-processing/CYGNSS-Processing/makefile_build_c/RawIFData/';
%meta_data_path          = '/Users/thb/Library/CloudStorage/OneDrive-NTNU/Prosjekter/GNSS-R/CYGNSS data'; % path of the processed raw if data's meta

%meta_data_file_name     = 'cyg04_raw_if_s20171130_234500_e20171130_234600_meta.bin';
%meta_data_file_name     = 'cyg01_raw_if_s20180822_142659_e20180822_142759_meta.bin';
%meta_data_file_name     = 'cyg08_raw_if_s20171230_000830_e20171230_000930_meta.bin';
%meta_data_file_name     = 'cyg01_raw_if_s20180822_142659_e20180822_142759_meta.bin';
meta_data_file_name     = 'cyg08_raw_if_s20170825_141629_e20170825_141729_meta.bin';
meta_data_file          = fullfile( meta_data_path, meta_data_file_name );

% finding space craft ID
fid                     = fopen( meta_data_file );
satIDhex                = dec2hex(fread(fid,1,'uint8')); % hex ID of satellite (need "decoder ring" to match to FM#)
fclose(fid);
satIDdec                = hex2dec(satIDhex);
satID_FM                = find(satid_hex2FM == satIDdec);
sc_id                   = satID_FM;

%% Config plotting
% plot_full_ddms              = 0;
plot_full_ddms              = 1;

% plot_cropped_ddms           = 0;
plot_cropped_ddms           = 1;

% plot_delay_waveforms        = 0;
plot_delay_waveforms        = 1;

plot_full_non_fliped_ddms   = 0;
% plot_full_non_fliped_ddms   = 1;

store_images                = 0;
% store_images                = 1;

%% Setting DDM color map
% color_bar_type = 'parula'; % default
color_bar_type = 'turbo';   % red strongest colors   

%% Generating images
binaryFilename = sprintf('%s.bin',ddm_bin_file_name);

% set cropped DDM size
buffer_delay_size = 200;  % samples
buffer_dopp_size = 20;
%buffer_dopp_size = 48;

fid = fopen(binaryFilename);

% read in dimensions of the DDM
numDDMentries = fread(fid, 1, 'int');

% if(plot_cropped_ddms == 1)
%   % cropped DDM
%   figure(100);
%   colorbar;
%   pause(1)
% end
% 
% if(plot_full_ddms == 1)
%   % Full DDMs
%   figure(200);
%   colorbar;
% end
% 
% if(plot_delay_waveforms == 1)
%   % Delay Waveforms
%   figure(1);
%   hold on
%   ylabel('Signal Magntitude (power)');
%   xlabel('Delay (Code Phase)');
%   title('Delay Waveforms');
% end

c_legend            = {}; % for plotting wave forms
c_legend_not_fliped = {}; % for plotting wave forms in non-flipped form
for DDM_idx = 1:numDDMentries

  % read in meta data for this DDM
  DDM_hdr                   = char(fread(fid, 4, 'char'));
  DDM_log_counter(DDM_idx)  = fread(fid, 1, 'int');
  GPSweek(DDM_idx)          = fread(fid, 1, 'int');
  GPSSecond(DDM_idx)        = fread(fid, 1, 'double');
  CurrentSecond(DDM_idx)    = fread(fid, 1, 'double');
  if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
    FileOffset(DDM_idx)     = fread(fid, 1, 'unsigned long long');
  else
    FileOffset(DDM_idx)     = fread(fid, 1, 'unsigned long');
    blank                   = fread(fid, 1, 'unsigned long');
  end
  PRN(DDM_idx)              = fread(fid, 1, 'short');
  StartDoppler(DDM_idx)     = fread(fid, 1, 'double');
  EndDoppler(DDM_idx)       = fread(fid, 1, 'double');
  DopplerStep(DDM_idx)      = fread(fid, 1, 'double');
  numDopplers(DDM_idx)      = floor((EndDoppler(DDM_idx) - StartDoppler(DDM_idx))/DopplerStep(DDM_idx)) + 1;
  numDelays(DDM_idx)        = fread(fid, 1, 'int');
  DelayStep_Chips(DDM_idx)  = fread(fid, 1, 'double');
  Doppler_axis              = [StartDoppler(DDM_idx):DopplerStep(DDM_idx):EndDoppler(DDM_idx)];
  Delay_axis                = [0:DelayStep_Chips(DDM_idx):numDelays(DDM_idx)*DelayStep_Chips(DDM_idx)-DelayStep_Chips(DDM_idx)];

  % read in DDM
  doubles2read              = numDopplers(DDM_idx)*numDelays(DDM_idx);
  DDM_data                  = fread(fid,doubles2read,'double');
  DDM                       = reshape(DDM_data,numDelays(DDM_idx),numDopplers(DDM_idx));
  DDM                       = DDM';  % transpose it

  antenna(DDM_idx)          = fread(fid, 1, 'unsigned int');

  [DDM2,max_dopp_idx,max_delay_idx] = crop_DDM(DDM,buffer_delay_size,buffer_dopp_size,numDelays,numDopplers);
%  Doppler_axis2 = Doppler_axis(max_dopp_idx-buffer_dopp_size:max_dopp_idx+buffer_dopp_size);
%  Delay_axis2 = Delay_axis(max_delay_idx-buffer_delay_size:max_delay_idx+buffer_delay_size);

  noise_temp                = mean(mean(DDM2(1:10,:))); % first rows of cropped DDM
  signal_max(DDM_idx)       = max(max(DDM2)); % max
  SNR_dB(DDM_idx)           = 10*log10(signal_max(DDM_idx)/noise_temp);
  Max_Doppler(DDM_idx)      = Doppler_axis(max_dopp_idx);
  Max_Delay(DDM_idx)        = Delay_axis(max_delay_idx);

  if(SNR_dB(DDM_idx) > 1.5)
    fprintf('PRN: %d. DDM: %d. Max Doppler: %.2f. Max SNR_dB: %.3f\n', PRN(DDM_idx),DDM_idx, Max_Doppler(DDM_idx),SNR_dB(DDM_idx));
  end

  if(plot_delay_waveforms == 1)
    %% Plotting waveform
    h = figure(1);
    color_idx = mod(DDM_idx,length(colors));
    if(color_idx == 0)
        color_idx = 6;
    end
    hold on
    %plot(Delay_axis,DDM(max_dopp_idx,:)*1e-9,Color=colors(color_idx));
    %
    % fliped the x-axis to make the Delay peak logical. More testing needed
    if numDDMentries == 1
        plot(-Delay_axis+Delay_axis(end),DDM(max_dopp_idx,:)*1e-9, Color=colors(color_idx)); 
    else
        plot(-Delay_axis+Delay_axis(end),DDM(max_dopp_idx,:)*1e-9, 'linestyle','-.', Color=colors(color_idx)); 
    end
    hold off;
    ylabel('Signal Magntitude (power scale 1e-9)');
    xlabel('Delay [chips]')
    xlim([0 1024])
    str = sprintf("Delay Waveform: SC %d, PRN %d, DDM Number %d",sc_id, PRN(DDM_idx),DDM_idx);
    title(str)
    c_legend{length(c_legend)+1} = sprintf('DDM%d',DDM_idx);
    legend(c_legend)
    grid on;
    % pause(1)
    if store_images
        if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
            print ("-r600", sprintf("%s_wave_form_ddm%d.png",ddm_bin_file_name,DDM_idx));
        else
            exportgraphics(h,sprintf("%s_wave_form_ddm%d.png",ddm_bin_file_name,DDM_idx),'Resolution',600)
        end
    end
  end

  %% Plotting cropped DDM
  if(plot_cropped_ddms == 1)
    % plot cropped DDM
    h = figure(100+DDM_idx);
    imagesc(flipud(DDM2));
    ylabel('Delay Bins');
    xlabel('Doppler Bins');
  %  ylabel('Delay (chips)');
  %  xlabel('Doppler (Hz)');
    str     = sprintf("Raw IF Processed DDM: SC %d, PRN %d, DDM Number %d",sc_id, PRN(DDM_idx),DDM_idx);
    title(str)
    map     = colormap(color_bar_type);
    colorbar;
    drawnow;
    % pause(1)
    if store_images
      if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
          print ("-r600", sprintf("%s_cropped_ddm%d.png", ddm_bin_file_name, DDM_idx));
      else
          exportgraphics(h,sprintf("%s_cropped_ddm%d.png", ddm_bin_file_name, DDM_idx),'Resolution',600)
      end
    end
  end

  %% Plotting full DDM
  if(plot_full_ddms == 1)
    % plot full DDM
    h = figure(200+DDM_idx);
  %  imagesc(Doppler_axis,Delay_axis,DDM');
    % imagesc(DDM);
    imagesc(flipud(DDM'));
    ylabel('Delay (Code Phase) [chips]');
    xlabel('Doppler (kHz)');
    step_val            = 4;
    plot_ticks          = 1:step_val:numDopplers(DDM_idx);
    xticks(plot_ticks)
    n_plot_ticks        = length( plot_ticks );
    Doppler_axis_plot   = (StartDoppler(DDM_idx):step_val*DopplerStep(DDM_idx):EndDoppler(DDM_idx))/1;
    n_ticks             = length( Doppler_axis_plot );
    plot_ticks_label    = cell(1,n_plot_ticks);
    for idx = 1:n_ticks
        plot_ticks_label{idx} = sprintf('%d',Doppler_axis_plot(idx));
    end
    xticklabels( plot_ticks_label )
    step_val          = 100;
    plot_ticks        = 1:1/DelayStep_Chips(DDM_idx)*step_val:numDelays(DDM_idx);
    yticks( plot_ticks )
    n_ticks           = length( plot_ticks );
    Delay_axis_plot   = 0:step_val:numDelays(DDM_idx)*DelayStep_Chips(DDM_idx)-1;
    % Delay_axis_plot   = (plot_ticks-1)*DelayStep_Chips(DDM_idx);
    for idx = 1:n_ticks
      plot_ticks_label{idx} = sprintf('%d',Delay_axis_plot(idx));
    end
    yticklabels( plot_ticks_label )


    str = sprintf("Full DDM: SC %d PRN %d, DDM Number %d",sc_id, PRN(DDM_idx),DDM_idx);
    title(str)
    map = colormap(color_bar_type);
    colorbar
    %pause(1)
    if store_images
      if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
          print ("-r600", sprintf("%s_full_ddm%d.png", ddm_bin_file_name, DDM_idx));
      else
          exportgraphics(h,sprintf("%s_full_ddm%d.png", ddm_bin_file_name, DDM_idx),'Resolution',600)
      end
    end
  %  axis([startDoppler(DDM_idx) endDoppler(DDM_idx) 1 numDelays(DDM_idx) 0 6e12])
  end
  %
  %
  %% Plotting non flipped DDMs 
  % axis needs to be fixed
  if(plot_full_non_fliped_ddms == 1)

    h = figure(2);
    color_idx = mod(DDM_idx,length(colors));
    if(color_idx == 0)
        color_idx = 6;
    end
    hold on
    %plot(Delay_axis,DDM(max_dopp_idx,:)*1e-9,Color=colors(color_idx));
    %
    % fliped the x-axis to make the Delay logical should be tested
    if numDDMentries == 1
        plot(Delay_axis, DDM(max_dopp_idx,:)*1e-9, Color=colors(color_idx)); 
    else
        plot(Delay_axis, DDM(max_dopp_idx,:)*1e-9, 'linestyle','-.', Color=colors(color_idx)); 
    end
    c_legend_not_fliped{length(c_legend_not_fliped)+1} = sprintf('DDM%d',DDM_idx);
    hold off;
    ylabel('Signal Magntitude (power scale 1e-9)');
    % xlabel('Delay [chips]')
    xlim([0 1024])
    str = sprintf("Delay Waveform: SC %d, PRN %d, DDM Number %d",sc_id, PRN(DDM_idx),DDM_idx);
    title(str)
    legend(c_legend)
    grid on;
    % pause(1)
    if store_images
        if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
            print ("-r600", sprintf("%s_wave_form_ddm%d_not_fliped.png",ddm_bin_file_name,DDM_idx));
        else
            exportgraphics(h,sprintf("%s_wave_form_ddm%d_not_fliped.png",ddm_bin_file_name,DDM_idx),'Resolution',600)
        end
    end

    % plot cropped DDM
    h = figure(300+DDM_idx);
    imagesc((DDM2));
    % ylabel('Delay Bins');
    % xlabel('Doppler Bins');
  %  ylabel('Delay (chips)');
  %  xlabel('Doppler (Hz)');
    str = sprintf("Raw IF Processed DDM: SC %d, PRN %d, DDM Number %d",sc_id, PRN(DDM_idx),DDM_idx);
    title(str)
    map = colormap(color_bar_type);
    colorbar()
    drawnow;
    if store_images
      if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
          print ("-r600", sprintf("%s_cropped_ddm%d_not_fliped.png", ddm_bin_file_name, DDM_idx));
      else
          exportgraphics(h,sprintf("%s_cropped_ddm%d_not_fliped.png", ddm_bin_file_name, DDM_idx),'Resolution',600)
      end
    end

    % plot full DDM
    h = figure(400+DDM_idx);
    imagesc(DDM');
    % ylabel('Delay (Code Phase) [chips]');
    % xlabel('Doppler (kHz)');

    str = sprintf("Full DDM: SC %d PRN %d, DDM Number %d",sc_id, PRN(DDM_idx),DDM_idx);
    title(str)
    map = colormap(color_bar_type);
    colorbar
    %pause(1)
    if store_images
      if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
          print ("-r600", sprintf("%s_full_ddm%d_not_flip.png", ddm_bin_file_name, DDM_idx));
      else
          exportgraphics(h,sprintf("%s_full_ddm%d_not_flip.png", ddm_bin_file_name, DDM_idx),'Resolution',600)
      end
    end
  %  axis([startDoppler(DDM_idx) endDoppler(DDM_idx) 1 numDelays(DDM_idx) 0 6e12])
  end
  %pause(1)
end  % end DDM loop