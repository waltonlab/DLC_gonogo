function [time_small, time_large] = DLC_get_event_latency(filename, trial_type, event)
% DLC_GET_EVENT_LATENCY Gives time of specified event from CUE ONSET in a
% trial. 
%   filename:   beh_filename from DLC_filesort (no .mat extension)
%   trial_type: GO or NOGO
%   event:      behavioural event after cue onset to be identified
%                       'tt'           = travel time in successful trials 
%                       'np_exit_fail' = nosepoke exit in failed nogo trials 

% RETURNS: 
%   time_small: list of latencies for small reward trials
%   time_large: list of latencies for large reward trials 

load([filename]);
trial_info = variable.trials.stats; 


if strcmp(trial_type,'GO')
%% GO trial latencies
    if strcmp(event,'tt')
        if strcmp(variable.double,'left')
            % latency between cue start and first lever press 
            time_small = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Right') & strcmp(trial_info(:,4),'success')),7));
            time_large = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Left') & strcmp(trial_info(:,4),'success')),7));
        elseif strcmp(variable.double,'right')
            time_small = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Left') & strcmp(trial_info(:,4),'success')),7));
            time_large = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Right') & strcmp(trial_info(:,4),'success')),7));  
        end
    elseif strcmp(event,'np_exit_tt')
        if strcmp(variable.double,'left')
            % latency between cue start and head exit in successful Go trials
            time_small = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Right') & strcmp(trial_info(:,4),'success')),6));
            time_large = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Left') & strcmp(trial_info(:,4),'success')),6));
        elseif strcmp(variable.double,'right')
            time_small = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Left') & strcmp(trial_info(:,4),'success')),6));
            time_large = cell2mat(trial_info(find(strcmp(trial_info(:,2),'GO Right') & strcmp(trial_info(:,4),'success')),6));
        end
    end

elseif strcmp(trial_type,'NOGO')
%% NOGO trial latencies
    if strcmp(event,'np_exit_fail')
        % latency between cue start and nosepoke exit 
        time_small = cell2mat(trial_info(find(strcmp(trial_info(:,2),'NO GO SINGLE') & strcmp(trial_info(:,4),'failed')),6));
        time_large = cell2mat(trial_info(find(strcmp(trial_info(:,2),'NO GO DOUBLE') & strcmp(trial_info(:,4),'failed')),6));
    elseif strcmp(event,'np_exit_succ')
        % latency between cue start and nosepoke exit
        time_small = cell2mat(trial_info(find(strcmp(trial_info(:,2),'NO GO SINGLE') & strcmp(trial_info(:,4),'success')),6));
        time_large = cell2mat(trial_info(find(strcmp(trial_info(:,2),'NO GO DOUBLE') & strcmp(trial_info(:,4),'success')),6));
    end
    
end

end

