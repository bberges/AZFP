function mk_IndPlot(time_label,outStruct,resolution,resultPath)

NASC    = outStruct.NASC;
f       = outStruct.f;
pxx     = outStruct.pxx;
dateMat = outStruct.dateMat;

title_name = strcat(    outStruct.dataSet, ...
                        '_', ...
                        outStruct.loc, ...
                        '_', ...
                        outStruct.proc);
                
savePath = fullfile(    resultPath, ...
                        outStruct.dataSet, ...
                        outStruct.loc);
                    
figure
subplot(2,1,1)
semilogy(dateMat,NASC, dateMat, smooth(NASC,6*24))
legend('original','filtered')
xlim([min(dateMat) max(dateMat)])
time_str = datestr(time_label, 'mm/dd/yy');
set(gca, 'xtick', datenum(time_label), 'xticklabel', time_str)
set(gca, 'XGrid', 'on', 'Units','pixels');
xlabel('time (days)')
ylabel('Sa')
                
subplot(2,1,2)
plot(f*60*60*24, 10*log10(pxx))
xlabel('Frequency (cycles/day)')
ylabel('PSD (dB re 1 m^{2}/m^{-2})')
xlim([0 10])
ylim([50 100])

subplot(2,1,1)
title(title_name,'interpreter','none')

% saving
savefigpdf(char(fullfile(   savePath, ...
                            title_name)))

print('-djpeg',resolution,'-painters',char(fullfile(    savePath, ...
                                                        title_name)))

close all