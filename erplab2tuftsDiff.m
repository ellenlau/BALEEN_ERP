
function erplab2tuftsDiff(cond1List, cond2List,primeOrTar,outFile)

%%extracts unfiltered diff

filePath = strcat('/Users/ellen/Documents/Experiments/BALEEN/BALEEN_ERP/erplab_analysis/tufts_format/');
outFile = strcat(filePath,outFile)

cDataAll = [];

binCount = 0;
for c = cond1List
    binCount = binCount + 1;

    data1 = getERPn32(cond1List(binCount),1:32,-100,primeOrTar,0);
    data2 = getERPn32(cond2List(binCount),1:32,-100,primeOrTar,0);
    cData = data2-data1;   
    
    cDataGA = mean(cData,3);
    cDataAll(:,:,binCount) = cDataGA;
end
size(cDataAll)
data = cDataAll;


data = data .* 100;  %%%data is originally in microVolts; multiply by 100
data = round(data);

[~,nSamp,nBin] = size(data);

for x = 1:nBin
    
    
    if nSamp < 256
        data(:,nSamp+1:256,x) = 0;
    end


    if x < 2
        dlmwrite(outFile, data(:,:,x), 'delimiter',' ','newline','pc');
    else
        dlmwrite(outFile, data(:,:,x), '-append', 'delimiter',' ', 'newline', 'pc');
    end
    
end

