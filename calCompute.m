function calCompute(subjList)

%% creates a channel x subject matrix of calibration values that you need
%% to divide by later to convert to microVolts

global dataC;
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

[m,n] = size(subjList);
allCal = zeros(32,n);
count = 0;

for s = subjList
    count = count + 1;
    %%read raw data from text file and transpose
    dataC = editRawText(s,1);

    %%import raw data to EEGLAB

    EEG = pop_importdata('dataformat','array','nbchan',0,'data','dataC','setname','cal','srate',200,'pnts',0,'xmin',0);
    EEG = eeg_checkset( EEG );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
     
    %%read event information from channel 33
    EEG = pop_chanevent(EEG, 33,'edge','leading','edgelen',0);
    EEG = eeg_checkset( EEG );
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    %%Extract epochs and average all triggers
    epCEEG = pop_epoch(EEG,{},[-.3 .3],'epochinfo','yes')
    epC = epCEEG.data;
    epCAvg = mean(epC,3);
    calLow = mean(epCAvg(:,50:55),2); %% ~ -50 ms
    calHigh = mean(epCAvg(:,80:85),2); %% ~ 90 ms
    
    calFactor = (calHigh-calLow)/10;  %% divide by 10 microVolts
    allCal(:,count) = calFactor;
    
end

fileName = strcat('calValues_n=',int2str(count),'.mat');
save(fileName, 'allCal');