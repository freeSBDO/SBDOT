function g = Cheap_cons_branin( x )
% CHEAP_CONS_BRANIN 
%   An analytical constraint that is "cheap" to compute for example script


X1 = (( x(:,1) + 5 ) ./ 15);
X2 = (x(:,2) ./15);

g = 0.2*X1 -X2 +0.1;

end

