function S = Spread_PF ( y )
%% spread_PF : Spread measure of the pareto front
%   
%   y (n by m matrix) are the n current pareto points (m objective values)
%
%   S is the spread metric (large is better)

y_min = min(y,[],1);
y_max = max(y,[],1);

S = sum(y_max-y_min);

end
