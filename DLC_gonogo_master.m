
%%%%%%%%%% DLC GONOGO MASTER %%%%%%%%%%

%% CHOOSE EXPERIMENT, SUBJECTS, AND SESSIONS
experiment    = 'local_d1antagonist_V2'; % change to experiment of interest
rats          = {'25'}%13','15','16','17','19','20','21','22','23','25','26'};
drugs         = {'sal_'}%,'schh'};

%% SELECT DLC PARAMETERS
plot_findpeaks = 1;
MinPeakProm = 15; % for identifying changes in lighting for video/behaviour alignment. Don't change 
period = 5;

%% DEFINE PATHS
dlc_data_path = 'C:\Users\grimal\Desktop\da_pharm\video_analyses\dlc\data'; % for pc
% https://uk.mathworks.com/matlabcentral/fileexchange/61235-video-frame-time-stamps
% Use the ffmpeg conversion function from this link - requires you to download ffmpeg.exe as well [google it]
ffmpeg_path = 'C:\Users\grimal\Desktop\da_pharm\video_analyses\dlc\matlab_analysis\scripts\ffmpeg-20190805-5ac28e9-win64-static\bin\'; %Path to the ffmpeg.exe file
%load_parent_folder = 'C:\Users\grimal\Desktop\da_pharm\video_analyses\dlc\output_files\';
parent_folder = 'C:\Users\grimal\Desktop\da_pharm\video_analyses\dlc\output_files_with_norm\';

%% GET FILE IDS
[beh_filenames, beh_file_ids,dlc_filenames,dlc_file_ids,vid_ids] = DLC_filesort(beh_folder,experiment,rats,drugs);

%% GENERATE DLC STRUCT AND SAVE
% one struct per session
all_dlc = DLC_extract(experiment,MinPeakProm,period,beh_filenames,beh_file_ids,dlc_filenames,vid_ids,dlc_data_path,ffmpeg_path,parent_folder,plot_findpeaks);

