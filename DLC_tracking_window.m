function [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,plotpart,trial_type,rew_size,outcome,start_time,end_time)

dlc_norm = dlc.trackingnorm;
cut_start = dlc.cut_start;
cut_end = dlc.cut_end;

x = 1;
y = 2;

if ~isempty(find(trial_type&rew_size&outcome)) % make sure this combination exists 
    for trial_no = find(trial_type&rew_size&outcome)
        % full tracking across whole trial
        for duration = 1:min(cut_end-cut_start)
            x_across_trials(trial_no,duration) = dlc_norm{1,trial_no}(duration,(plotpart-1)*3+(x+1));
            y_across_trials(trial_no,duration) = dlc_norm{1,trial_no}(duration,(plotpart-1)*3+(y+1));
        end
    end
    
    % each row = 1 trial, each column = 1 timepoint 
    x_across_trials = x_across_trials(any(x_across_trials,2),:);
    y_across_trials = y_across_trials(any(y_across_trials,2),:);
    
    % use DLC_tracking_window function to produce indices of the
    % timewindow of interest within each trial 
    nan_matrix_x = nan(length(x_across_trials(:,1)),length(x_across_trials));
    nan_matrix_y = nan(length(y_across_trials(:,1)),length(y_across_trials));    
    
    if length(start_time) == 1 % if start_time is only a single number, extend to number of trials
        start_times = start_time*ones(length(nan_matrix_x(:,1)),1);
    else
        start_times = start_time; 
    end
    
    if length(end_time) == 1
        end_times = end_time*ones(length(nan_matrix_x(:,1)),1);
    else
        end_times = end_time; 
    end
    
    for trial = 1:length(x_across_trials(:,1))
        start_frame = floor(start_times(trial)*21+1); % rounds down to nearest whole frame
        end_frame   = floor(end_times(trial)*21+1);
        cut_trial_x = x_across_trials(trial,start_frame:end_frame-1);
        cut_trial_y = y_across_trials(trial,start_frame:end_frame-1);
        nan_matrix_x(trial,start_frame:end_frame-1) = cut_trial_x; 
        nan_matrix_y(trial,start_frame:end_frame-1) = cut_trial_y; 
    end
    
    x_across_trials = nan_matrix_x;
    y_across_trials = nan_matrix_y; 
    
    % because sometimes y is negative (due to noise in tracking), turn any negative y values to 0 
    y_across_trials(y_across_trials < 0) = 0;

else % if trial type doesn't exist - NEED TO IMPROVE THIS IN FUTURE
    trial_pdf = NaN;
    disp('No such trial exists')
    %return
    
end

end



