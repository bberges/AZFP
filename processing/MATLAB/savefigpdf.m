function savefig(filename)

iResolution = 500;

set(gcf, 'Units', 'centimeters');
set(gcf, 'PaperOrientation', 'portrait ');
% we set the position and dimension of the figure ON THE SCREEN
%
% NOTE: measurement units refer to the previous settings!
afFigurePosition = [1 1 14 11]; % [pos_x pos_y width_x width_y]
set(gcf, 'Position', afFigurePosition); % [left bottom width height]

save2pdf(strcat(filename,'.pdf'),gcf,iResolution)

