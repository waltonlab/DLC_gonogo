function [all_dlc] = DLC_extract(experiment,MinPeakProm,period,beh_filenames,beh_file_ids,dlc_filenames,vid_ids,dlc_data_path,ffmpeg_path,parent_folder,plot_findpeaks)
% Generate DLC struct. 

%% Struct of body/box parts
tracked_parts = {
    'nose'
    'lear'
    'rear'
    'head'
    'middle'
    'lleg'
    'rleg'
    'tail'
    'poke'
    'llever'
    'rlever'
    'lmag'
    'rmag'}';
tracked_parts(2,:) = {1 2 3 4 5 6 7 8 9 10 11 12 13};
dlc.tracked_parts = struct(tracked_parts{:});

% Setting up interpolation variables
criterion = 1;
filterparts = [dlc.tracked_parts.nose, dlc.tracked_parts.lear, dlc.tracked_parts.rear, ...
    dlc.tracked_parts.head, dlc.tracked_parts.middle, dlc.tracked_parts.lleg, dlc.tracked_parts.rleg, ...
    dlc.tracked_parts.tail, dlc.tracked_parts.poke,dlc.tracked_parts.llever,dlc.tracked_parts.rlever,...
    dlc.tracked_parts.lmag,dlc.tracked_parts.rmag];

% Order of sub columns from Raw data
x = 1;
y = 2;
likelihood = 3;

%% Find error cue start and end times to synchronise med and video file
for ifile = 1:length(dlc_filenames)
    
    % List of trial times to chunk analysis aorund: trialstartsMED
    load([beh_filenames{ifile},'.mat']);
    dlc.behaviour = variable;
    [end_error_times,dlc.cue_times] = get_event_times(beh_filenames{ifile});
    no_errors = length(end_error_times);
    
    %% Read in DLC data and interpolate 
    [dlc.dataraw,dlc.data] = DLC_preproc(dlc_filenames{ifile},criterion,filterparts);
    
    %read in filename
    video_file = [dlc_data_path,'\',experiment,'\',vid_ids{ifile},'.avi'];
    dlc.vidObj = VideoReader(video_file);
    
    % find start + end of errors with peaks and plot 
    [error_start,error_end] = DLC_findpeaks(dlc.vidObj,MinPeakProm,no_errors,vid_ids{ifile},plot_findpeaks);
    
    % Convert Raw video "Frame" numbers into actual time stamps
    dlc.ts = videoframets(ffmpeg_path,video_file); % timestamps
    startframe_time = dlc.ts(error_start(1)) - end_error_times(1)/100;
    
    videostarttime = dlc.ts(find(abs(dlc.ts-startframe_time) == min(abs(dlc.ts-startframe_time))));
    trialstartsMED = variable.trials.startimes; % start times of each trial in seconds 

    [dlc.cut_start,dlc.cut_end] = DLC_framenumber(trialstartsMED,videostarttime,dlc.ts,period);
    
    % Find median x,y of poke and subtract from tracking coordinates to normalise
    [median_poke_x,median_poke_y] = DLC_plotbox(dlc.data,variable.double,0);
    dlc.datanorm = zeros(length(dlc.data),length(dlc.data(1,:)));
    for part = 1:length(tracked_parts)
        for data_point = 1:length(dlc.data)
            dlc.datanorm(data_point,(part-1)*3+(x+1)) = (dlc.data(data_point,(part-1)*3+(x+1)) - median_poke_x); 
            dlc.datanorm(data_point,(part-1)*3+(y+1)) = (dlc.data(data_point,(part-1)*3+(y+1)) - median_poke_y); 
            dlc.datanorm(data_point,1+((part-1)*3)) = dlc.data(data_point,1+((part-1)*3));
        end
    end
    
    % Cut tracking data into trials
    for yos = 1:length(dlc.cut_start)
        dlc.tracking{yos} = dlc.data(dlc.cut_start(yos):dlc.cut_end(yos), :);
        dlc.trackingnorm{yos} = dlc.datanorm(dlc.cut_start(yos):dlc.cut_end(yos), :);
    end

    % Turn trial type variables into logicals to make indexing for extracting
    % trial types and plotting more efficient/readable
    dlc.trials.Go = [];
    dlc.trials.NoGo = [];
    dlc.trials.left = [];
    dlc.trials.right = [];
    dlc.trials.single = [];
    dlc.trials.double = [];
    dlc.trials.success = [];
    
    dlc = rmfield(dlc,'trials');
    for i = 1:length(dlc.cue_times)%cut_start
        dlc.trials.Go(i) = strcmp(variable.trials.stats{i,2}, 'GO Left') | strcmp(variable.trials.stats{i,2}, 'GO Right');
        dlc.trials.NoGo(i) = strcmp(variable.trials.stats{i,2}, 'NO GO SINGLE') | strcmp(variable.trials.stats{i,2}, 'NO GO DOUBLE');
        dlc.trials.left(i) = strcmp(variable.trials.stats{i,2}, 'GO Left');
        dlc.trials.right(i) = strcmp(variable.trials.stats{i,2}, 'GO Right');
        if strcmp(variable.double,'left')
            dlc.trials.single(i) = strcmp(variable.trials.stats{i,2}, 'NO GO SINGLE') | strcmp(variable.trials.stats{i,2}, 'GO Right');
            dlc.trials.double(i) = strcmp(variable.trials.stats{i,2}, 'NO GO DOUBLE') | strcmp(variable.trials.stats{i,2}, 'GO Left');
        else strcmp(variable.double,'right')
            dlc.trials.single(i) = strcmp(variable.trials.stats{i,2}, 'NO GO SINGLE') | strcmp(variable.trials.stats{i,2}, 'GO Left');
            dlc.trials.double(i) = strcmp(variable.trials.stats{i,2}, 'NO GO DOUBLE') | strcmp(variable.trials.stats{i,2}, 'GO Right');
        end
        dlc.trials.success(i) = strcmp(variable.trials.stats{i,4}, 'success');
        dlc.trials.failed(i) = strcmp(variable.trials.stats{i,4}, 'failed');
        dlc.trials.rt_exceeded(i) = strcmp(variable.trials.stats{i,4}, 'reaction time exceeded');
        dlc.trials.wrong_lever(i) = strcmp(variable.trials.stats{i,4}, 'incorrect lever press');
    end

    % save dlc variable 
    save_folder = [parent_folder,experiment];
    label = beh_file_ids{ifile};
    fullfilename = fullfile(save_folder,label);
    save(fullfilename,'dlc')
    
    all_dlc(ifile) = dlc;
 

end