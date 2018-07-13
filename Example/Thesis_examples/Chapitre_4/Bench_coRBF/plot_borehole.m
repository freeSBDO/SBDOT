clear all
close all
clc

% Load results
load cokrig_borehole_result.mat
mean_raae_cokrig(:,:) = mean(RAAE_borehole,3);
std_raae_cokrig(:,:) = std(RAAE_borehole,[],3);

load coRBF_borehole_result.mat
mean_raae_coRBF(:,:) = mean(RAAE_borehole,3);
std_raae_coRBF(:,:) = std(RAAE_borehole,[],3);

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
title('co-krigeage','interpreter','latex')

figure
imagesc([40 240],[10 130],mean_raae_coRBF)
axis xy
set(gca,'XTick',[40 80 120 160 200 240],'YTick',[10 30 50 70 90 110 130]);
colorbar
%colorbar('Limits',[0.002 1]);
%caxis([0.002 1])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('co-RBF','interpreter','latex')

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
title('co-krigeage','interpreter','latex')

figure
imagesc([40 240],[10 130],std_raae_coRBF)
axis xy
set(gca,'XTick',[40 80 120 160 200 240],'YTick',[10 30 50 70 90 110 130]);
colorbar
%colorbar('Limits',[5e-4 0.30]);
%caxis([5e-4 0.30])
colormap gray
xlabel('Nombre de points LF','interpreter','latex')
ylabel('Nombre de points HF','interpreter','latex')
title('co-RBF','interpreter','latex')

% Extract hyperparameters
for i = 1:7       
    
            for j = 1:6
                for l = 1:10
                    cell_temp = hyp_corbf_HF{i,j,l};
                    bobi_1(j,l) = cell_temp(1);
                    bobi_2(j,l) = cell_temp(2);
                    bobi_3(j,l) = cell_temp(3);                  
                end
            end          
            
            theta_1_HF_cokrig (i,:) = reshape(bobi_1,60,1);
            theta_2_HF_cokrig (i,:) = reshape(bobi_1,60,1);
            theta_3_HF_cokrig (i,:) = reshape(bobi_1,60,1);
            
            rho_cokrig_final(i,:) = reshape(rho_cokrig(i,:,:),60,1);
            
end

positions = [1.25 1.5 2 2.25 2.75 3 3.5 3.75];
group = [1,2,3,4,5,6,7];
name_legende = {'10','30','50','70','90','110','130'};

figure
hold on
boxplot(rho_cokrig_final',group,'Colors','rb')
%set(gca,'xtick',[1.375 2.125 2.875 3.625])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
%set(gca,'XTickLabelRotation', 45)
ylabel('$\rho_{LF}$','interpreter','latex')
xlabel('Nombre de points HF','interpreter','latex')
box_vars = findall(gca,'Tag','Box');
title('LOO','interpreter','latex')
hold off
