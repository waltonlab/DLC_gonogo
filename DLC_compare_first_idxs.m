function [prop_only, prop_first, prop_lever_to_mag,time_in_poke_area,time_in_poke_raw,first_entry_latency] = DLC_compare_first_idxs(prop_or_no,occ_large,occ_small,occ_mag,occ_poke)


%prop_or_no
% 0 for counts
% 1 for proportion

% return proportion of trials that animals go to:
% PROP ONLY
% 1. only small lever
% 2. only large lever
% 3. only food mag
% PROP LEVER TO MAG
% 4. either lever then food mag
% 5. small lever then food mag
% 6. large lever then food mag 
% PROP FIRST
% 7. small lever first 
% 8. large lever first
% 9. mag first 

for irat = 1:length(occ_large)
    
    [first_entry_idxs_large,first_exit_idxs_large] = DLC_first_entry_idxs(occ_large{irat});
    [first_entry_idxs_small,first_exit_idxs_small] = DLC_first_entry_idxs(occ_small{irat});
    [first_entry_idxs_mag,first_exit_idsx_mag]   = DLC_first_entry_idxs(occ_mag{irat});

    first_idxs = [first_entry_idxs_large,first_entry_idxs_small,first_entry_idxs_mag];
    n_trials   = length(first_entry_idxs_large); 

    % proportion of trials that this is the only place they go to 
    if prop_or_no == 1
        prop_only_small{irat} = sum(length(find(isnan(first_idxs(:,1)) & isnan(first_idxs(:,3)) & ~isnan(first_idxs(:,2)))))/n_trials; % only small lever
        prop_only_large{irat} = sum(length(find(~isnan(first_idxs(:,1)) & isnan(first_idxs(:,3)) & isnan(first_idxs(:,2)))))/n_trials; % only large lever
        prop_only_mag{irat} = sum(length(find(isnan(first_idxs(:,1)) & ~isnan(first_idxs(:,3)) & isnan(first_idxs(:,2)))))/n_trials; % only mag
    else 
        prop_only_small{irat} = sum(length(find(isnan(first_idxs(:,1)) & isnan(first_idxs(:,3)) & ~isnan(first_idxs(:,2))))); % only small lever
        prop_only_large{irat} = sum(length(find(~isnan(first_idxs(:,1)) & isnan(first_idxs(:,3)) & isnan(first_idxs(:,2))))); % only large lever
        prop_only_mag{irat} = sum(length(find(isnan(first_idxs(:,1)) & ~isnan(first_idxs(:,3)) & isnan(first_idxs(:,2))))); % only mag       
    end
    
    % proportion of trials that this is the first place they go to
    for itrial = 1:n_trials
        if all(isnan(first_idxs(itrial,:))) 
            idx_of_first(itrial) = 0;
        elseif any(~isnan(first_idxs(itrial,:))) % if the row has non-NaN
            [~,idx_of_first(itrial)] = min(first_idxs(itrial,:)); % find index of smallest value 
        end
    end
    % SOMETHING STILL BUGGY HERE. CLEARING VAR IDX_OF_FIRST FOR NOW
    if prop_or_no == 1
        prop_first_small{irat} = sum(idx_of_first(:) == 2)/n_trials;
        prop_first_large{irat} = sum(idx_of_first(:) == 1)/n_trials;
        prop_first_mag{irat}   = sum(idx_of_first(:) == 3)/n_trials;
    else
        prop_first_small{irat} = sum(idx_of_first(:) == 2);
        prop_first_large{irat} = sum(idx_of_first(:) == 1);
        prop_first_mag{irat}   = sum(idx_of_first(:) == 3);    
    end
    clear idx_of_first

    % order in which animals visit box features 
    [sorted_visits, sorted_visits_idx] = sort(first_idxs,2);
    nan_locs = isnan(sorted_visits); % where the nans are
    sorted_visits_idx(nan_locs) = sorted_visits(nan_locs); % put them into index matrix 
    % SMALL LEVER --> MAG & LARGE LEVER --> MAG
    seq_sl = [2 3]; 
    seq_ll = [1 3]; 
    slever_to_mag = 0;
    llever_to_mag = 0;
    for irow = 1:length(sorted_visits_idx(:,1))
        if ~isempty(strfind(sorted_visits_idx(irow,:),seq_sl))
            slever_to_mag = slever_to_mag+1; 
        elseif ~isempty(strfind(sorted_visits_idx(irow,:),seq_ll))
            llever_to_mag = llever_to_mag+1; 
        end
    end
    
    if prop_or_no ==1
        prop_slever_to_mag(irat) = slever_to_mag/n_trials; 
        prop_llever_to_mag(irat) = llever_to_mag/n_trials; 
    else
        prop_slever_to_mag(irat) = slever_to_mag;
        prop_llever_to_mag(irat) = llever_to_mag;    
    end

    % how long does it take them to get to this location for the first
    % time
    first_entry_lat{irat} = nanmean(first_idxs/21); % convert from frames to s, average
    if length(first_entry_lat{irat}) < 3
        first_entry_lat{irat} = [NaN NaN NaN]; 
    end

    % calculating how long an animal is in the poke region
    [first_entry_idxs_poke,first_exit_idxs_poke] = DLC_first_entry_idxs(occ_poke{irat}); 
    time_in_poke{irat} = nanmean(first_exit_idxs_poke - first_entry_idxs_poke)/21;
    time_in_poke_raw{irat} = (first_exit_idxs_poke - first_entry_idxs_poke)/21;
    
end 

prop_only  = [cell2mat(prop_only_small)',cell2mat(prop_only_large)',cell2mat(prop_only_mag)'];
prop_first = [cell2mat(prop_first_small)',cell2mat(prop_first_large)',cell2mat(prop_first_mag)'];
prop_first_other = 1-sum(prop_first,2);
prop_first = [prop_first,prop_first_other];
prop_lever_to_mag = [prop_slever_to_mag',prop_llever_to_mag'];

time_in_poke_area = cell2mat(time_in_poke)';
first_entry_latency = vertcat(first_entry_lat{:});

end

