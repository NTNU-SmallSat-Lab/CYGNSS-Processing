%
% process_rawIF_metadata.m
%
% STG, Sept 2017, GPLv3
% Modified: THB, Des. 2024
%
satid_hex2FM = [247 249 43 44 47 54 55 73];
%0xF7 (247): CYGNSS 1
%0xF9 (249): CYGNSS 2
%0x2B ( 43): CYGNSS 3
%0x2C ( 44): CYGNSS 4
%0x2F ( 47): CYGNSS 5
%0x36 ( 54): CYGNSS 6
%0x37 ( 55): CYGNSS 7
%0x49 ( 73): CYGNSS 8

%fid = fopen('../../../OnOrbitData/FM8/cyg08_raw_if_20170825_141629_meta.bin');
%fid = fopen('../../../CYGNSS/RawIF/May15_Australia/RawIF_Data/cyg08_raw_if_20180515_215055_meta.bin');
%fid = fopen('/media/gleason/Elements/CYGNSS_Data/rawIF/136/cyg08_raw_if_20200515_231925_meta.bin');

display_lines_seperating_meta_data  = true;
% display_lines_seperating_meta_data  = false;
display_file_name                   = true;
display_file_name                   = false;
display_sat_id                      = true;
% display_sat_id                      = false;
display_time                        = true;
% display_time                        = false;
display_front_end_info              = true;
% display_front_end_info              = false;
display_dataformat_info             = true;
% display_dataformat_info             = false;
%data_path               = '/Users/thb/Kode/NTNU/CYGNSS-Processing/makefile_build_c/RawIFData'; % can be any location on your computer
data_path               = '/Volumes/gnss-r/CYGNSS DATA/'; % can be any location on your computer
meta_files              = dir( fullfile( data_path, '*meta.bin') );
n_files                 = length( meta_files );
fprintf('Number of meta files found in path: %d\n', n_files);
c_data_format = [0 0 0 0 0]; % counter
for idx = 1:n_files
% raw_data_meta_file      = 'cyg05_raw_if_s20220727_035832_e20220727_035933_meta.bin'; % can be any cygnss *_meta.bin file
    if display_lines_seperating_meta_data
        fprintf('____________________________________________________________________________\n')
    end
    file_name = meta_files(idx).name;
    if display_file_name
        fprintf('File name: %s\n', file_name);
    end

    fid                     = fopen( fullfile( data_path, meta_files(idx).name) );

    satIDhex                = dec2hex(fread(fid,1,'uint8')); % hex ID of satellite (need "decoder ring" to match to FM#)
    satIDdec                = hex2dec(satIDhex);
    satID_FM                = find(satid_hex2FM == satIDdec);

    hdr                     = num2str(fread(fid,4,'char'),'%s'); % "DRT0" header
    gpsweek                 = fread(fid,1,'uint16','ieee-be'); % GPS week (read in Big Endian order)
    gpssecs                 = fread(fid,1,'uint32','ieee-be'); % GPS seconds (as 4 byte uint)
    dataformat              = fread(fid,1,'uint8'); % decimal
    samplingrate            = fread(fid,1,'uint32','ieee-be'); % sampling rate % (read in Big Endian order)

    ch0FrontendSelection    = fread(fid,1,'uint8'); % (read in Big Endian order)
    ch0LOFrequency          = fread(fid,1,'uint32','ieee-be'); % frequnecy (Hz) % (read in Big Endian order)
    ch1FrontendSelection    = fread(fid,1,'uint8'); % (read in Big Endian order)
    ch1LOFrequency          = fread(fid,1,'uint32','ieee-be'); % frequnecy (Hz) % (read in Big Endian order)
    ch2FrontendSelection    = fread(fid,1,'uint8'); % (read in Big Endian order)
    ch2LOFrequency          = fread(fid,1,'uint32','ieee-be'); % frequnecy (Hz) % (read in Big Endian order)
    ch3FrontendSelection    = fread(fid,1,'uint8'); % (read in Big Endian order)
    ch3LOFrequency          = fread(fid,1,'uint32','ieee-be'); % frequnecy (Hz) % (read in Big Endian order)

    % See 148-0354-2 CYGNSS Raw IF Data File Format.pdf for rest of data entries
    % The gpssecs and dataformat are the 2 most important

    % satIDhex
    % satID_FM
    % gpsweek
    % gpssecs
    if display_sat_id 
        fprintf('Sat id: %d(0x%s). Sampling rate: %.3f MHz\n', satID_FM, satIDhex, double(samplingrate)*1e-6)
    end
    if display_time
        fprintf('GPS week: %d. GPS sec: %d\n', gpsweek, gpssecs );

        year_start          = str2double( file_name(15:18) );
        month_start         = str2double( file_name(19:20) );
        day_start           = str2double( file_name(21:22) );
        hour_start          = str2double( file_name(24:25) );
        minute_start        = str2double( file_name(26:27) );
        second_start        = str2double( file_name(28:29) );

        year_end            = str2double( file_name(32:35) );
        month_end           = str2double( file_name(36:37) );
        day_end             = str2double( file_name(38:39) );
        hour_end            = str2double( file_name(41:42) );
        minute_end          = str2double( file_name(43:44) );
        second_end          = str2double( file_name(45:46) );

        total_sec_of_start  = second_start + minute_start*60 + hour_start*3600 + day_start*3600*24;
        total_sec_of_end    = second_end + minute_end*60 + hour_end*3600 + day_end*3600*24;
        length_time_of_data = total_sec_of_end - total_sec_of_start;
        fprintf('Length of data (seconds): %.3f\n',length_time_of_data);

        fprintf('Date start (Y-M-S H:M:S): %d-%d-%d %d:%d:%.3f \n', year_start, month_start, day_start, hour_start, minute_start, second_start );
        fprintf('Date end   (Y-M-S H:M:S): %d-%d-%d %d:%d:%.3f \n', year_end, month_end, day_end, hour_end, minute_end, second_end );

        % calculate UTC date from GPS time
        if exist('OCTAVE_VERSION', 'builtin') > 0 % running octave
            % datatime not yet implemented in Octave
        else
            sec_per_week                    = 604800;    % 3600*24*7
            diff_gps_time_utc_time          = 18;         % number of leap seconds
            numb_weeks                      = gpsweek;   % should NOT add another week due to zero index since numb_weeks are the weeks that are already passed
            sec_from_gps_start              = numb_weeks*sec_per_week + gpssecs - diff_gps_time_utc_time;

            ReferenceDate = datetime('06/01/1980',...
                         'InputFormat', 'dd/MM/yyyy',...
                         'TimeZone',    'UTC');
            numb_days   = sec_from_gps_start/(3600*24);
            Days        = caldays( floor( numb_days ) );
            numb_hours  = (numb_days - floor(numb_days))*24;
            Hours       = hours( floor(numb_hours) );
            numb_min    = (numb_hours - floor(numb_hours))*60;
            Minutes     = minutes( floor(numb_min) );
            numb_sec    = (numb_min - floor(numb_min))*60;
            Seconds     = seconds( numb_sec );
            Date        = ReferenceDate + Days + Hours + Minutes + Seconds;
            fprintf('Date from GPS time (Y-M-S H:M:S): %d-%d-%d %d:%d:%.3f \n', Date.Year, Date.Month, Date.Day, Date.Hour, Date.Minute, Date.Second );
        end
    end

    if display_front_end_info
        fprintf('Channel 0: Front end selection = %d. LO Frequency %.3f MHz\n', ch0FrontendSelection, double(ch0LOFrequency)*1e-6)
        fprintf('Channel 1: Front end selection = %d. LO Frequency %.3f MHz\n', ch1FrontendSelection, double(ch1LOFrequency)*1e-6)
        fprintf('Channel 2: Front end selection = %d. LO Frequency %.3f MHz\n', ch2FrontendSelection, double(ch2LOFrequency)*1e-6)
        fprintf('Channel 3: Front end selection = %d. LO Frequency %.3f MHz\n', ch3FrontendSelection, double(ch3LOFrequency)*1e-6)
    end
    if(dataformat == 0)
        if display_dataformat_info
            disp('Channel 1, I Only ... double check, unusual')
        end
        c_data_format(dataformat+1) = c_data_format(dataformat+1) + 1;
    elseif(dataformat == 1)
        if display_dataformat_info
            disp('Channel 1 and 2, I Only ... double check, unusual')
        end
        c_data_format(dataformat+1) = c_data_format(dataformat+1) + 1;
    elseif(dataformat == 2)
        if display_dataformat_info
            disp('Channel 1,2,3, I Only  ... default for most collections')
        end
        c_data_format(dataformat+1) = c_data_format(dataformat+1) + 1;
    elseif(dataformat == 3)
        if display_dataformat_info
            disp('Channel 1,2,3,4 I Only  ... double check, there is no channel 4 connected')
        end
        c_data_format(dataformat+1) = c_data_format(dataformat+1) + 1;
    elseif(dataformat == 4)
        if display_dataformat_info
            disp('Channel 1,2 I and Q ... double check  unusual, will not work with processor')
        end
        c_data_format(dataformat+1) = c_data_format(dataformat+1) + 1;
    else
        disp('Invalid format type')
    end
    fclose(fid);
end
if display_lines_seperating_meta_data
    fprintf('____________________________________________________________________________\n')
end

fprintf('\nTotal meta files found in path: %d\n', n_files);
fprintf('Number of ''Channel 1, I Only (unusual)'' files: %d\n', c_data_format(1))
fprintf('Number of ''Channel 1 and 2, I Only (unusual)'' files: %d\n', c_data_format(2))
fprintf('Number of ''Channel 1,2,3, I Only (default)'' files: %d\n', c_data_format(3))
fprintf('Number of ''Channel 1,2,3,4 I Only (check, there is no channel 4 connected)'' files: %d\n', c_data_format(4))
fprintf('Number of ''Channel 1,2 I and Q (unusual, will not work with processor)'' files: %d\n', c_data_format(5))