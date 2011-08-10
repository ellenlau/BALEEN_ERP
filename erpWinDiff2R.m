function erpWinDiff2R(cond1List, cond2List,timePair)

%%%%%%%%%%%%%%%%%% Get data

samp1 = timePair(1)/5 + 21 %%pre-stim period will only be 100 ms when loaded with get29ERP(x,-100)
samp2 = timePair(2)/5 + 21

dataV = [];
subjV = [];
condV = [];
chanV = [];

[~,n] = size(cond1List);

for c = 1:n
    condCode = strcat(int2str(cond2List(c)),'-',int2str(cond1List(c)))
    data1 = getERPn32(cond1List(c),4:32,-100,'target');
    data2 = getERPn32(cond2List(c),4:32,-100,'target');
    %%Mean across time-window for channel of interest
    data = data2-data1;
    dataM = squeeze(mean(data(:,samp1:samp2,:),2));
    [ch,subj] = size(dataM);
    for s = 1:subj
        dataV = [dataV;dataM(:,s)];
        subjV = [subjV;ones(ch,1)*s];
        condV = [condV;ones(ch,1)*(c*10)];
        chanV = [chanV;[4:32]'];
    end
end
allData = [subjV condV chanV dataV];
size(allData)

outFile = strcat('/Users/ellen/Documents/Experiments/BALEEN/BALEEN_ERP/erplab_analysis/R/n',int2str(subj),'_Diff_t',int2str(timePair(1)),'-',int2str(timePair(2)),'.txt')
dlmwrite(outFile,allData,'\t');