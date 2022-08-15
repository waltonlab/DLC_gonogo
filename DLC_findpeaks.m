function [error_start,error_end] = DLC_findpeaks(vidObj,MinPeakProm,no_errors,vid_id,plot_findpeaks)
%DLC_FINDPEAKS Averages luminance of each frame and uses findpeaks to
%compare number of luminance peaks and errors for allignment. 
counter = 1;
while hasFrame(vidObj)
    s.cdata = readFrame(vidObj);
    avg_luminance(counter) = mean(mean(rgb2gray(s.cdata)));
    counter = counter+1;
end

if plot_findpeaks
    figure
    findpeaks(avg_luminance-mean(avg_luminance), 'MinPeakProminence', MinPeakProm,'NPeaks', no_errors),title(strrep(vid_id(5:11),'_',' '));
end
[~, error_start] = findpeaks(avg_luminance-mean(avg_luminance), 'MinPeakProminence', MinPeakProm,'NPeaks', no_errors);
[~, error_end]   = findpeaks((avg_luminance-mean(avg_luminance))*-1, 'MinPeakProminence', MinPeakProm);%'NPeaks', no_errors+1);

if length(error_start) ~= no_errors
    msg = 'peaks and number of errors do not match - check MinPeakProminence';
    error(msg);
end
end

% Sanity check to compare the error times between Med and the video and plot as a histogram
% hist((((end_error_times)-end_error_times(1))/100)'-((error_start-error_start(1))/25))
