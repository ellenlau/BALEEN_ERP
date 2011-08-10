function raw2set (subjList)

global dataE;

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for s = subjList
    %%read raw data from text file and transpose
    [dataE] = editRawText(s,0);
    [numChan,numSamples] = size(dataE);
    
    %%divide it all by calibration factor, except event channel
    load('/autofs/cluster/kuperberg/BALEEN_ERP/raw/calValues_n=32.mat')
    dataE(1,1);
    repCal = repMat(allCal(:,s),1,numSamples);
    repCal(1,1);
    dataE(1:32,:) = dataE(1:32,:)./repCal;
    dataE(1,1);
    
    %%import raw data to EEGLAB
    EEG = pop_importdata('dataformat','array','nbchan',0,'data','dataE','setname',strcat('S',int2str(s)),'subject',int2str(s),'srate',200,'pnts',0,'xmin',0);
    EEG = eeg_checkset( EEG );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
     
    %%read event information from channel 33
    EEG = pop_chanevent(EEG, 33,'edge','leading','edgelen',0);
    EEG = eeg_checkset( EEG );
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    %%read channel information
    EEG.chanlocs = readlocs('/cluster/kuperberg/BALEEN_ERP/Standard-10-20-Cap29.locs');

    %%save as EEGLAB dataset (a pair of .set and .fdt files)
    EEG = pop_saveset( EEG, 'filename',strcat('S',int2str(s),'.set'),'filepath','/autofs/cluster/kuperberg/BALEEN_ERP/raw/');
    
end

end