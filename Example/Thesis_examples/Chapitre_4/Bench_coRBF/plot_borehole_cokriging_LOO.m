clear all
close all
clc

% Load results
load cokrig_borehole_result_LOO.mat
mean_raae_cokrig(:,:) = mean(RAAE_borehole,3);
std_raae_cokrig(:,:) = std(RAAE_borehole,[],3);

% Error figures
figure
imagesc([40 240],[10 130],mean_raae_cokrig)
axis xy
set(gca,'XTick',[40 80 120 160 200 240],'YTick',[10 30 50 70 90 110 130]);
colorbar
%colorbar('Limits',[0.002 1]);
%caxis([0.002 1])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('Moyenne','interpreter','latex')

figure
imagesc([40 240],[10 130],std_raae_cokrig)
axis xy
set(gca,'XTick',[40 80 120 160 200 240],'YTick',[10 30 50 70 90 110 130]);
colorbar
%colorbar('Limits',[5e-4 0.30]);
%caxis([5e-4 0.30])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('Ecart type','interpreter','latex')


