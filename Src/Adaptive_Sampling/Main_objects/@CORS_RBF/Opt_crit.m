function [] = Opt_crit( obj )
% OPT_CRIT Main method
% Select the new point to evaluate

% Compute maximin distance
delta_distances = [];

x_temp = stk_sampling_sobol( 1000, obj.prob.m_x, [obj.prob.lb; obj.prob.ub], true );
x_sampling = x_temp.data;

delta_distances(:,:) = sum(abs(bsxfun(@minus,permute(x_sampling,[3 2 1]),obj.prob.x)).^2,2);

obj.delta_mm = max(min(delta_distances,[],1));

if isa( obj.prob, 'Problem' )    
    n_x = obj.prob.n_x;    
else
    n_x = obj.prob.prob_HF.n_x;   
end

% See CORS algorithm for setting Beta_N value
if mod( n_x - obj.n0, obj.cycle_length ) == 0    
    obj.k_n = 1;   
else    
    obj.k_n = obj.k_n + 1;      
end

obj.beta_n = obj.distance_factor(obj.k_n);

Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

[ obj.x_new, obj.cors_val ] = cmaes(@obj.Prediction, Initial_point, [],obj.options_optim); 

end

