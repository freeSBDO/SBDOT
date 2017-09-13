function g = Cheap_cons_branin( x )
%CHEAP_CONS_BRANIN Summary of this function goes here
%   Detailed explanation goes here


X1 = (( x(:,1) + 5 ) ./ 15);
X2 = (x(:,2) ./15);

g = 0.2*X1 -X2 +0.1;

end

