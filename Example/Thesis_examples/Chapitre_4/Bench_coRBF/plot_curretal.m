clear all
close all
clc

% Load results
load cokrig_curretal_result.mat
mean_raae_cokrig(:,:) = mean(RAAE_curretal,3);
std_raae_cokrig(:,:) = std(RAAE_curretal,[],3);

load coRBF_curretal_result.mat
mean_raae_coRBF(:,:) = mean(RAAE_curretal,3);
std_raae_coRBF(:,:) = std(RAAE_curretal,[],3);

% Error figures
figure
imagesc([20 100],[5 40],mean_raae_cokrig)
axis xy
set(gca,'XTick',[20 30 40 50 60 70 80 90 100],'YTick',[5 10 15 20 25 30 35 40]);
colorbar('Limits',[0.006 0.25]);
caxis([0.006 0.25])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('co-krigeage','interpreter','latex')

figure
imagesc([20 100],[5 40],mean_raae_coRBF)
axis xy
set(gca,'XTick',[20 30 40 50 60 70 80 90 100],'YTick',[5 10 15 20 25 30 35 40]);
colorbar('Limits',[0.006 0.25]);
caxis([0.006 0.25])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('co-RBF','interpreter','latex')

figure
imagesc([20 100],[5 40],std_raae_cokrig)
axis xy
set(gca,'XTick',[20 30 40 50 60 70 80 90 100],'YTick',[5 10 15 20 25 30 35 40]);
colorbar('Limits',[5e-4 0.30]);
caxis([5e-4 0.30])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('co-krigeage','interpreter','latex')

figure
imagesc([20 100],[5 40],std_raae_coRBF)
axis xy
set(gca,'XTick',[20 30 40 50 60 70 80 90 100],'YTick',[5 10 15 20 25 30 35 40]);
colorbar('Limits',[5e-4 0.30]);
caxis([5e-4 0.30])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('co-RBF','interpreter','latex')