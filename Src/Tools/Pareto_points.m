function [ y_pareto, pareto_index ] = Pareto_points( y, g )
%% pareto_points : select pareto optimal first front objectives values and their indices
%   y : (n by m2 matrix) is the output vector of the dataset
%   => n is the number of points
%   => m2 is the number of objectives
%
%   g (optional) : (n by mg matrix) is the output vector of the dataset
%   => n is the number of points
%   => mg is the number of contraints
%
%   y_pareto are the pareto optimal points (objectives values) that are in
%   the admissible space (constraints fullfiled)
%
%   pareto_index are the index of the pareto optimal points in y

y_comparaison = permute( y, [3 2 1] );

domination(:,:) = permute( all( bsxfun(@lt,y,y_comparaison), 2 )...
    & any( bsxfun(@lt,y,y_comparaison), 2 ) ,...
    [1 3 2]);

if nargin == 2
    
    pareto_index = (sum(domination,1)') + (~all(g<=0,2)) ==0;
    
else
    
    pareto_index = sum(domination,1)' == 0;
    
end

y_pareto = y(pareto_index,:);

end

