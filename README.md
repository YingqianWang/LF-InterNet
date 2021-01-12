#### Training codes of "Spatial-Angular Interaction for Light Field Image Super-Resolution", *ECCV 2020*. [<a href="https://arxiv.org/pdf/1912.07849.pdf">PDF</a>] [<a href="https://wyqdatabase.s3-us-west-1.amazonaws.com/LF-InterNet.mp4">Presentation</a>]

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
  year      = {2020},
}
```

## Contact
**Any question regarding this work can be addressed to wangyingqian16@nudt.edu.cn.**
