**PyTorch implementation of "Spatial-Angular Interaction for Light Field Image Super-Resolution", *arXiv 2019*. [<a href="https://arxiv.org/pdf/1912.07849v2.pdf">PDF</a>]** <br>

## Overview
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Network.jpg" width="800"><br>
#### Fig. 1: An overview of our LF-InterNet.

<br><br><img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/SFEAFE.jpg" width="600"><br>
#### Fig. 2: An illustration of angular feature extractor (AFE) and spatial feature extractor (SFE).<br><br>

## Requirement
* **PyTorch 1.3.0, torchvision 0.4.1. The code is tested with python=3.7, cuda=9.0.**
* **Matlab (For training/test data generation and performance evaluation)**

## Train
Training codes will be released soon.

## Test
* **Download the test sets and unzip them to `./data`. Here, we provide a demo test set (<a href="https://wyqdatabase.s3-us-west-1.amazonaws.com/data_demo.zip">data_demo.zip</a>) which only includes one test scene, and we also provide the full test set (<a href="https://wyqdatabase.s3-us-west-1.amazonaws.com/data.zip">data.zip</a>) which is used in our paper.** 
* **Download our pretrained models (<a href="https://wyqdatabase.s3-us-west-1.amazonaws.com/log.zip">log.zip</a>) and unzip them to `./log`.**
* **Run `GenerateDataForTest.m` to generate test data.**
* **Run `test.py` to perform a demo inference. Note that, the selected pretrained model should match the generated input data and the preset network architecture. Initial results (`.mat` files) will be saved to `./results`.**
* **Run `evaluation.m` to calculate PSNR and SSIM scores and transform initial results (`.mat` files) into `.png` images.**

## Quantitative Results
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Quantitative.jpg" width="1000"><br>
<br>
## Qualitative Results
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Qualitative.jpg" width="1000"><br>

## Efficiency
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/Efficiency.jpg" width="1000"><br>

## Performance w.r.t. Perspectives
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/PwrtP.jpg" width="1000"><br>

## Performance Under Real-World Degradation
<img src="https://raw.github.com/YingqianWang/LF-InterNet/master/Figs/VisualReal.jpg" width="1000"><br>

## Citiation
**If you find this work helpful, please consider to cite the following paper:**
```
@article{LF-InterNet,
  title={Spatial-Angular Interaction for Light Field Image Super-Resolution},
  author={Wang, Yingqian and Wang, Longguang and Yang, Jungang and An, Wei and Yu, Jingyi and Guo, Yulan},
  journal={arXiv preprint arXiv:1912.07849},
  year={2019}
}
```

## Contact
**Any question regarding this work can be addressed to wangyingqian16@nudt.edu.cn.**
