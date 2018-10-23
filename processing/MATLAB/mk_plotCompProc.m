function mk_plotCompProc(time_label,outStruct,resolution,resultPath)

title_name = strcat(    unique([outStruct.dataSet]), ...
                        '_', ...
                        unique([outStruct.loc]));
                
savePath = fullfile(    resultPath, ...
                        unique([outStruct.dataSet]), ...
                        unique([outStruct.loc]));

figure
for k = 1:length(outStruct)
    hold on
    subplot(2,1,1)
    semilogy(outStruct(k).dateMat, smooth(outStruct(k).NASC,6*24))
    xlim([min(outStruct(k).dateMat) max(outStruct(k).dateMat)])
    time_str = datestr(time_label, 'mm/dd/yy');
    set(gca, 'xtick', datenum(time_label), 'xticklabel', time_str)
    set(gca, 'XGrid', 'on', 'Units','pixels');
    xlabel('time (days)')
    ylabel('Sa')

    hold on
    subplot(2,1,2)
    plot(outStruct(k).f*60*60*24, 10*log10(outStruct(k).pxx))
    xlabel('Frequency (cycles/day)')
    ylabel('PSD (dB re 1 m^{2}/m^{-2})')
    xlim([0 10])
    ylim([50 100])
end

subplot(2,1,1)
title(title_name,'interpreter','none')

legend([outStruct.proc],'location', 'best')
            
% saving
savefigpdf(char(fullfile(   savePath, ...
                            title_name)))

print('-djpeg',resolution,'-painters',char(fullfile(    savePath, ...
                                                        title_name)))
                                                    
close all