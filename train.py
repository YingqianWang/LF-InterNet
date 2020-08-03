import torch
import argparse
from model import InterNet
from torch.autograd import Variable
from torch.utils.data import DataLoader
import torch.backends.cudnn as cudnn
from utils import *
from math import log10

# Training settings
def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--device', type=str, default='cuda:0')
    parser.add_argument("--angRes", type=int, default=5, help="angular resolution")
    parser.add_argument("--n_groups", type=int, default=4, help="number of Inter-Groups")
    parser.add_argument("--n_blocks", type=int, default=4, help="number of Inter-Blocks")
    parser.add_argument("--upscale_factor", type=int, default=4, help="upscale factor")

    parser.add_argument('--batch_size', type=int, default=12)
    parser.add_argument('--lr', type=float, default=5e-4, help='initial learning rate')
    parser.add_argument('--n_epochs', type=int, default=40, help='number of epochs to train')
    parser.add_argument('--n_steps', type=int, default=10, help='number of epochs to update learning rate')
    parser.add_argument('--gamma', type=float, default=0.5, help='learning rate decaying factor')

    parser.add_argument('--trainset_dir', type=str, default='./TrainingData_5x5_4xSR')
    parser.add_argument('--model_name', type=str, default='LF-InterNet_5x5_4xSR')
    parser.add_argument('--load_pretrain', type=bool, default=False)
    parser.add_argument('--model_path', type=str, default='./log/LF-InterNet_5x5_4xSR.pth.tar')

    return parser.parse_args()


def train(train_loader, cfg):

    net = InterNet(angRes=5, n_groups=cfg.n_groups, n_blocks=cfg.n_blocks,
                   channels=64, upscale_factor=cfg.upscale_factor).to(cfg.device)
    net.apply(weights_init_xavier)
    cudnn.benchmark = True


    if cfg.load_pretrain:
        if os.path.isfile(cfg.model_path):
            model = torch.load(cfg.model_path, map_location={'cuda:0': cfg.device})
            net.load_state_dict(model['state_dict'])
            cfg.start_epoch = model["epoch"]
        else:
            print("=> no model found at '{}'".format(cfg.load_model))

    #net = torch.nn.DataParallel(net, device_ids=[0, 1])
    criterion_Loss = torch.nn.L1Loss().to(cfg.device)
    optimizer = torch.optim.Adam([paras for paras in net.parameters() if paras.requires_grad == True], lr=cfg.lr)
    scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=cfg.n_steps, gamma=cfg.gamma)
    psnr_epoch = []
    loss_epoch = []
    loss_list = []
    psnr_list = []

    for idx_epoch in range(cfg.n_epochs):


        for idx_iter, (data, label) in enumerate(train_loader):

            data, label = Variable(data).to(cfg.device), Variable(label).to(cfg.device)
            out = net(data)
            loss = criterion_Loss(out, label)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            psnr_epoch.append(cal_psnr(out.data.cpu(), label.data.cpu()))
            loss_epoch.append(loss.data.cpu())

        if idx_epoch % 1 == 0:
            loss_list.append(float(np.array(loss_epoch).mean()))
            psnr_list.append(float(np.array(psnr_epoch).mean()))
            print('Epoch----%5d, loss---%f, PSNR---%f' % (idx_epoch + 1, float(np.array(loss_epoch).mean()), float(np.array(psnr_epoch).mean())))

            save_ckpt({
                'epoch': idx_epoch + 1,
                'state_dict': net.state_dict(),
                'loss': loss_list,
                'psnr': psnr_list,
            }, save_path = './log/', filename='LF-InterNet_' + str(cfg.angRes) + 'x' + str(cfg.angRes) + '_' +
                                            str(cfg.upscale_factor) + 'xSR_epoch' + str(idx_epoch + 1) + '.pth.tar')
            psnr_epoch = []
            loss_epoch = []

        scheduler.step()


def cal_psnr(img1, img2):
    _, _, h, w = img1.size()
    mse = torch.sum((img1 - img2) ** 2) / img1.numel()
    psnr = 10 * log10(1/mse)
    return psnr


def save_ckpt(state, save_path='./log', filename='checkpoint.pth.tar'):
    torch.save(state, os.path.join(save_path,filename))


def weights_init_xavier(m):
    classname = m.__class__.__name__
    if classname.find('Conv2d') != -1:
        torch.nn.init.xavier_normal_(m.weight.data)


def main(cfg):
    train_set = TrainSetLoader(dataset_dir=cfg.trainset_dir)
    train_loader = DataLoader(dataset=train_set, num_workers=6, batch_size=cfg.batch_size, shuffle=True)
    train(train_loader, cfg)


if __name__ == '__main__':
    cfg = parse_args()
    main(cfg)
