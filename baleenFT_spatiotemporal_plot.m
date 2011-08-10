function baleenFT_spatiotemporal_plot(stat,ftc1,ftc2)

%%%%%% Plot results

timestep = 0.025;      %(in seconds)
sampling_rate = ftc1.fsample;
sample_count = length(stat.time);
j = [.1:timestep:1];   % Temporal endpoints (in seconds) of the ERP average computed in each subplot
m = [1:timestep*sampling_rate:sample_count];  % temporal endpoints in MEEG samples


ftc2vsftc1 = ftc2;  %%initialize this new structure
ftc2vsftc1.avg = ftc2.avg-ftc1.avg;
ftc2vsftc1.dimord = 'chan_time';

maxPlots = size(m,2)-1;

if isfield(stat,'negclusters') 
    if ~isempty(stat.negclusters)
        figure;  
        neg_cluster_pvals = [stat.negclusters(:).prob];
        neg_signif_clust = find(neg_cluster_pvals < stat.cfg.alpha)
        neg = ismember(stat.negclusterslabelmat, neg_signif_clust);

        for k = 1:maxPlots;
             subplot(6,5,k);   
             cfg = [];   
             cfg.xlim=[j(k) j(k+1)];   
             cfg.zlim = [-1.0e-13 1.0e-13];   
             neg_int = all(neg(:, m(k):m(k+1)), 2);
             cfg.highlight = 'on';
             cfg.highlightchannel = find(neg_int);       
             cfg.comment = 'xlim';   
             cfg.commentneg = 'title';   
             ft_topoplotER(cfg, ftc2vsftc1);
        end 
    end

end


if isfield(stat,'posclusters')
    if ~isempty(stat.posclusters) 
    
        figure;
        pos_cluster_pvals = [stat.posclusters(:).prob];
        pos_signif_clust = find(pos_cluster_pvals < stat.cfg.alpha);
        pos = ismember(stat.posclusterslabelmat, pos_signif_clust);

        for k = 1:maxPlots;
             subplot(6,5,k);   
             cfg = [];   
             cfg.xlim=[j(k) j(k+1)];   
             cfg.zlim = [-1.0e-13 1.0e-13];   
             pos_int = all(pos(:, m(k):m(k+1)), 2);
             cfg.highlight = 'on';
             cfg.highlightchannel = find(pos_int);       
             cfg.comment = 'xlim';   
             cfg.commentpos = 'title';   
             ft_topoplotER(cfg, ftc2vsftc1);
        end 
    end
end
