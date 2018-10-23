clear all
close all
clc

addpath(fullfile(pwd,'MATLAB'))

filePath    = fullfile(pwd,'AZFP_exports','mat');
resultPath  = fullfile(pwd,'results');

fileMat = dir(filePath);
fileMat = fileMat([fileMat.isdir] == false);

processingType = [  {'RAW'} ...
                    {'70thresh'} ...
                    {'63thresh'} ...
                    {'70mask'} ...
                    {'63mask'}];

dataSet = [         {'Bellwind'} ...
                    {'C-Power'}];
                
dataLocation = [    {'inpark'} ...
                    {'outpark'}];
                
%% plot parameters
plotIndPlot     = true;
plotCompProc    = false;
plotCompLoc     = false;
plotCompDataSet = false;


resolution = '-r300';
                
% preparing string for x axis labeling
time_label = [  2018 07 15 00 00 00; ...
                2018 07 20 00 00 00; ...
                2018 07 25 00 00 00; ...
                2018 07 30 00 00 00; ...
                2018 08 05 00 00 00; ...
                2018 08 15 00 00 00; ...
                2018 08 20 00 00 00; ...
                2018 08 25 00 00 00; ...
                2018 08 30 00 00 00; ...
                2018 09 05 00 00 00; ...
                2018 09 10 00 00 00; ...
                2018 09 15 00 00 00; ...
                2018 09 20 00 00 00; ...
                2018 09 25 00 00 00; ...
                2018 09 30 00 00 00];

%% main routine
outStruct       = struct();
count           = 1;
for idxDataSet = 1:length(dataSet)
    for idxDataLoc = 1:length(dataLocation)
        legendStringCompProc = [];
        for idxProc = 1:length(processingType)
            load(fullfile(  filePath, ...
                            char(strcat(    dataSet(idxDataSet), ...
                                            '_', ...
                                            dataLocation(idxDataLoc), ...
                                            '_', ...
                                            processingType(idxProc)))))

            
            dateMat = [];
            for idxInt = 1:size(acousticTab,1)
                time            = split(char(acousticTab.Time_M(idxInt)),':');
                hour            = str2double(time(1));
                minute          = str2double(time(2));
                sec             = str2double(time(3));
                dateStr         = num2str(acousticTab.Date_M(idxInt));
                year            = str2double(dateStr(1:4));
                month           = str2double(dateStr(5:6));
                day             = str2double(dateStr(7:8));
                dateMat(idxInt) = datenum([year month day hour minute sec]);
            end
            [~,I] = sort(dateMat);
            dateMat = dateMat(I);
            acousticTab = acousticTab(I,:);
            dt = 10*60;
            fs = 1/dt;
            [pxx,f] = pwelch(medfilt1(acousticTab.NASC,6), hanning(2048), [],[], fs);
            
            % gather everything in 1 structure
            outStruct(count).NASC     = acousticTab.NASC;
            outStruct(count).dateMat  = dateMat;
            outStruct(count).pxx      = pxx;
            outStruct(count).f        = f;
            outStruct(count).proc     = processingType(idxProc);
            outStruct(count).loc      = dataLocation(idxDataLoc);
            outStruct(count).dataSet  = dataSet(idxDataSet);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % plot time series and spectra
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if plotIndPlot
                mk_IndPlot( time_label, ...
                            outStruct(count), ...
                            resolution, ...
                            resultPath)
            end
            
            count = count + 1;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % comparing spectra and filtered time series for different
        % processings
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if plotCompProc
            mk_plotCompProc(    time_label, ...
                                outStruct(  strcmp([outStruct.loc],dataLocation(idxDataLoc)) & ...
                                            strcmp([outStruct.dataSet],dataSet(idxDataSet))), ...
                                resolution, ...
                                resultPath)
        end
        
    end
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compare in/out locations for each processing at a given site
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if plotCompLoc
        mk_plotCompLoc( time_label, ...
                        outStruct(strcmp([outStruct.dataSet],dataSet(idxDataSet))), ...
                        resolution, ...
                        resultPath)
    end
end

if plotCompDataSet
    mk_plotCompDataSet(time_label, ...
                        outStruct, ...
                        resolution, ...
                        resultPath)
end