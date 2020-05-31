***PyTorch implementation of "Spatial-Angular Interaction for Light Field Image Super-Resolution". arXiv 2019. [<a href="https://arxiv.org/pdf/1912.07849v2.pdf">PDF</a>]*** <br>

## Overview
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Network.jpg" width="600"><br>
#### Fig. 1: An overview of our LF-InterNet

<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/SFEAFE.jpg" width="400"><br>
#### Fig. 2: An illustration of angular feature extractor (AFE) and spatial feature extractor (SFE).

## Requirement
* pytorch (0.4), torchvision (0.2) (Note: The code is tested with python=3.6, cuda=9.0)
* Matlab (For training/test data generation and evaluation)

## Train
Training codes will be released soon.

## Test
* Download the test sets (<a href="https://yingqianwang.github.io/homepage/">data.zip</a>) used in our paper, and unzip them to `./data`. 
* Download our pretrained models (<a href="https://yingqianwang.github.io/homepage/">log.zip</a>) and unzip them to `./log`.
* Run `GenerateDataForTest.m` to generate test data.
* Run `test.py` to perform a demo inference. Note that, the selected pretrained model should match the generated input data ahd the preset network architecture. Initial results (`.mat` files) will be saved to `./results`.
* Run `evaluation.m` to calculate PSNR and SSIM scores, and transform initial results (`.mat` files) to `.png` images.

## Quantitative Results
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Quantitative.jpg" width="800"><br>
<br>
## Qualitative Results
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Qualitative.jpg" width="800"><br>

## Efficiency
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Efficiency.jpg" width="800"><br>

## Performance w.r.t. Perspectives
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/PwrtP.jpg" width="800"><br>

## Performance Under Real-World Degradation
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/VisualReal.jpg" width="800"><br>

## Citiation
***If you find this work helpful, please cite:*** <br><br>
@article{LF-InterNet,<br>
  title={Spatial-Angular Interaction for Light Field Image Super-Resolution},<br>
  author={Wang, Yingqian and Wang, Longguang and Yang, Jungang and An, Wei and Yu, Jingyi and Guo, Yulan},<br>
  journal={arXiv preprint arXiv:1912.07849},<br>
  year={2019}<br>
}<br>

