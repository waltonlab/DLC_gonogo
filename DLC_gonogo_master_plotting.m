%% PLOTTING
% loop through all files to plot 

%% CHOOSE EXPERIMENT, SUBJECTS, AND SESSIONS
experiment      = 'local_D1agonist_cohort2'; % change to experiment of interest
rats            = {'13','15','16','17','19','20','21','22','23','25','26','27'}
drug            = {'sal_'};

av_between      = 1; 
plot_heatmap    = 1;
plot_ind_traj_outcome = 0; 

chosen_outcome  = 'small_rtex';
trial_analysis = 'rtex';

n_bins = 18;

pdf_method = 1;

% for sequential time analysis - time chunks 
interval = 1; 

cut_past_mag = 0;

% small_go_success
% small_rtex
% small_lever 
% small_nogo_success
% small_nogo_failed


%% GET FILENAMES 
parent_folder = '/Users/grimal/Dropbox/dopamine_pharm/data/video/DLC_extracted/';
%'C:\Users\grimal\Desktop\da_pharm\video_analyses\dlc\output_files_with_norm\';
filenames = get_exp_filenames_dlc(parent_folder,experiment,'analyse',rats,drug);

% for behaviour filenames for extracting latencies, e.g. travel time 
beh_directory = '/Users/grimal/Dropbox/dopamine_pharm/data/behaviour/extracted/';
[beh_filenames, beh_file_ids,dlc_filenames,dlc_file_ids,vid_ids] = DLC_filesort(beh_directory,experiment,rats,drug);

%% PLOTTING PDF HEATMAPS 

