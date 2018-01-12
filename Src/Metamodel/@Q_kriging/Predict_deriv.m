function [ grad_mean, grad_variance] = Predict_deriv( obj, x_eval, q_eval )
    % PREDICT_DERIV Predict the gradients for the mean prediction and its variance
    % at new input points (see PREDICT)
    %
    % Syntax:
    %   [Grad_mean, Grad_variance]=obj.Predict_deriv(x_eval, q_eval);
    
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



% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


