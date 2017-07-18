function [ grad_mean, grad_variance] = Predict_deriv( obj, x_eval, q_eval )

	assert( size(x_eval, 1) == 1,...
        'SBDOT:Q_kriging.Predict_deriv:Eval_number',...
        'Prediction of derivatives supports only one evaluation at a time' );
    
    m_x = obj.prob.m_x;
    Q_var = x_eval((m_x+1):end);
    x_eval = x_eval(1:m_x);
    
    % Jacobians (gradients)
    if nargout > 1
        
        [F, dF] = obj.Regression_matrix( [x_eval, Q_var] );
        [corr, dx] = obj.Ext_corr( x_eval, q_eval );

        grad_mean = obj.alpha.' * dF.' + obj.gamma.' * dx;
        grad_mean = grad_mean .* repmat(obj.output_scaling(q_eval, (m_x+1):end),1,obj.prob.m_x) ./ repmat(obj.input_scaling(q_eval, (m_x+1):end),length(obj.hyp_sigma2),1);

        corrt = obj.C \ corr.';
        u = obj.Ft.' * corrt - F.';
        v = obj.R \ u;

        Rv = obj.R' \ v;
        g = (obj.Ft * Rv - corrt)' * (obj.C \ dx) - (dF * Rv)';

        grad_variance = repmat(2 * obj.hyp_sigma2',1,length(obj.hyp_sigma2)) .* repmat(g,m_x,1);
        grad_variance = grad_variance ./ repmat(obj.input_scaling(q_eval, (m_x+1):end),length(obj.hyp_sigma2),1);
            
    else
        
        [~, dF] = obj.Regression_matrix( [x_eval, Q_var] );
        [~, dx] = obj.Ext_corr( x_eval, q_eval );

        grad_mean = obj.alpha.' * dF.' + obj.gamma.' * dx;
        grad_mean = grad_mean .* repmat(obj.output_scaling(q_eval, (m_x+1):end),1,obj.prob.m_x) ./ repmat(obj.input_scaling(q_eval, (m_x+1):end),length(obj.hyp_sigma2),1);
        
    end
    
end