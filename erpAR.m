function erpAR(subjList, peakToPeakThresh, peakToPeakChan, cw)

%%% cw is 'prime' or 'target'

for s = subjList
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename',strcat('S',int2str(s),'_elist_nelist_be.set'),'filepath',strcat('/Volumes/PAPAGENA/BALEEN_ERP/epochsERPLAB/',cw,'/'));
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

    EEG = pop_artmwppth( EEG, [-200  695], peakToPeakThresh, 200, 50,  peakToPeakChan, [ 1 2]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    pop_summary_rejectfields(EEG)

    EEG = pop_artstep( EEG, [-200  695], 40, 200, 10,  33, [ 1 3]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 

    EEG = pop_artstep( EEG, [-200  695], 25, 400, 10,  2, [ 1 4]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off'); 

    pop_summary_AR_eeg_detection(EEG, strcat('/Volumes/PAPAGENA/BALEEN_ERP/epochsERPLAB/',cw,'/AR_summary_S',int2str(s),'_elist_nelist_be_ar_ar_ar.txt'));

    EEG = pop_sincroartifacts(EEG, 3);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off'); 

    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat('S',int2str(s),'_elist_nelist_be_ar_ar_ar.set'),'filepath',strcat('/Volumes/PAPAGENA/BALEEN_ERP/epochsERPLAB/',cw,'/'));
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    

end