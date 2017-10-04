function [ y, grad ] = MO_convex( x )
% MO_CONVEX
%   For example script MGDA


y(:,1)=x(:,1).^2+x(:,2).^2;
y(:,2)=(x(:,1)-2).^2+(x(:,2)-2).^2;

grad=[2*x(:,1) 2*x(:,1)-4;2*x(:,2) 2*x(:,2)-4];

end

