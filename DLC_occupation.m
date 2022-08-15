function [occ,prop_occ_sq,mean_prop_occ,tot_trials,counts] = DLC_occupation(binx,biny,pdf,n_chunks)
%DLC_OCCUPATION Calculates proportion of trials that the rat enters the
%identified bin 
%   binx: x index of bin. x = 1 means large reward lever bin when bins are 3x3
%   biny: y index of bin
%   pdf:  output of function DLC_3D_pdf 

% RETURNS:
%   prop_occ:      double of length (rats) with proportion of trials in which bin was entered
%   mean_prop_occ: mean of prop_occ
if n_chunks == 0
    for irat = 1:length(pdf)
        counts = 0;

        pdf_rat = pdf{irat};
        no_trials = length(pdf_rat);

        % Hard coded, make this better later
        for itrial = 1:length(pdf_rat)
            if length(binx) == 1
                if pdf_rat{itrial}(binx,biny) > 0
                    counts = counts+1;
                end
            elseif length(binx) == 2
                if pdf_rat{itrial}(binx(1),biny(1)) > 0 || pdf_rat{itrial}(binx(2),biny(2)) > 0
                    counts = counts+1;
                end
            end
        end

        prop_occ{irat}   = counts/no_trials;
        tot_trials{irat} = no_trials;
    end 
    
    occ = 0; 
    prop_occ_sq = cell2mat(prop_occ)';
    tot_trials = cell2mat(tot_trials)';
    mean_prop_occ = mean(prop_occ_sq);
    
else
    for irat = 1:length(pdf)
        for ichunk = 1:n_chunks
            
            counts = 0;
            
            pdf_timechunk = pdf{irat}{ichunk};
            no_trials = length(pdf_timechunk);
            
            for itrial = 1:no_trials
                
                occ_counts = 0; 
                
                if length(binx) == 1
                    if pdf_timechunk{itrial}(binx,biny) > 0
                        counts = counts+1;
                        occ_counts = occ_counts+1;
                    end
                elseif length(binx) == 2
                    if pdf_timechunk{itrial}(binx(1),biny(1)) > 0 || pdf_timechunk{itrial}(binx(2),biny(2)) > 0
                        counts = counts+1;
                        occ_counts = occ_counts+1;
                    end
                end
                
            occ{irat}{ichunk}{itrial} = occ_counts; 
                
            end  
            
        prop_occ{irat}{ichunk} = counts/no_trials;
        tot_trials{irat}{ichunk} = no_trials;     
            
        end
        
        occ{irat} = cell2mat(vertcat(occ{1,irat}{:})');
            
    end
    
    prop_occ_sq = squeeze(prop_occ)';    
    prop_occ_sq = cell2mat(cat(1,prop_occ_sq{:}));
    mean_prop_occ = mean(prop_occ_sq);
            
end
end
