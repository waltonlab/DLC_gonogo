function [ output_files, output_file_id ] = get_exp_filenames_dlc( start_directory, experiment, extract_or_analyse, rats, drugs )
%GET_EXP_FILENAMES Give list of filenames for a given pharmacology experiment.
%   filenames = gonogo_exp_def_function(experiment, extract_or_analyse)
%
%   INPUTS: start_directory: root folder where all subfolders of data are
%   kept. 
%
%   experiment - name of the folder where the data for the
%   experiment is kept
%
%   extract_or_analyse - extract for extracting data from MED-PC files,
%   analyse for analysing data from .mat files
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

%start_directory = '/Users/grimal/Dropbox/pharmacology_exps_new/all_data/'; % The root folder where all subfolders of data are kept
%start_directory = 'C:\Users\grimal\Desktop\da_pharm\all_data\';
subfolders      = dir(start_directory); % Make a list of all subfolders containing data
is_directory    = [subfolders(:).isdir]; % Returns a logical vector: 1 if a name is a directory, 0 if not
folder_names    = {subfolders(is_directory).name}'; % Cell array of folder names, including '.' and '..'
folder_names(ismember(folder_names,{'.','..'})) = []; % Removes the '.' and '..' folders

directory = fullfile(start_directory,experiment,'/');

% get all filenames based on intention to extract (without .mat extension) or analyse (with .mat extension)
if extract_or_analyse == 'extract'
    data_files_info = dir([directory,]);
    files = {data_files_info.name};
    files(ismember(files,{'.','..','.DS_Store','._.DS_Store'})) = []; % Removes irrelevant things.
    files(contains(files,'._')) = [];% is a windows problem, windows not ignoring these files
    myindices = find(~cellfun(@isempty,strfind(files,'mat'))); % If there are already .mat files in the folder, find them
    files([myindices])=[]; % And remove them
    files = strcat(directory,files); % Add the folder directory to the list of files
else
    data_files_info = dir([directory,'*.mat']); % find the .mat files
    files = {data_files_info.name};
    files = strcat(directory,files);
end

% take only the files that match the rats and drugs required
for ifile = 1:length(files)
    name      = erase(files{ifile},experiment);
    name      = erase(name,start_directory); % identify the name of the session
    animal_no = name(6:7);
    drug      = name(15:18);
    file_id   = name(2:26);
    if ismember(animal_no,rats) & ismember(drug,drugs) % if numbers and drugs match inputted, take files
        output_files{ifile} = files{ifile};
        output_file_id{ifile} = file_id;
    end
end

output_files = output_files(~cellfun('isempty',output_files)); % remove empty cells
output_file_id = output_file_id(~cellfun('isempty',output_file_id));

end