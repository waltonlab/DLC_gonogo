function [trial_pdf,e] = DLC_3D_pdf(x_across_trials,y_across_trials,rats,n_bins,double_side,method,plot,cut_past_mag)

% n_bins: number of bins to divide pdf into - width and length will match
% method: set to 0 if wanting to plot pdf per trial, or 1 if wanting to plot likelihood of entering binned x/y box across trials 
% cut_past_mag: old (0) is original way of partitioning box. New (1) is getting rid of extra bit to the right of the magazine

% calculate pdf for each trial - old way: as probability density
for itrial = 1:length(x_across_trials(:,1))
    if cut_past_mag == 0
        trial_pdf{itrial} = histcounts2(x_across_trials(itrial,:),y_across_trials(itrial,:),linspace(-150,150,n_bins+1),...
            linspace(0,250,n_bins+1),'Normalization','probability');
    else
        trial_pdf{itrial} = histcounts2(x_across_trials(itrial,:),y_across_trials(itrial,:),linspace(-150,150,n_bins+1),...
            linspace(0,200,n_bins+1),'Normalization','probability');
    end
        
end

% entropy calculation
for itrial = 1:length(trial_pdf)
    
    norm_prob = trial_pdf{itrial}./sum(trial_pdf{itrial}(:));
    individual_e = norm_prob.*log(norm_prob);
    e(itrial) = -nansum(individual_e(:));
    e = e';
    
end
    

% update to binary measure if that is the method wanted
if method == 1
    for itrial = 1:length(trial_pdf)
        trial_pdf{itrial}(trial_pdf{itrial} > 0) = 1;
    end
end


%% EXCEPTION FOR RATS WITH UPSIDE DOWN BOXES THAT IS BADLY HARD CODED
if strcmp(rats,'15')|strcmp(rats,'21') % upside down box rat
    for itrial = 1:length(trial_pdf)
        trial_pdf{1,itrial} = flip(trial_pdf{1,itrial},2);
        trial_pdf{1,itrial} = flip(trial_pdf{1,itrial},1);
    end
end

%% FLIP BASED ON REWARD SIDE - top is single reward, bottom is double reward
if strcmp(double_side,'left')
    for itrial = 1:length(trial_pdf)
        trial_pdf{1,itrial} = flip(trial_pdf{1,itrial},1);
    end
end

% average across to generate mean pdf
mean_pdf = mean(cat(3, trial_pdf{:}), 3);

% plot on heatmap
if plot
    figure
    hmh = heatmap(mean_pdf,'Colormap',summer,'ColorScaling','log','CellLabelColor','none');%'GridVisible','Off'
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
end
    

end

