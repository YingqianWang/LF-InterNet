clear all;
clc;
close all;

angRes = 5; % Angular resolution of LFs in ./results and ./input
factor = 2; % upscaling factor
resultsFolder = './results/';
inputFolder = './input/';
savePath = './SRimages/'; % Super-resolved LF images (.png) will be saved here 

scenes = dir(resultsFolder);
scenes(1:2) = [];
sceneNum = length(scenes);
inputs = dir(inputFolder);
inputs(1:2) = [];

for idxScene = 1 : sceneNum
    sceneName = scenes(idxScene).name;
    sceneName(end-3:end) = [];
    data = load([resultsFolder, scenes(idxScene).name]);
    LFgt = h5read([inputFolder, inputs(idxScene).name], '/LFgt');
    [angRes, ~, H, W, ~] = size(LFgt);    
    LFsr = zeros(size(LFgt));
    
    for u = 1 : angRes
        for v = 1 : angRes
            imgHR_rgb = squeeze(LFgt(u, v, :, :, :));
            imgLR_rgb = imresize(imgHR_rgb, 1/factor);
            imgLR_ycbcr = rgb2ycbcr(imgLR_rgb);
            imgSR_ycbcr = imresize(imgLR_ycbcr, factor);
            imgSR_ycbcr(:,:,1) = data.LF(1,1,(u-1)*H+1:u*H, (v-1)*W+1:v*W);
            imgSR_rgb = ycbcr2rgb(imgSR_ycbcr);
            LFsr(u, v, :, :, :) = imgSR_rgb;
            
            if exist([savePath, sceneName], 'dir')==0
                mkdir([savePath, sceneName]);
            end
            imwrite(uint8(255*imgSR_rgb), [savePath, sceneName, '/',...
                num2str(u,'%02d'), '_', num2str(v,'%02d'), '.png' ]);

        end
    end
    % Calculate PSNR and SSIM values of each view
    boundary = 0; % Crop image boundaries for evaluation
    [PSNR, SSIM] = cal_metrics(LFgt, LFsr, boundary);  
    % Maximum, average, and minimum scores are reported
    fprintf([sceneName, ': maxPSNR=%.2f; avgPSNR=%.2f; minPSNR=%.2f; ' ...
        'maxSSIM=%.3f; avgSSIM=%.3f; minSSIM=%.3f; \n'],...
            max(PSNR(:)), mean(PSNR(:)), min(PSNR(:)),...
            max(SSIM(:)), mean(SSIM(:)), min(SSIM(:)));        
end

%% Functions
function [PSNR, SSIM] = cal_metrics(LF, LFout, boundary)
[U, V, H, W, ~] = size(LF);
PSNR = zeros(U, V);
SSIM = zeros(U, V);
for u = 1 : U
    for v = 1 : V
        Ir = squeeze(LFout(u, v, boundary+1:end-boundary, boundary+1:end-boundary, :));
        Is = squeeze(LF(u, v, boundary+1:end-boundary, boundary+1:end-boundary, :));
        Ir_ycbcr = rgb2ycbcr(Ir);
        Ir_y = Ir_ycbcr(:,:,1);
        Is_ycbcr = rgb2ycbcr(Is);
        Is_y = Is_ycbcr(:,:,1);
        temp = (Ir_y-Is_y).^2;
        mse = sum(temp(:))/(H*W);
        PSNR(u,v) = 10*log10(1/mse);
        SSIM(u,v) = cal_ssim(Ir_y, Is_y, 0, 0);
    end
end
end

function ssim = cal_ssim( im1, im2, b_row, b_col)

[h, w, ch] = size( im1 );
ssim = 0;
if (ch == 1)
    ssim = ssim_index ( im1(b_row+1:h-b_row, b_col+1:w-b_col), im2(b_row+1:h-b_row,b_col+1:w-b_col));
else
    for i = 1:ch
        ssim = ssim + ssim_index ( im1(b_row+1:h-b_row, b_col+1:w-b_col, i), im2(b_row+1:h-b_row,b_col+1:w-b_col, i));
    end
    ssim = ssim/3;
end
end

function [mssim, ssim_map] = ssim_index(img1, img2, K, window, L)

if (nargin < 2 || nargin > 5)
    mssim = -Inf;
    ssim_map = -Inf;
    return;
end

if (size(img1) ~= size(img2))
    mssim = -Inf;
    ssim_map = -Inf;
    return;
end

[M N] = size(img1);

if (nargin == 2)
    if ((M < 11) || (N < 11))
        mssim = -Inf;
        ssim_map = -Inf;
        return
    end
    window = fspecial('gaussian', 11, 1.5);	%
    K(1) = 0.01;					% default settings
    K(2) = 0.03;					%
    L = 2;                                     %
end

img1 = double(img1);
img2 = double(img2);

C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
window = window/sum(sum(window));

mu1   = filter2(window, img1, 'valid');
mu2   = filter2(window, img2, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(window, img1.*img1, 'valid') - mu1_sq;
sigma2_sq = filter2(window, img2.*img2, 'valid') - mu2_sq;
sigma12 = filter2(window, img1.*img2, 'valid') - mu1_mu2;

if (C1 > 0 && C2 > 0)
    ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
else
    numerator1 = 2*mu1_mu2 + C1;
    numerator2 = 2*sigma12 + C2;
    denominator1 = mu1_sq + mu2_sq + C1;
    denominator2 = sigma1_sq + sigma2_sq + C2;
    ssim_map = ones(size(mu1));
    index = (denominator1.*denominator2 > 0);
    ssim_map(index) = (numerator1(index).*numerator2(index))./(denominator1(index).*denominator2(index));
    index = (denominator1 ~= 0) & (denominator2 == 0);
    ssim_map(index) = numerator1(index)./denominator1(index);
end

mssim = mean2(ssim_map);

end

