import os
from torch.utils.data.dataset import Dataset
from torchvision.transforms import ToTensor
import random
import numpy as np
import h5py


class TrainSetLoader(Dataset):
    def __init__(self, dataset_dir):
        super(TrainSetLoader, self).__init__()
        self.dataset_dir = dataset_dir
        file_list = os.listdir(dataset_dir)
        item_num = len(file_list)
        self.item_num = item_num

    def __getitem__(self, index):
        dataset_dir = self.dataset_dir
        index = index + 1
        file_name = [dataset_dir + '/%06d' % index + '.h5']
        with h5py.File(file_name[0], 'r') as hf:
            data = np.array(hf.get('data'))
            data = np.transpose(data, (1, 0))
            label = np.array(hf.get('label'))
            label = np.transpose(label, (1, 0))
            data, label = augmentation(data.copy(), label.copy())
        return ToTensor()(data.copy()), ToTensor()(label.copy())

    def __len__(self):
        return self.item_num


def augmentation(data, label):
    if random.random() < 0.5:
        data = data[:, ::-1]
        label = label[:, ::-1]
    if random.random() < 0.5:
        data = data[::-1, :]
        label = label[::-1, :]
    if random.random() < 0.5:
        data = data.transpose(1, 0)
        label = label.transpose(1, 0)
    return data, label


def read_training_data(file):
    with h5py.File(file, 'r') as hf:
        data_hz = np.array(hf.get('data_hz'))
        data_vt = np.array(hf.get('data_vt'))
        data_rf = np.array(hf.get('data_rf'))
        label = np.array(hf.get('label'))
        return data_hz, data_vt, data_rf, label

