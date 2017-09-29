function [ y, cons ] = MO_convex_nsga( x )
% MO_CONVEX

y(:,1)=x(:,1).^2+x(:,2).^2;
y(:,2)=(x(:,1)-2).^2+(x(:,2)-2).^2;

cons=[];

end

