clear all
close all
clc

% Analytical exemple
bobi=@(x)(5-0.7*exp(-(x-0.2).^2./0.04)-2*exp(-(x-0.5).^2./1)-exp(-(x-0.8).^2./0.01));

% Robustness measures
bobi_mean=@(x,a)( (1/(2*a)) *( (2*5*a) ...
    -0.7*( sqrt(pi)*sqrt(0.04)/2   ) * (erf((x+a-0.2)/sqrt(0.04))-erf((x-a-0.2)/sqrt(0.04)))...
    -2*  ( sqrt(pi)/2              ) * (erf((x+a-0.5)/sqrt(1))-erf((x-a-0.5)/sqrt(1)))...
    -    ( sqrt(pi)*sqrt(0.01)/2    ) * (erf((x+a-0.8)/sqrt(0.01))-erf((x-a-0.8)/sqrt(0.01))) ) );


bobi_var=@(x,test)(var(bobi(bsxfun(@plus,x,test))));

bobi_pirecas=@(x,test)(max(bobi(bsxfun(@plus,x,test))));

bobi_quantile09=@(x,test)(quantile(bobi(bsxfun(@plus,x,test)),0.9));

bobi_quantile05=@(x,test)(quantile(bobi(bsxfun(@plus,x,test)),0.5));

bobi_quantile01=@(x,test)(quantile(bobi(bsxfun(@plus,x,test)),0.1));
 
% Error values
a=0.1;
test=linspace(-a,+a,300)';

% Eval robustness measure
x_test=linspace(0,1,1000)';
y_test=bobi(x_test);
y_mean=bobi_mean(x_test,a);

for i=1:length(x_test)
    y_var(i,:)=bobi_var(x_test(i),test);
    y_pirecas(i,:)=bobi_pirecas(x_test(i),test);
    y_quant09(i,:)=bobi_quantile09(x_test(i),test);
    y_quant05(i,:)=bobi_quantile05(x_test(i),test);
    y_quant01(i,:)=bobi_quantile01(x_test(i),test);
end

% Mutlicriterion
y_MO=[y_mean y_var];
y_comparaison(1,:,:)=y_MO';
domination=reshape(all(bsxfun(@gt,y_MO,y_comparaison),2),1000,1000);
order=sum(domination,2)'==0;
Front_population=y_MO(order,:);


% fonction exemple
figure
hold on
plot(x_test,y_test,'k-')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
box on
hold off

% espérance
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,y_mean,'b-')
plot(0.785,bobi_mean(0.785,a),'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'$\mathcal{M}$','Esp\''{e}rance'},...
    'Interpreter','latex','Location','northwest')
box on
hold off

% variance
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,4*y_var+2.7,'b-')
plot(0.565,4*bobi_var(0.565,a)+2.7,'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'$\mathcal{M}$','Variance'},...
    'Interpreter','latex','Location','northwest')
box on
hold off

% pire cas
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,y_pirecas,'b-')
plot(0.2372,bobi_pirecas(0.2372,a),'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'$\mathcal{M}$','Pire cas'},...
    'Interpreter','latex','Location','northwest')
box on
hold off

% quantile
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,y_quant05,'b-')
plot(0.743,bobi_quantile05(0.743,a),'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'$\mathcal{M}$','Quantile d''ordre 0.5'},...
    'Interpreter','latex','Location','northwest')
box on
hold off

% différence quantile
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,0.7*(y_quant09-y_quant01)+2.7,'b-')
plot(0.5616,2.759,'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'$\mathcal{M}$','Diff\''{e}rence de quantile'},...
    'Interpreter','latex','Location','northwest')
box on
hold off

% Optimisation aglomérée
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,y_mean+sqrt(y_var),'b-')
plot(0.2372,2.56,'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'$\mathcal{M}$','Esp\''erance $+$ \''ecart-type'},...
    'Interpreter','latex','Location','northwest')
box on
hold off

% Optimisation sous contrainte
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,10*y_var,'b-')
plot(x_test,0.3*ones(length(y_var),1),'r-')
plot(0.23,2.456,'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
%legend({'$\mathcal{M}$','Contrainte sur la variance'},...
%    'Interpreter','latex','Location','northwest')
box on
hold off

% Optimisation sous contrainte
figure
hold on
plot(x_test,y_test,'k--')
plot(x_test,10*y_var,'b-')
plot(x_test,0.7*ones(length(y_var),1),'r-')
plot(0.794,2.169,'bd','MarkerFaceColor','b')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
%legend({'$\mathcal{M}$','Contrainte sur la variance'},...
%    'Interpreter','latex','Location','northwest')
box on
hold off

% Optimisation MO

x_front = x_test(order);
y_front = y_test(order);

figure
hold on
plot(Front_population(1:2,1),Front_population(1:2,2),'bo','MarkerFaceColor','b')
plot(Front_population(3:41,1),Front_population(3:41,2),'ro','MarkerFaceColor','r')
plot(Front_population(42,1),Front_population(42,2),'go','MarkerFaceColor','g')
xlabel('Esp\''erance','interpreter','latex')
ylabel('Variance','interpreter','latex')
box on
hold off

% Optimisation MO fonction
figure
hold on
plot(x_front(1:2,:),y_front(1:2,:),'bo','MarkerFaceColor','b')
plot(x_front(3:41,:),y_front(3:41,:),'ro','MarkerFaceColor','r')
plot(x_front(42,:),y_front(42,:),'go','MarkerFaceColor','g')
plot(x_test,y_test,'k--')
xlabel('$\bf{x}$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
box on
hold off

