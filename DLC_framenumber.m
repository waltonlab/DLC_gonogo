function [cut_start,cut_end] = DLC_framenumber(trialstartsMED,videostarttime,ts,period)
%DLC_FRAMENUMBER Converts behaviour into DLC frame numbers for cutting
%trials.

% convert trial start times from Med timing to frame number on video - Med resolution is in .01 seconds
trialstartsMED_vid = trialstartsMED+ videostarttime;

% Convert values to whole numbers, round numbers down
cut_start = trialstartsMED_vid;
cut_end = trialstartsMED_vid + period;

%Convert time into DLC "frame number"
for i = 1: length(cut_start)
    [ ~, cut_start(i)] = min(abs((ts - cut_start(i))));
    [ ~, cut_end(i)] = min(abs((ts - cut_end(i))));
end

% add something here about if cut_start 

end