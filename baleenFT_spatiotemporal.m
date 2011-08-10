function [stat,ftc1,ftc2] = baleenFT_spatiotemporal(condPair,primeOrTar,neighborDist)
%%%Pipeline for doing spatiotemporal analysis

%%%%%%%Setting up the configuration for FieldTrip

cfg = [];
cfg.channel = {'EEG'};
cfg.latency = [.1 .9]; %% time interval over which test is applied


cfg.method = 'montecarlo';   %% Using the Monte Carlo method
cfg.statistic = 'depsamplesT';  %%Choosing paired sample t-test
cfg.correctm = 'cluster'; %%method of correction; can have the values 'no', 'max', 'cluster', 'bonferoni', 'holms', or 'fdr'. 
cfg.clusteralpha = 0.05; %% alpha used for thresholding to be included in cluster
cfg.clusterstatistic = 'maxsum'; %% test statistic at cluster level
cfg.minnbchan = 2; %%number of neighboring channels needed
cfg.tail = 0; %%two-sided t-test
cfg.clustertail = 0; %%two-sided t-test
cfg.alpha = 0.025; %%alpha level at the permutation level
cfg.numrandomization = 500; %%number of draws from permutation distribution


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
c1 = getERPn32(condPair(1),4:32,-100,primeOrTar); 
c2 = getERPn32(condPair(2),4:32,-100,primeOrTar);

ftc1 = erplab2fieldtrip(c1,'all29',primeOrTar)
ftc2 = erplab2fieldtrip(c2,'all29',primeOrTar);

cfg.neighbourdist = neighborDist;
cfg.neighbours = ft_neighbourselection(cfg,ftc1);


%%%%%%%%%%%%%%%%%%%% Run test

[stat] = ft_timelockstatistics(cfg, ftc2, ftc1) 



