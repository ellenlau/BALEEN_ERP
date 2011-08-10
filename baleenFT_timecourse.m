function [stat_lp, stat_hp] = baleenFT_timecourse(chan)
%%%Pipeline for doing CZ timecourse analysis

%%%%%%%Setting up the configuration for FieldTrip

cfg = [];
cfg.latency = [.1 .5]; %% time interval over which test is applied


cfg.method = 'montecarlo';   %% Using the Monte Carlo method
cfg.statistic = 'depsamplesT';  %%Choosing paired sample t-test
cfg.correctm = 'cluster'; %%method of correction; can have the values 'no', 'max', 'cluster', 'bonferoni', 'holms', or 'fdr'. 
cfg.clusteralpha = 0.05; %% alpha used for thresholding to be included in cluster
cfg.clusterstatistic = 'maxsum'; %% test statistic at cluster level
cfg.tail = 0; %%two-sided t-test
cfg.clustertail = 0; %%two-sided t-test
cfg.alpha = 0.025; %%alpha level at the permutation level
cfg.numrandomization = 1000; %%number of draws from permutation distribution

cfg.neighbours = []


%%setting up the design matrix
subj = 32;
designE = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design = design;
cfg.uvar  = 1;
cfg.ivar  = 2;


%%%%%%%%%%%%%%%%%% Get data
c1 = getERPn32(1,5,-100, 'target',0);
c2 = getERPn32(2,5,-100, 'target',0);
c6 = getERPn32(6,5,-100, 'target',0);
c7 = getERPn32(7,5,-100, 'target',0);


ft1 = erplab2fieldtrip(c1,chan,'target');
ft2 = erplab2fieldtrip(c2,chan,'target');
ft6 = erplab2fieldtrip(c6,chan,'target');
ft7 = erplab2fieldtrip(c7,chan,'target');


%%%%%%%%%%%%%%%%%%%% Run test

[stat_lp] = ft_timelockstatistics(cfg, ft2, ft1) %%lp
[stat_hp] = ft_timelockstatistics(cfg, ft7, ft6) %%hp


%%%%%% Plot results

figure;plot(ft1.time*1000,ft2.avg-ft1.avg,'k','LineWidth',3);hold;plot(ft7.time*1000,ft7.avg-ft6.avg,'r','LineWidth',3)
axis([-100 500 -6 2])
set(gca,'YDir','reverse')

[~,n] = size(stat_lp.negclusters)

msg = 'lp'

for x = 1:n
    x
temp = [];
   
    if stat_lp.negclusters(x).prob < .09
       x
       for y = 1:size(stat_lp.time,2)
           
           if stat_lp.negclusterslabelmat(y) == x
               temp(end+1) = stat_lp.time(y)*1000;
           end        
       end
       size(temp)
       temp(1)
       temp(end)
       line([temp(1) temp(end)],[-4.5 -4.5],'LineWidth',3)
    end
end
temp

msg = 'hp'

for x = 1:n
    x
temp = [];
   
    if stat_hp.negclusters(x).prob < .05
       x
       for y = 1:size(stat_hp.time,2)
           
           if stat_hp.negclusterslabelmat(y) == x
               temp(end+1) = stat_hp.time(y)*1000;
           end        
       end
       size(temp)
       temp(1)
       temp(end)
       line([temp(1) temp(end)],[-5.5 -5.5],'LineWidth',3)
    end
end
temp
               
       
