%% Initialization
clear all;
clc;

%% Parameters setting
angResData = 9;  % The angular resolution of LFs in ./data
angRes = 5;  % Angular resolution of generated test data
factor = 2;  % downsampling factor
datasetFolder = './data/';
savePath = './input/';
if exist(savePath, 'dir')
    delete([savePath, '*.h5']);
else
    mkdir(savePath);
end

datasets = dir(datasetFolder);
datasets(1:2) = [];
datasetsNum = length(datasets);

for idxDataset = 1 : datasetsNum
    datasetName = datasets(idxDataset).name;
    fprintf('Generating test data of %s......\n', datasetName);
    scenePath = [datasetFolder, datasetName, '/'];
    scenes = dir([scenePath, '*.png']);   % list the scenes
    
    sceneNum = length(scenes);
    img = imread([scenePath, scenes(1).name]);
    [H, W, ~] = size(img);
    LF0 = zeros(angResData, angResData, H, W, 3);
    
    for u = 1 : angResData
        for v = 1 : angResData
            iScene = (u-1)*angResData + v;
            img = imread([scenePath, scenes(iScene).name]);
            LF0(u, v, :, :, :) = im2double(img);
        end
    end
    
    LF = LF0(0.5*(angResData-angRes+2):0.5*(angResData+angRes),...
        0.5*(angResData-angRes+2):0.5*(angResData+angRes), :, :, :);
    macroLF = single(zeros(angRes*H/factor, angRes*W/factor));
    
    for u = 1 : angRes
        for v = 1 : angRes
            SAI_rgb = imresize(squeeze(LF(u, v, :, :, :)), 1/factor);
            SAI_ycbcr = rgb2ycbcr(SAI_rgb);
            macroLF(u:angRes:end, v:angRes:end) = SAI_ycbcr(:, :, 1);
        end
    end
    
    data = macroLF;
    SavePath_H5 = [savePath, datasetName, '.h5'];
    h5create(SavePath_H5, '/data', size(data), 'Datatype', 'single');
    h5write(SavePath_H5, '/data', single(data), [1,1], size(data));
    h5create(SavePath_H5, '/LFgt', size(LF), 'Datatype', 'single');
    h5write(SavePath_H5, '/LFgt', single(LF), [1,1,1,1,1], size(LF));
end



