function [tot_distance_norm,mean_tot_dist] = DLC_traj_len(dlc,x_across_trials,y_across_trials)
%DLC_TRAJ_LEN Calculate total distance travelled each trial. Normalised by
%distance between levers. 

x = 1;
y = 2;
poke = 9;
llever = 10;
rlever = 11;
lmag = 12;
rmag = 13;

% get median location of levers to use for normalisation 
median_llever_x = median(dlc.datanorm(:,((llever-1)*3)+(x+1)));
median_llever_y = median(dlc.datanorm(:,((llever-1)*3)+(y+1)));
% median_rlever_x = median(dlc.datanorm(:,((rlever-1)*3)+(x+1)));
% median_rlever_y = median(dlc.datanorm(:,((rlever-1)*3)+(y+1)));
median_poke_x   = median(dlc.datanorm(:,((poke-1)*3)+(x+1)));
median_poke_y   = median(dlc.datanorm(:,((poke-1)*3)+(y+1)));

median_llever = [median_llever_x,median_llever_y];
median_poke   = [median_poke_x,median_poke_y];
%median_rlever = [median_rlever_x,median_rlever_y];
lever_distance = norm(median_llever-median_poke);


% calculate distance travelled from one timepoint to next using pythagoras 
distance = sqrt(diff(x_across_trials,1,2).^2 + diff(y_across_trials,1,2).^2);

% sum distance travelled for each trial
tot_distance = sum(distance,2,'omitnan');
tot_distance_norm = tot_distance/lever_distance;
mean_tot_dist = mean(tot_distance_norm);
    
end
