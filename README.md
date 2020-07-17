#### PyTorch implementation of "Spatial-Angular Interaction for Light Field Image Super-Resolution", *ECCV 2020*. [<a href="https://arxiv.org/pdf/1912.07849.pdf">arXiv</a>]



## Overview
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Network.jpg" width="800"><br>
#### Fig. 1: An overview of our LF-InterNet.

<br><br><img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/SFEAFE.jpg" width="600"><br>
#### Fig. 2: An illustration of angular feature extractor (AFE) and spatial feature extractor (SFE).<br><br>

## Requirement
* **PyTorch 1.3.0, torchvision 0.4.1. The code is tested with python=3.7, cuda=9.0.**
* **Matlab (For training/test data generation and performance evaluation)**

## Train

* **Download the train datasets from Baidu Drive (will be released soon) and unzip them to `./Datasets`.** 
* **Run `GenerateTrainingData.m` to generate training data.**
* **Run `train.py` to perform network training. Note that, the training settings in `train.py` should match the generated training data. Checkpoint models will be saved to `./log`.**


## Citiation
**If you find this work helpful, please consider citing the following paper:**
```
@InProceedings{LF-InterNet,
  author    = {Wang, Yingqian and Wang, Longguang and Yang, Jungang and An, Wei and Yu, Jingyi and Guo, Yulan},
  title     = {Spatial-Angular Interaction for Light Field Image Super-Resolution},
  booktitle = {European Conference on Computer Vision (ECCV)},
  year      = {2020},
}
```

## Contact
**Any question regarding this work can be addressed to wangyingqian16@nudt.edu.cn.**
