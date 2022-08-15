function [cdlc_pdf,x_chunked,y_chunked] = DLC_timecourse(x_across_trials,y_across_trials,rat,n_bins,double_side,cut_past_mag,interval)

% calculate no. frames/interval at 21 frames/s and divide up co-ordinates by this
n_frames = 21*interval;
n_chunks = length(x_across_trials)/n_frames; % right now this works for 1s but change if it doesn't divide equally
x_chunked = reshape(x_across_trials,length(x_across_trials(:,1)),[],n_chunks); % split up x-coordinates into time chunks
y_chunked = reshape(y_across_trials,length(y_across_trials(:,1)),[],n_chunks);

for ichunk = 1:n_chunks
    cdlc_pdf{ichunk} = DLC_3D_pdf(x_chunked(:,:,ichunk),y_chunked(:,:,ichunk),rat,n_bins,double_side,1,0,cut_past_mag); % for one rat, multiple trials 
end








%cdlc_pdf2 = DLC_3D_pdf(hmm,hmm2,rat,n_bins,double_side,1,0); % for one rat, multiple trials 