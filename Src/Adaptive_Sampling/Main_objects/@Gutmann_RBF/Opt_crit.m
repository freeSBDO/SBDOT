function [] = Opt_crit( obj )
% OPT_CRIT Main method
% Select the new point to evaluate

if isa( obj.prob, 'Problem' )
    
    y = obj.prob.y;      
    n_x = obj.prob.n_x;       
    
else
    y = obj.prob.prob_HF.y;
    n_x = obj.prob.prob_HF.n_x;   
    
end

[ ~, alpha ] = sort( y );  

W_n = ( mod( obj.cycle_length - n_x + obj.n0, obj.cycle_length + 1 ) ...
    / obj.cycle_length ) ^2;    

if mod( n_x - obj.n0, obj.cycle_length + 1 ) == 0
    
    obj.k_n( obj.iter_num, : ) = n_x;
    
else
    
    obj.k_n( obj.iter_num, : ) = obj.k_n( obj.iter_num - 1 ) - floor((n_x - obj.n0) / obj.cycle_length);
    
end

Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

[ ~, min_current ] = cmaes(@obj.Prediction, Initial_point, [],obj.options_optim); 

min_target = min_current - W_n *( y(alpha(obj.k_n(end,:))) - min_current ) - 10*eps;

[ obj.x_new , obj.Gutmann_val ] = cmaes( @obj.Gutmann_crit, ...
    Initial_point, [], obj.options_optim, min_target);

end

