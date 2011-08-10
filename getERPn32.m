function data = getERPn32(cond,chan,begTime,primeOrTar,filt)


%%this just extracts all the subject averages for a given condition into a
%%channel x sample x subject matrix. 

%%you choose the first sample that you want, in ms, for 'begTime'.
%%for example, if you want epoch to start with -100 ms, you would enter
%%-100 for this parameter

%%filt should be 0 normally or 1 if you want lp 20hz data

samp1 = begTime/5 + 41; %%In this dataset, pre-stim period is 200 ms, hence the 41
filePath = strcat('/Users/ellen/Documents/Experiments/BALEEN/BALEEN_ERP/erplab_analysis/erp/',primeOrTar,'/')
if filt == 1
    filePath = strcat(filePath,'lp20/');
end

eeglab
    

for x = 1:32
    if strcmp(primeOrTar,'prime')
        filename = strcat('s',int2str(x),'p.erp')
    else
        filename = strcat('s',int2str(x),'.erp')
    end
    

    ERP = pop_loaderp({ filename }, filePath);
    subjData = ERP.bindata(chan,:,cond);
    data(:,:,x) = subjData(:,samp1:end);
end

