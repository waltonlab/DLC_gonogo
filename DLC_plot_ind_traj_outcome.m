function [] = DLC_plot_ind_traj_outcome(outcome,dlc,bodypart,actions,rews,actions_title,rews_title)
%DLC_PLOT_IND_TRAJ_OUTCOME Plots individual trajectories for an animal on a
%single figure, split by outcome (successful or failed trials). 
% Set outcome to 1 for successful trials, 0 for failed trials.

x = 1;
y = 2;

if outcome == 1
    figure
    for acts = 1:length(actions)
        for rew = 1:length(rews)
            subplot_ind = (acts-1)*length(actions)+rew;
            subplot(2,2,subplot_ind);
            set(gca,'Ydir','reverse')
            set(gca,'Xdir','reverse')
            hold on
            for i = find(actions{acts} & rews{rew} & dlc.trials.success)
                plot(dlc.trackingnorm{1,i}(:, (bodypart-1)*3+(x+1)),dlc.trackingnorm{1,i}(:, (bodypart-1)*3+(y+1)))
            end
            xlim([-150,150])
            ylim([-20,200])
            title([actions_title{acts},rews_title{rew}])
            hold off
        end
    end
    
elseif outcome == 0
    
    figure
    for rew = 1:length(rews)
        subplot_ind = rew;
        subplot(2,1,subplot_ind);
        set(gca,'Ydir','reverse')
        set(gca,'Xdir','reverse')
        hold on
        for i = find(actions{2} & rews{rew} & dlc.trials.failed)
            plot(dlc.trackingnorm{1,i}(:, (bodypart-1)*3+(x+1)),dlc.trackingnorm{1,i}(:, (bodypart-1)*3+(y+1)))
        end
        xlim([-150,150])
        ylim([-20,200])
        title([rews_title{rew}])
        hold off
    end

% if save == 1
%     plot_type = '\ind_traj';
%     save_folder = [parent_folder,experiment,plot_type];
%     label = [vid_ids{ifile}(5:11),'failed'];
%     fullfilename = fullfile(save_folder,label);
%     saveas(gcf,fullfilename,'fig');
%     saveas(gcf,fullfilename,'tiff');    
% end
    
    
    
 
end


end