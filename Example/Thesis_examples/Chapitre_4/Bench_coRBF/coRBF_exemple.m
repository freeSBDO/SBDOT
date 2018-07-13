%%% Build a mutlifidelity metamodel from two different numerical models
%%% (high fidelity and low fidelity)
%%% Here the surrogate is CoRBF

clear all
close all
clc

save_plot = true;
s = hgexport('readstyle','manuscrit');
s.Format = 'png';

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraint
lb = 0;  % Lower bound 
ub = 1;  % Upper bound 

% Create HF and LF Problem object with optionnal parallel input as true
prob_HF=Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_LF=Problem('Multifi_1D_LF',m_x,m_y,m_g,lb,ub,'parallel',true);

% Create Multifidelity Problem object
prob=Problem_multifi(prob_LF,prob_HF);

% Evaluate the models at specified location
prob.Eval ([0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],'LF');
prob.Eval ([0;0.4;0.6;1],'HF');

% Create Cokriging
corbf1 = CoRBF(prob,1,[]);

% Figure
x_test = linspace(0,1,200)';% x plot points
y_test = Multifi_1D_HF(x_test);

% Predict values and errors of coRBF
[ pred1, power1] = corbf1.Predict(x_test);

% Predict values and errors of low fidelity and difference model
mean_LF = corbf1.RBF_c.Predict(x_test);
mean_diff = corbf1.RBF_d.Predict(x_test);

% Big plot
figure 
hold on 
plot( prob_HF.x, prob_HF.y, 'ko', 'MarkerFaceColor', 'k')
plot( x_test, pred1, 'k-')
plot( x_test, y_test, 'r--')
plot( prob_LF.x, prob_LF.y, 'bo', 'MarkerFaceColor', 'b')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''ees d''entrainement HF','Co-RBF','$\mathcal{M}$','Donn\''ees d''entrainement LF'},...
    'Interpreter','latex','Location','northwest')
hold off 
if save_plot
    hgexport(gcf,'coRBF_exemple',s);
end

%%%% Stop point line 44 of CoRBF training
[X1,X2]=meshgrid(linspace(-5,5,100),linspace(LBounds(2),UBounds(2),100));
X_plot = [reshape(X1,100*100,1) reshape(X2,100*100,1)];
for i=1:10000
    Y_plot(i,:) = obj.Obj_diff_opt( X_plot(i,:) , yc_e);
end
Y_plot = real(Y_plot);
X_optim = X_plot(Y_plot == min(Y_plot),:);
Z = reshape(Y_plot,100,100);

figure 
hold on 
contour(X1,X2,Z,[ 5 100 500 1e3 2e3 3e3],'ShowText','on','LineColor','k')
plot(X_optim(1),X_optim(2),'r*')
xlabel('$\rho_{LF}$','interpreter','latex')
ylabel('log($\theta$)','interpreter','latex')
box on
hold off 
if save_plot
    hgexport(gcf,'coRBF_LOO',s);
end


