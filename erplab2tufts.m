function erplab2tufts(condList,primeOrTar,outFile)

%%this extracts lp 20 hz filtered erps

filePath = strcat('/Users/ellen/Documents/Experiments/BALEEN/BALEEN_ERP/erplab_analysis/tufts_format/');
outFile = strcat(filePath,outFile)

cDataAll = [];

binCount = 0;
for c = condList
    binCount = binCount + 1;
    cData = getERPn32(c,1:32,-100,primeOrTar,1);
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