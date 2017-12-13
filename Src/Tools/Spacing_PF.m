function S = Spacing_PF ( y )
%% spacing_PF : Uniformity measure of the pareto front
%   
%   y (n by m matrix) are the n current pareto points (m objective values)
%
%   S is the spacing metric (smaller is better)

D_min_i = pdist(y,'euclidean');
D_min_i = squareform( D_min_i );
D_min_i ( D_min_i == 0) = max(max(D_min_i));

D_min = min(D_min_i,[],2);

D_mean = mean(D_min);

S = sqrt((1/size(y,1))*sum((D_mean-D_min).^2));

end
