function [beh_filenames_filt, beh_file_ids,dlc_filenames,dlc_file_ids,vid_ids] = DLC_filesort(directory,experiment,rats,drugs)
%DLC_MATCH_FILES Returns behaviour filenames corresponding to DLC files. 

% start_directory is for where the behaviour files are located. 

% check directories in here are correct! Update get_dlc and get_exp_filenames functions in future so that this is not hard coded
[dlc_filenames, dlc_file_ids] = get_dlc_filenames(experiment,false,rats,drugs); % csv files, and file ids to match to behaviour files
[beh_filenames, beh_file_ids] = get_exp_filenames_dlc(directory,experiment,'analyse',rats,drugs); % full beh filenames, and ids for matching with DLC files. Extract = 1, analyse = 2
%beh_filenames_ex  = get_exp_filenames_dlc(experiment,'analyse',rats,drugs); % with .mat extension

vid_ids = dlc_file_ids; % for matching with behaviour files

str_insert = 'step6v'; 
for i = 1:length(dlc_file_ids)
    dlc_file_ids{i} = [dlc_file_ids{i}(1:7),str_insert,dlc_file_ids{i}(7:end)];
    dlc_file_ids{i} = eraseBetween(dlc_file_ids{i},14,14);
    if length(dlc_file_ids{i}) > 25
        dlc_file_ids{i} = dlc_file_ids{i}(1:end-1);
    end
end
match_ind = find(ismember(beh_file_ids,dlc_file_ids));
beh_filenames_filt = beh_filenames(match_ind);
end
