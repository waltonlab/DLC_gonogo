function [mean_cum_likelihood] = DLC_cum_occupation(occ)

for irat = 1:length(occ)
    
    occ_rat = occ{irat};
    n_trials = length(occ_rat(:,1));
    
    for itrial = 1:n_trials
        first_entry = find(occ_rat(itrial,:),1,'first');
        if ~isempty(first_entry) 
            occ_rat(itrial,first_entry:end) = 1; % change all subsequent numbers to 1
        end
    end
    mean_likelihood{irat} = mean(occ_rat,1);

end

mean_cum_likelihood = cell2mat(cat(1,mean_likelihood(:)));

end

