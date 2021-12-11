#### Training codes of our [ECCV 2020](https://arxiv.org/pdf/1912.07849.pdf) paper: "Spatial-Angular Interaction for Light Field Image Super-Resolution".

## News:
* **2021-12-11**: We recommend our newly-released repository [BasicLFSR](https://github.com/ZhengyuLiang24/BasicLFSR) for the implementation of our LF-InterNet. [BasicLFSR](https://github.com/ZhengyuLiang24/BasicLFSR) is an open-source and easy-to-use toolbox for LF image SR. The codes of several milestone methods (e.g., LFSSR, LF-ATO, LF-InterNet, LF-DFnet) have been implemented (retrained) in a unified framework in [BasicLFSR](https://github.com/ZhengyuLiang24/BasicLFSR).

## Requirement
* **PyTorch 1.3.0, torchvision 0.4.1. The code is tested with python=3.7, cuda=9.0.**
* **Matlab (For training data generation)**

## Train
* **Download the train datasets via [Baidu Drive](https://pan.baidu.com/s/1pfpCkqdvXsS7KnQmpwt6_Q) (Key: NUDT) and unzip them to `./Datasets`.** 
* **Run `GenerateTrainingData.m` to generate training data.**
* **Run `train.py` to perform network training. Note that, the training settings in `train.py` should match the generated training data. Checkpoint models will be saved to `./log`.**


## Citiation
**If you find this work helpful, please consider citing the following paper:**
```
@InProceedings{LF-InterNet,
  author    = {Wang, Yingqian and Wang, Longguang and Yang, Jungang and An, Wei and Yu, Jingyi and Guo, Yulan},
  title     = {Spatial-Angular Interaction for Light Field Image Super-Resolution},
  booktitle = {European Conference on Computer Vision (ECCV)},
  pages     = {290-308},
  year      = {2020},
}
```

## Contact
**Any question regarding this work can be addressed to wangyingqian16@nudt.edu.cn.**
