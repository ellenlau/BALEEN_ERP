function erpPreProc(subjList,bdfFileName,directory,endTime)

%directory should be 'prime' or 'target'
%endTime should be end of time-window of interest in ms; will be extended
%by 100 ms for artifact rejection purposes

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

[~,n] = size(subjList);
count = 0;

allData = [];
dataPath = '/Volumes/PAPAGENA/BALEEN_ERP/'

for s = subjList
    count = count + 1;
       
        %%Get data
        EEG = pop_loadset('filename',strcat('S',int2str(s),'.set'),'filepath',strcat(dataPath,'raw/'));
        %%Create event list
        EEG = pop_creabasiceventlist(EEG, '', {'boundary'}, {-99});
        %%Create bins
        EEG = pop_binlister( EEG, strcat(dataPath,bdfFileName), 'no', '', 0, [], [], 0, 0, 0);
        %%Extract bin-based epochs
        EEG = pop_epochbin( EEG , [-200.0  endTime+100],  [-100.0  0]);
        %%Add an artificial channel for blink-detection by subtracting FP1 and VEOG
        EEG = pop_eegchanoperator( EEG, {  ' ch33 = ch8 - ch1 label BLINK'   });
        %%Save EEG set
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = pop_saveset(EEG, 'filename',strcat('S',int2str(s),'_elist_nelist_be'),'filepath',strcat(dataPath,'epochsERPLAB/',directory,'/'));
        
        
        
end



%plot mean at CZ
%figure;plot(-mean(allData(5,:,:),3));

%save subject averages before artifact rejection
%outname = strcat('n',int2str(n),'c',int2str(cond),'lp',int2str(lp),'subjAvg.mat');
%save(outname,'allData');

