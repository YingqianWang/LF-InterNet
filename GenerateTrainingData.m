%% Initialization
clear all;
clc;

%% Parameters setting
angRes = 5;             % Angular Resolution, options, e.g., 3, 5, 7, 9. Default: 5
patchsize = 64;         % Spatial resolution of each SAI patch, default: 64
stride = 32;            % stride between two patches, default: 32
factor = 4;             % SR factor
downRatio = 1/factor;
sourceDataPath = './Datasets/';
sourceDatasets = dir(sourceDataPath);
sourceDatasets(1:2) = [];
datasetsNum = length(sourceDatasets);
idx = 0;

SavePath = ['./TrainingData_', num2str(angRes), 'x', num2str(angRes), '_', num2str(factor), 'xSR/'];
if exist(SavePath, 'dir')==0
    mkdir(SavePath);
end

%% Training data generation
for DatasetIndex = 1 : datasetsNum
    sourceDataFolder = [sourceDataPath, sourceDatasets(DatasetIndex).name, '/training/'];
    folders = dir(sourceDataFolder);
    folders(1:2) = [];
    sceneNum = length(folders);
    
    for iScene = 1 : sceneNum
        idx_s = 0;
        sceneName = folders(iScene).name;
        sceneName(end-3:end) = [];
        fprintf('Generating training data of Scene_%s in Dataset %s......\t\t', sceneName, sourceDatasets(DatasetIndex).name);
        dataPath = [sourceDataFolder, folders(iScene).name];
        data = load(dataPath);
        
        LF = data.LF;
        [U, V, ~, ~, ~] = size(LF);
        LF = LF(0.5*(U-angRes+2):0.5*(U+angRes), 0.5*(V-angRes+2):0.5*(V+angRes), :, :, 1:3); % Extract central angRes*angRes views
        [U, V, H, W, ~] = size(LF);
        
        for h = 1 : stride : H - patchsize + 1
            for w = 1 : stride : W - patchsize + 1
                
                idx = idx + 1;
                idx_s = idx_s + 1;
                label = single(zeros(U * patchsize, V * patchsize));
                data = single(zeros(U * patchsize * downRatio, V * patchsize * downRatio));
                
                for u = 1 : U
                    for v = 1 : V                        
                        tempHR = squeeze(LF(u, v, h : h+patchsize-1, w : w+patchsize-1, :));
                        tempHR = rgb2ycbcr(tempHR);
                        tempHRy = squeeze(tempHR(:,:,1));
                        x = (u-1) * patchsize + 1;
                        y = (v-1) * patchsize + 1;
                        label(x:x+patchsize-1, y:y+patchsize-1) = tempHRy;
                        tempLRy = imresize(tempHRy, downRatio);
                        data(u : angRes : end, v : angRes : end) = tempLRy;
                    end
                end 
                
                SavePath_H5 = [SavePath, num2str(idx,'%06d'),'.h5'];
                h5create(SavePath_H5, '/data', size(data), 'Datatype', 'single');
                h5write(SavePath_H5, '/data', single(data), [1,1], size(data));
                h5create(SavePath_H5, '/label', size(label), 'Datatype', 'single');
                h5write(SavePath_H5, '/label', single(label), [1,1], size(label));
                
            end
        end
        fprintf([num2str(idx_s), ' training samples have been generated\n']);
    end
end

