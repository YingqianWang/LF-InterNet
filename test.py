import torch
import os
import scipy.io
from model import InterNet
import numpy as np
import scipy.misc
import h5py
from torch.autograd import Variable
import torch.backends.cudnn as cudnn


def main():

    dir_images = './input/'
    dir_save_path = './Results/'
    net = InterNet(angRes=5, n_blocks=4, n_layers=4, channels=64, upscale_factor=2)
    cudnn.benchmark = True
    model = torch.load('./log/InterNet_5x5_2xSR_C64.pth.tar', map_location={'cuda:1':'cpu'})
    net.load_state_dict(model['state_dict'])


    for root, dirs, files in os.walk(dir_images):
        if len(files) == 0:
            break
        for file_name in files:
            file_path = [dir_images + file_name]
            with h5py.File(file_path[0], 'r') as hf:
                data = np.array(hf.get('data'))
                data = np.transpose(data, (1, 0))
                data = np.expand_dims(data, axis=0)
                data = np.expand_dims(data, axis=0)
                data = torch.from_numpy(data.copy())
                data = Variable(data)

            with torch.no_grad():
                out = net(data)

            out = out.numpy()
            scipy.io.savemat(dir_save_path + file_name[0:-3] + '.mat', {'LF': out})

if __name__ == '__main__':
    main()