function [ output_files, output_file_id ] = get_dlc_filenames( experiment, median_filter, rats, drugs )
%GET_DLC_FILENAMES Give list of filenames for a given pharmacology experiment.
%   filenames = gonogo_exp_def_function(experiment, extract_or_analyse)
%
%   INPUTS: experiment - name of the folder where the data for the
%   experiment is kept
%
%   rats - rats to be analysed in format {'13','14'} etc. (must be 2
%   characters)
%
%   drugs - drugs to be analysed in format {'sali','amph'} etc. (must be 4
%   characters)
%
%   e.g. experiment_filenames = get_exp_filenames('local_amph_raw_V1','extract') 
%   
%   NOTE: filenames are always in the following format: exp no, animal no,
%   training stel, drug, date

%start_directory = '/Users/grimal/Dropbox/pharmacology_exps_new/video_analyses/deeplabcut/data/'; % The root folder where all subfolders of data are kept
start_directory = '/Users/grimal/Dropbox/dopamine_pharm/data/video/DLC_raw_output/';
subfolders      = dir(start_directory); % Make a list of all subfolders containing data
is_directory    = [subfolders(:).isdir]; % Returns a logical vector: 1 if a name is a directory, 0 if not
folder_names    = {subfolders(is_directory).name}'; % Cell array of folder names, including '.' and '..'
folder_names(ismember(folder_names,{'.','..'})) = []; % Removes the '.' and '..' folders

directory = fullfile(start_directory,experiment,'/');

% get all filenames, select whether median filtered or not
data_files_info = dir([directory,'*.csv']); % get all CSV files
files = {data_files_info.name};
files = strcat(directory,files);
filter_no = strfind(files,'filtered');
filter_ind = find(~cellfun(@isempty,filter_no)); % indices of median filtered files
no_filter_ind = find(cellfun(@isempty,filter_no)); % indices of files without median filter

if median_filter
    files = files(filter_ind);
else
    files = files(no_filter_ind);
end
        
% take only the files that match the rats and drugs required
for ifile = 1:length(files)
    name      = erase(files{ifile},experiment);
    name      = erase(name,start_directory); % identify the name of the session
    animal_no = name(6:7);
    drug      = name(9:12);
    file_id   = name(2:21);
    if ismember(animal_no,rats) & ismember(drug,drugs) % if numbers and drugs match inputted, take files
        output_files{ifile} = files{ifile};
        output_file_id{ifile} = file_id;
        if output_file_id{ifile}(end) == 'D'
            output_file_id{ifile} = output_file_id{ifile}(1:end-1);
        end
    end
end


output_files = output_files(~cellfun('isempty',output_files)); % remove empty cells
output_file_id = output_file_id(~cellfun('isempty',output_file_id));

end

