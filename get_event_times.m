function [ error_times,cue_times ] = get_event_times( filename )


med_data   = mpc_read_data(filename);
med_events = med_data.E;
med_times  = med_data.T;

%% Finding start, ends, and durations of poke times
% find all the indices in events of when an animal is poking in (301 and 601)
% in_poke = find(med_events == 301|med_events == 601);

% get associated times
% in_poke_times = med_times(in_poke);

% find differences between times and from these calculate durations
% in_poke_diffs = diff(in_poke_times);

% find indices of when times are more than one, find corresponding actual times
% end_indices = find(in_poke_diffs>1);
% start_indices = [1, (ends_indices+1)];
% start_indices = start_indices(1:end-1);
% poke_starts = in_poke_times(start_indices);
% poke_ends = in_poke_times(end_indices);
% poke_durations = end_times - start_times;

%% Finding error times
error_idx = find(med_events == 503);
error_times = med_times(error_idx);

%% Finding start times of each trial
cue_idx = find(med_events == 103);
cue_times = med_times(cue_idx);

end