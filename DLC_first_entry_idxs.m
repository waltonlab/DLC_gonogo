function [first_entry_idxs,first_exit_idxs] = DLC_first_entry_idxs(occ)

% INPUT: occ, a matrix of trials x time chunks with occupation at each time point (1 or 0) 
% enter or leave: if looking for firsty entry, set as 1. If looking for
% first time animal has left an area, set as 0 
% RETURNS: list of indices (one per trial) of first timepoint where animal
% has entered the given region. 0 = never enters in that trial

for itrial = 1:length(occ(:,1))
    if any(occ(itrial,:)) % if any values are nonzero
        first_entry(itrial) = find(occ(itrial,:),1,'first');
        first_exits = strfind([occ(itrial,:) 0],[1 0]); 
        first_exit{itrial} = first_exits(1);
    else % if none of the values are nonzero
        first_entry(itrial) = NaN;
        first_exit{itrial} = NaN; 
    end
            
end
first_entry_idxs = first_entry';
first_exit_idxs = cell2mat(first_exit)'; 

end
