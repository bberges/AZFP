clear all
close all
clc

filePath = fullfile(pwd,'AZFP_exports');

fileMat = dir(filePath);
fileMat = fileMat([fileMat.isdir] == false);

for k = 1:length(fileMat)
    acousticTab = readtable(fullfile(filePath,fileMat(k).name));
    save(fullfile(filePath,'mat',fileMat(k).name(1:end-4)),'acousticTab')
end