for ifile = 1:length(filenames)
    load(filenames{ifile});
    fprintf('Working on %s \n',filenames{ifile})
    
    %% create trial markers 
    go_outcomes         = {dlc.trials.success, dlc.trials.rt_exceeded, dlc.trials.wrong_lever};
    go_outcomes_title   = {' success', ' rt exceeded', ' wrong lever'};
    nogo_outcomes       = {dlc.trials.success, dlc.trials.failed};
    nogo_outcomes_title = {' success', ' failed'};
    rews                = {dlc.trials.single,dlc.trials.double};
    rews_title          = {' single', ' double'};
    actions             = {dlc.trials.Go, dlc.trials.NoGo};
    actions_title       = {'Go', 'NoGo'};
    bodypart            = dlc.tracked_parts.nose;
    
    %% BEHAVIOUR LATENCIES
    
    % travel time, from nosepoke exit to first lever press on correct lever
    if strcmp(trial_analysis,'tt')
        
        [lat_small_start,lat_large_start] = DLC_get_event_latency(beh_filenames{ifile},'GO','np_exit_tt');
        [lat_small_end,lat_large_end]     = DLC_get_event_latency(beh_filenames{ifile},'GO','tt');
        
        % produce matrices of x and y co-ordinates per frame across timewindow 
        if strcmp(chosen_outcome,'small_go_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.single,go_outcomes{1},lat_small_start,lat_small_end);     
        elseif strcmp(chosen_outcome,'large_go_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.double,go_outcomes{1},lat_large_start,lat_large_end);
        end
        
        
    % rt exceeded, from beginning to 5s 
    elseif strcmp(trial_analysis,'rtex')
        
        lat_small_start = 0;
        lat_large_start = 0;
        lat_small_end = 5;
        lat_large_end = 5; 
        
        if strcmp(chosen_outcome,'small_rtex')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.single,go_outcomes{2},lat_small_start,lat_small_end); 
        elseif strcmp(chosen_outcome,'large_rtex')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.double,go_outcomes{2},lat_large_start,lat_large_end);
        end       
        
    % cue onset to + 5 in successful go
    elseif strcmp(trial_analysis,'full_go')

        lat_small_start = 0;
        lat_large_start = 0;
        lat_small_end = 5;
        lat_large_end = 5;
        
        if strcmp(chosen_outcome,'small_go_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.single,go_outcomes{1},lat_small_start,lat_small_end); 
        elseif strcmp(chosen_outcome,'large_go_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.double,go_outcomes{1},lat_large_start,lat_large_end);
        end
        
    % go - nosepoke exit to +1s 
    elseif strcmp(trial_analysis,'ones_go')
        
        [lat_small_start,lat_large_start] = DLC_get_event_latency(beh_filenames{ifile},'GO','np_exit_tt');
        lat_small_end = lat_small_start + 1;
        lat_large_end = lat_large_start + 1;

        if strcmp(chosen_outcome,'small_go_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.single,go_outcomes{1},lat_small_start,lat_small_end); 
        elseif strcmp(chosen_outcome,'large_go_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.Go,dlc.trials.double,go_outcomes{1},lat_large_start,lat_large_end);
        end
        
    % failed nogo trials, from  nosepoke exit to 1s after 
    elseif strcmp(trial_analysis,'np_exit_error')
        
        [lat_small_start,lat_large_start] = DLC_get_event_latency(beh_filenames{ifile},'NOGO','np_exit_fail');
        lat_small_end = lat_small_start + 1;
        lat_large_end = lat_large_start + 1; 
        lat_small_start = 0; % REMOVE THIS IF NOT WANTING TO LOOK FROM CUE ONSET
        lat_large_start = 0;
        
        if strcmp(chosen_outcome,'small_nogo_failed')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.NoGo,dlc.trials.single,nogo_outcomes{2},lat_small_start,lat_small_end); 
        elseif strcmp(chosen_outcome,'large_nogo_failed')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.NoGo,dlc.trials.double,nogo_outcomes{2},lat_large_start,lat_large_end);
        end    
        
    % successful nogo trials, from nosepoke exit to 1s after 
    elseif strcmp(trial_analysis,'np_exit_success')
        
        [lat_small_start,lat_large_start] = DLC_get_event_latency(beh_filenames{ifile},'NOGO','np_exit_succ');
        lat_small_end = lat_small_start + 1;
        lat_small_end(lat_small_end>5) = 5; % if it's bigger than 5s, replace with 5
        lat_large_end = lat_large_start + 1; 
        lat_large_end(lat_large_end>5) = 5;
        
        if strcmp(chosen_outcome,'small_nogo_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.NoGo,dlc.trials.single,nogo_outcomes{1},lat_small_start,lat_small_end); 
        elseif strcmp(chosen_outcome,'large_nogo_success')
            [x_across_trials,y_across_trials] = DLC_tracking_window(dlc,bodypart,dlc.trials.NoGo,dlc.trials.double,nogo_outcomes{1},lat_large_start,lat_large_end);
        end    
        
    end

    trial_n(ifile) = length(x_across_trials(:,1))';
    double_side = dlc.behaviour.double;
        
    [dlc_pdf{ifile},rat_e{ifile}] = DLC_3D_pdf(x_across_trials,y_across_trials,rats{ifile},n_bins,double_side,pdf_method,0,cut_past_mag);
    [tot_distance{ifile},mean_tot_dist{ifile}] = DLC_traj_len(dlc,x_across_trials,y_across_trials);  
    [cdlc_pdf{ifile},x_chunked,y_chunked] = DLC_timecourse(x_across_trials,y_across_trials,rats{ifile},n_bins,double_side,cut_past_mag,interval); % chunked into timebins 
    [whole_dlc_pdf{ifile},~,~] = DLC_timecourse(x_across_trials,y_across_trials,rats{ifile},n_bins,double_side,cut_past_mag,1/21); % for analysis of where rats first go - each chunk is a frame

    if av_between == 1 % average per rat first and then across them (latter is out of loop) 
        mean_pdf{ifile} = mean(cat(3, dlc_pdf{1,ifile}{:}), 3);
    end
    
    
    if plot_ind_traj_outcome == 1
        outcome = 1;
        DLC_plot_ind_traj_outcome(outcome,dlc,bodypart,actions,rews,actions_title,rews_title)
        outcome = 0;
        DLC_plot_ind_traj_outcome(outcome,dlc,bodypart,actions,rews,actions_title,rews_title)
    end
end
 
% calculate entropy from mean of each rat
for irat = 1:length(mean_pdf)
    
    norm_prob = mean_pdf{irat}./sum(mean_pdf{irat}(:));
    individual_e = norm_prob.*log(norm_prob);
    e(irat) = -nansum(individual_e(:));
    e = e';
    
end

% if calculating entropy on a per trial basis
for irat = 1:length(rat_e)
    mean_e(irat) = nanmean(rat_e{irat})';
end


% timecourse analysis - can't handle complicated latencies etc yet so make
% sure x_across_trials etc is full 
n_chunks = length(cdlc_pdf{1});
[~,cprop_occ_large,cmean_prop_occ_large,~,counts_l] = DLC_occupation(1,1,cdlc_pdf,n_chunks);
[~,cprop_occ_small,cmean_prop_occ_small,~,counts_s] = DLC_occupation(3,1,cdlc_pdf,n_chunks);
[~,cprop_occ_mag,cmean_prop_occ_mag,~,counts_m]     = DLC_occupation(2,3,cdlc_pdf,n_chunks);
[~,cprop_occ_poke,cmean_prop_occ_poke,~,counts_p]     = DLC_occupation(2,1,cdlc_pdf,n_chunks);

% occupation at every frame 
n_chunks_whole = length(whole_dlc_pdf{1});
[occ_large, wprop_occ_large,wmean_prop_occ_large,~,wcounts_l] = DLC_occupation(1,1,whole_dlc_pdf,n_chunks_whole);
[occ_small, wprop_occ_small,wmean_prop_occ_small,~,wcounts_s] = DLC_occupation(3,1,whole_dlc_pdf,n_chunks_whole);
[occ_mag, wprop_occ_mag,wmean_prop_occ_mag,~,wcounts_m]       = DLC_occupation(2,3,whole_dlc_pdf,n_chunks_whole);
[occ_poke, wprop_occ_poke, wmean_prop_occ_poke,~,wcounts_p]   = DLC_occupation(2,1,whole_dlc_pdf,n_chunks_whole);

% use this to calculate cumulative probability of visiting each of these
% features
mean_cum_likelihood_large = DLC_cum_occupation(occ_large);
mean_cum_likelihood_small = DLC_cum_occupation(occ_small);
mean_cum_likelihood_mag  = DLC_cum_occupation(occ_mag); 

% prop only = proportion of trials animal enters small, large, mag areas first
% prop_first: proportion of trials that this is the first place they go(levers or mag)
% prop lever to mag: proportion of trials animals complete this sequence for small and large 
% time in poke area = how long (s) animal is in poke area (generally after nogo error) 
% first entry latency: latency to get to first box element (levers or mag)
[prop_only,prop_first,prop_lever_to_mag,time_in_poke_area,time_in_poke_area_raw,first_entry_latency] = DLC_compare_first_idxs(1,occ_large,occ_small,occ_mag,occ_poke);

% occupation - overall 
[~,prop_occ_large,mean_prop_occ_large,~,occ_counts_l]      = DLC_occupation(1,1,dlc_pdf,0);
[~,prop_occ_small,mean_prop_occ_small,~,occ_counts_s]      = DLC_occupation(3,1,dlc_pdf,0);
[~,prop_occ_mag,mean_prop_occ_mag,~,occ_counts_m]          = DLC_occupation(2,3,dlc_pdf,0);
[~,prop_occ_middle,mean_prop_occ_middle,~,occ_counts_mid]  = DLC_occupation(2,2,dlc_pdf,0);
[~,prop_occ_levers,mean_prop_occ_levers,~,occ_counts_lev]  = DLC_occupation([1,3],[1,1],dlc_pdf,0);
prop_occ = [prop_occ_small,prop_occ_large,prop_occ_middle,prop_occ_mag,prop_occ_levers];

[~,~,~,tot_trials,~] = DLC_occupation(1,1,dlc_pdf,0);

if av_between == 1 % averaging between rats 
    
     PLOTdata = mean(cat(3,mean_pdf{:}), 3);
        
else % average across rats without avering within first
    all_pdf = [];
    for i = 1:length(dlc_pdf)
        data = dlc_pdf{i};
        all_pdf = [all_pdf, data];
    end
    
    PLOTdata = mean(cat(3,all_pdf{:}), 3);
end


if plot_heatmap
    
    figure
    n_colors = 100;
    if strcmp('schh',drug)
        R = linspace(0, 1,   n_colors);
        B = linspace(0, 0.35, n_colors);
        G = linspace(0, 0.35, n_colors);
    elseif strcmp('skfh',drug)
        R = linspace(0, 0.2,   n_colors);
        B = linspace(0, 1, n_colors);
        G = linspace(0, 0.7, n_colors);  
    elseif strcmp('sal_',drug)
        R = linspace(0, 1,   n_colors);
        B = linspace(0, 1, n_colors);
        G = linspace(0, 1, n_colors);  
    end
    custom_colormap = ([R(:),G(:),B(:)]);
    hmh = heatmap(PLOTdata,'Colormap',custom_colormap,'GridVisible','Off','CellLabelColor','none');
    %hmh.ColorScaling = 'log';
    hmh.ColorLimits = [0 1];
    %hmh = heatmap(PLOTdata,'Colormap',summer,'ColorScaling','log','GridVisible','Off','ColorLimits',[0 ]);
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
    set(gcf,'position',[100,100,400,300])
   
end

mean_tot_dist = cell2mat(mean_tot_dist)';



% reshaping mean_pdf for easier analysis 
% for irat = 1:length(filenames)
%     long_pdf(:,irat) = reshape(mean_pdf{irat},[1,9]);
% end



% save figures in .fig and .jpg formats

%if av_between == 1
%     across_or_within = 'within';
% else
%     across_or_within = 'across';
% end

% save_folder = [parent_folder,experiment];
% label = strcat(drug{1},chosen_outcome,across_or_within);
% fullfilename = fullfile(save_folder,label);
% saveas(gca,label,'fig');
% saveas(gca,label,'tiff');    




























% if av_between == 1
%     PLOTgo_small_success = mean(cat(3,mean_go_small_success_pdf{:}));
% end
        
%         % double reward Go 
%             trial = 'Go_double';
%             DLC_3D_pdf(all_dlc(idlc),bodypart,all_dlc(idlc).trials.Go,all_dlc(idlc).trials.double,go_outcomes{go_out},trial,1);
%         end
%     
%     
%     
% end
%     
%     
%     
%     
%     
%     
%     
% end
% 

%            
% 
% all_dlc = dlc; % include if loading from file
% 
% % single trial or session plots 
% for idlc = 1:length(all_dlc)
%     
% % create trial markers 
%     go_outcomes         = {all_dlc(idlc).trials.success, all_dlc(idlc).trials.rt_exceeded, all_dlc(idlc).trials.wrong_lever};
%     go_outcomes_title   = {' success', ' rt exceeded', ' wrong lever'};
%     nogo_outcomes       = {all_dlc(idlc).trials.success, all_dlc(idlc).trials.failed};
%     nogo_outcomes_title = {' success', ' failed'};
%     rews                = {all_dlc(idlc).trials.single,all_dlc(idlc).trials.double};
%     rews_title          = {' single', ' double'};
%     actions             = {all_dlc(idlc).trials.Go, all_dlc(idlc).trials.NoGo};
%     actions_title       = {'Go', 'NoGo'};
%     bodypart            = all_dlc(idlc).tracked_parts.nose;
% 
% % plotting individual trial trajectories
%     if plot_ind_traj == 1
%         DLC_plot_ind_traj(trial_no,all_dlc(idlc))
%     end
%     
% % plotting average trial trajectories for each session
%     if plot_ind_traj_outcome == 1
%         outcome = 1;
%         DLC_plot_ind_traj_outcome(outcome,all_dlc(idlc),bodypart,actions,rews,actions_title,rews_title)
%         outcome = 0;
%         DLC_plot_ind_traj_outcome(outcome,all_dlc(idlc),bodypart,actions,rews,actions_title,rews_title)
%     end
%     
% end   
%     
%     