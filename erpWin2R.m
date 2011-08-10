function erpWin2R(condList, timePair,label)

%%%%%%%%%%%%%%%%%% Get data

samp1 = timePair(1)/5 + 21 %%pre-stim period will only be 100 ms when loaded with getERPn32(x,-100)
samp2 = timePair(2)/5 + 21

dataV = [];
subjV = [];
condV = [];
chanV = [];

for c = condList
    data = getERPn32(c,4:32,-100,'target');

    %%Mean across time-window for channel of interest
    dataM = squeeze(mean(data(:,samp1:samp2,:),2));
    [ch,subj] = size(dataM);
    for s = 1:subj
        dataV = [dataV;dataM(:,s)];
        subjV = [subjV;ones(ch,1)*s];
        condV = [condV;ones(ch,1)*c];
        chanV = [chanV;[4:32]'];
    end
end
allData = [subjV condV chanV dataV];
size(allData)

outFile = strcat('/Users/ellen/Documents/Experiments/BALEEN/BALEEN_ERP/erplab_analysis/R/n',int2str(subj),'_',label,'_t',int2str(timePair(1)),'-',int2str(timePair(2)),'.txt')
dlmwrite(outFile,allData,'\t');