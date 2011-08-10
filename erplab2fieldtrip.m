function ftData = erplab2fieldtrip (chanData,chanName,primeOrTar);

[ALLEEG EEG CURRENTSET] = eeglab;
filePath = strcat('/Users/ellen/Documents/Experiments/BALEEN/BALEEN_ERP/erplab_analysis/epochsERPLAB/',primeOrTar,'/')

%%This is just getting the channel info from random subject
EEG = pop_loadset('filename',strcat(filePath,'S1_elist_nelist_be.set'));

if strcmp(chanName,'all29')
    EEG = pop_select( EEG,'channel',{'Fz' 'Cz' 'Pz' 'C3' 'Fp1' 'F7' 'T3' 'T5' 'O1' 'F3' 'FC5' 'CP5' 'P3' 'FC1' 'CP1' 'Fpz' 'FC2' 'CP2' 'Oz' 'F4' 'FC6' 'CP6' 'P4' 'C4' 'Fp2' 'F8' 'T4' 'T6' 'O2'});
else EEG = pop_select( EEG,'channel',{chanName});
end

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 

subjEEG = EEG;

subjEEG.data = chanData;

ftData = [];
ftData = eeglab2fieldtrip(subjEEG,'timelockanalysis','none');
ftData.individual = subjEEG.data;
ftData.dimord = 'chan_time_subj';

ftData.time = ftData.time(:,21:end); 
