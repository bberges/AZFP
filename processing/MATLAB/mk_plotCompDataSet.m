function mk_plotCompDataSet(time_label,outStruct,resolution,resultPath)

procStr = unique([outStruct.proc]);

myLineStyle = {'-',':','-.'};
myLineColor = {     [1 0 0] ...
                    [0 0 1] ...
                    [0 1 0]};
myLineWidth = [0.5,2,2];

for idxProc = 1:length(procStr)
    outStructTemp = outStruct(strcmp([outStruct.proc],procStr(idxProc)));
    dataSetStr = unique([outStructTemp.dataSet]);
    
    title_name = strcat(unique([outStructTemp.proc]));
    legendStr = {};
    figure
    for idxDataSet = 1:length(dataSetStr)
        outStructTemp2 = outStructTemp(strcmp([outStructTemp.dataSet],dataSetStr(idxDataSet)));
        for idxLoc = 1:length(outStructTemp2)
            hold on
            subplot(2,1,1)
            semilogy(   outStructTemp2(idxLoc).dateMat, ...
                        smooth(outStructTemp2(idxLoc).NASC,6*24), ...
                        'linestyle', char(myLineStyle(idxDataSet)), ...
                        'color', cell2mat(myLineColor(idxLoc)), ...
                        'lineWidth', myLineWidth(idxDataSet))
%             xlim([min(outStructTemp2(idxLoc).dateMat) max(outStructTemp2(idxLoc).dateMat)])
            time_str = datestr(time_label(1:2:end,:), 'mm/dd/yy');
            set(gca, 'xtick', datenum(time_label(1:2:end,:)), 'xticklabel', time_str)
            set(gca, 'XGrid', 'on', 'Units','pixels');
            xlabel('time (days)')
            ylabel('Sa')

            hold on
            subplot(2,1,2)
            plot(   outStructTemp2(idxLoc).f*60*60*24, ...
                    10*log10(outStructTemp2(idxLoc).pxx), ...
                    'linestyle', char(myLineStyle(idxDataSet)), ...
                    'color', cell2mat(myLineColor(idxLoc)), ...
                    'lineWidth', myLineWidth(idxDataSet))
            xlabel('Frequency (cycles/day)')
            ylabel('PSD (dB re 1 m^{2}/m^{-2})')
            xlim([0 10])
            ylim([50 100])
            legendStr = [legendStr strcat(outStructTemp2(idxLoc).dataSet,'_', outStructTemp2(idxLoc).loc)];
        end
    end
    legend(legendStr,'location','best','interpreter','none')
    
    % saving
    savefigpdf(char(fullfile(   resultPath, ...
                                title_name)))

    print('-djpeg',resolution,'-painters',char(fullfile(    resultPath, ...
                                                            title_name)))

    close all
end