function [median_poke_x,median_poke_y] = DLC_plotbox(data,double_side,plot)
% plot median points of box features 
x = 1;
y = 2;
poke = 9;
llever = 10;
rlever = 11;
lmag = 12;
rmag = 13;

median_poke_x   = median(data(:,((poke-1)*3)+(x+1)));
median_poke_y   = median(data(:,((poke-1)*3)+(y+1)));
median_llever_x = median(data(:,((llever-1)*3)+(x+1)));
median_llever_y = median(data(:,((llever-1)*3)+(y+1)));
median_rlever_x = median(data(:,((rlever-1)*3)+(x+1)));
median_rlever_y = median(data(:,((rlever-1)*3)+(y+1)));
median_lmag_x   = median(data(:,((lmag-1)*3)+(x+1)));
median_lmag_y   = median(data(:,((lmag-1)*3)+(y+1)));
median_rmag_x   = median(data(:,((rmag-1)*3)+(x+1)));
median_rmag_y   = median(data(:,((rmag-1)*3)+(y+1)));

if plot
    scatter(median_poke_x,median_poke_y,100,'MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[0.8,0.3,0.5],'LineWidth',1.5)
    if strcmp(double_side,'left') % gold = double
        scatter(median_rlever_x,median_rlever_y,100,'MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[1,0.8,0],'LineWidth',1.5)
        scatter(median_llever_x,median_llever_y,100,'MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[1.0,0.3,0],'LineWidth',1.5)
    else
        scatter(median_llever_x,median_llever_y,100,'MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[1,0.8,0],'LineWidth',1.5)
        scatter(median_rlever_x,median_rlever_y,100,'MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[1.0,0.3,0],'LineWidth',1.5)
    end
    scatter(median_lmag_x,median_lmag_y,100,'MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[0.8,0.3,0.5],'LineWidth',1.5)
    scatter(median_rmag_x,median_rmag_y,100,'MarkerEdgeColor',[1,1,1],'MarkerFaceColor',[0.8,0.3,0.5],'LineWidth',1.5)
end

end

