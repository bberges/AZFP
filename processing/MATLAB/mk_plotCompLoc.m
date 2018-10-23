function mk_plotCompLoc(time_label,outStruct,resolution,resultPath)

procStr = unique([outStruct.proc]);

savePath = fullfile(    resultPath, ...
                        unique([outStruct.dataSet]));

for idxProc = 1:length(procStr)
    outStructTemp = outStruct(strcmp([outStruct.proc],procStr(idxProc)));
    
    title_name = strcat(    unique([outStructTemp.dataSet]), ...
                            '_', ...
                            unique([outStructTemp.proc]));
    figure
    for k = 1:length(outStructTemp)
        hold on
        subplot(2,1,1)
        semilogy(outStructTemp(k).dateMat, smooth(outStructTemp(k).NASC,6*24))
        xlim([min(outStruct(k).dateMat) max(outStruct(k).dateMat)])
        time_str = datestr(time_label, 'mm/dd/yy');
        set(gca, 'xtick', datenum(time_label), 'xticklabel', time_str)
        set(gca, 'XGrid', 'on', 'Units','pixels');
        xlabel('time (days)')
        ylabel('Sa')

        hold on
        subplot(2,1,2)
        plot(outStructTemp(k).f*60*60*24, 10*log10(outStructTemp(k).pxx))
        xlabel('Frequency (cycles/day)')
        ylabel('PSD (dB re 1 m^{2}/m^{-2})')
        xlim([0 10])
        ylim([50 100])
    end
    subplot(2,1,1)
    title(title_name,'interpreter','none')

    legend([outStructTemp.loc],'location', 'best')
    
    % saving
    savefigpdf(char(fullfile(   savePath, ...
                                title_name)))

    print('-djpeg',resolution,'-painters',char(fullfile(    savePath, ...
                                                            title_name)))

    close all
end
