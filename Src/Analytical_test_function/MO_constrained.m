function [ y, g ] = MO_constrained( x )
% MO_CONSTRAINED 

y1=x(:,1);
y2=(1+x(:,2))./x(:,1);

g1=6-x(:,2)-9*x(:,1);
g2=1+x(:,2)-9*x(:,1);

y=[y1 y2];
g=[g1 g2];


end

