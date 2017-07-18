function [ x_eval_scaled ] = Predict( obj, x_eval )
    % PREDICT Evaluates the metamodel at x_eval
    %   *x_eval is a n_eval by m_x matrix
    %   *x_eval_scaled is x_eval scaled
    %
    % Syntax :
    % [ x_eval_scaled ]=obj.predict(x_eval);

    assert( size(x_eval,2) == obj.prob.m_x, ...
        'SBDOT:Metamodel:dimension_input',...
        ['Dimension of x should be ' num2str(obj.prob.m_x) ' instead of ' num2str(size(x_eval,2)) '.'] )
    
    % Data scaling
    x_eval_scaled = Scale_data( x_eval, ...
        obj.prob.lb, obj.prob.ub);
    
end

