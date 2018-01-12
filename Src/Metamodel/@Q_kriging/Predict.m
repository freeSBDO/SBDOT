function [ mean, variance, grad_mean, grad_variance ] = Predict( obj, x_eval, q_eval )
    % PREDICT Predict the output value at new input points
    %
    %   Inputs:
    %   obj the object of class Q_kriging
    %   x_eval a matrix containing the continuous values
    %   q_eval a vector containing the qualitative index or a matrix containing the qualitative subscripts
    %
    %   Outputs:
    %   mean the mean prediction
    %   variance the variance of the prediction
    %   grad_mean the gradient of the mean prediction curve
    %   grad_variance the gradient of the curve of the variance of the prediction
    %
    % Syntax :
    % Mean=obj.Predict(x_eval, q_eval);
    % [Mean,Variance]=obj.Predict(x_eval, q_eval);
    % [Mean, Variance, Grad_mean]=obj.Predict(x_eval, q_eval);
    % [Mean, Variance, Grad_mean, Grad_variance]=obj.Predict(x_eval, q_eval);

    % Constants
    m_x = obj.prob.m_x;
    m_t = obj.prob.m_t;
    t = cellfun(@(k) k(1,:), obj.q_var, 'UniformOutput', false);
    t = cell2mat(t');
    
    % Assert inputs 
    validateattributes(q_eval,{'numeric'},{'nonempty','2d','positive'});
    validateattributes(x_eval,{'numeric'},{'nonempty','2d'});
    
    q_eval = uint8(q_eval);
    if size(q_eval,2) == 1
        
        assert( all ( q_eval <= prod(m_t).*ones(size(q_eval,1),1) ),...
            'SBDOT:Q_kriging.Predict:Wrong_q_eval_Index', ...
            'Index for qualitative evaluation shall be positive integer column lower than prod(m_t)');        
    
    else
        
        assert( size(q_eval, 2) == length(m_t),...
            'SBDOT:Q_kriging.Predict:Wrong_q_eval_Size',...
            'q_eval shall either be a single column of index of size(x_eval, 1) or a matrix of subsctips of size(x_eval, 1) x length(m_t)');
        
        
        assert( all( all( q_eval <= repmat(m_t,size(q_eval,1),1) ) ),...
            'SBDOT:Q_kriging.Predict:Wrong_q_eval_Subscript', ...
            'q_eval subscripts shall be within the number of levels in m_t');
        
    end

    assert( size(q_eval, 1) == size(x_eval, 1),...
        'SBDOT:Q_kriging.Predict:Wrong_Input_Size',...
        'q_eval and x_eval shall have the same number of rows');
    
    n_eval = size(x_eval, 1);
    
    % Superclass Method
    x_eval = obj.Predict@Metamodel( x_eval );
    
	% Preprocessing
    
    if (length(m_t)~=1 && size(q_eval,2) == 1)
        
        ind_q_eval = q_eval;
        Q_var = t(ind_q_eval,:);
        
        for i = 1:prod(m_t)
            ind = (ind_q_eval==i);
            x_eval(logical(ind),:) = (x_eval(logical(ind),:) - obj.input_scaling(i.*ones(sum(ind),1),1:m_x)) ./ obj.input_scaling(i.*ones(sum(ind),1),(m_x+1):end);
        end        
        
        q_eval = ind2subVect(m_t,q_eval');
        
    else
        
        if size(q_eval,2)~=1
            
            if ~issorted(q_eval(:,end))
                ind_q_eval = sub2indVect(m_t,q_eval);
            else
                [C,ia] = unique(q_eval, 'rows', 'stable');
                ind_q_eval = (sub2indVect(m_t,C))';
                if length(ia) == 1
                    n = size(q_eval,1);
                else
                    n = [ia(2:end)-1;size(q_eval,1)] - ia + 1;
                end
                ind_q_eval = cell2mat(arrayfun(@(i) ind_q_eval(i).*ones(n(i),1), 1:length(ind_q_eval), 'UniformOutput', false)');
            end
            
        else
            
            ind_q_eval = q_eval;
            
        end
        
        for i = 1:prod(m_t)
            ind = (ind_q_eval==i);
            x_eval(logical(ind),:) = (x_eval(logical(ind),:) - obj.input_scaling(i.*ones(sum(ind),1),1:m_x)) ./ obj.input_scaling(i.*ones(sum(ind),1),(m_x+1):end);
        end
        
        Q_var = t(ind_q_eval,:);
        
    end
    
    % scaled prediction
    switch nargout
        
        case {0,1} % Mean

            mean = obj.Predict_comp( [x_eval, Q_var], q_eval );

        case 2 % Mean variance

            [mean, variance] = obj.Predict_comp( [x_eval, Q_var], q_eval );

        case 3 % Mean variance grad_mean
            
            [mean, variance] = obj.Predict_comp( [x_eval, Q_var], q_eval );
            
            grad_mean = zeros( obj.prob.m_x, n_eval );
            
            for i = 1 : n_eval
                
                grad_mean(:,i) =  obj.Predict_deriv( [x_eval(i,:), Q_var(i,:)], q_eval(i,:) );
                
            end

            grad_mean = grad_mean';
            
        case 4 % Mean variance grad_mean grad_variance

            [mean, variance] = obj.Predict_comp( [x_eval, Q_var], q_eval );
            
            grad_mean = zeros( obj.prob.m_x, n_eval );
            grad_variance = zeros( obj.prob.m_x, n_eval );
            
            for i = 1 : n_eval
                
                [ grad_mean(:,i), grad_variance(:,i) ] = obj.Predict_deriv( [x_eval(i,:), Q_var(i,:)], q_eval(i,:) );
                
            end
            
            grad_mean = grad_mean';
            grad_variance = grad_variance';
            
    end
    

    % unscale
    for i = 1:prod(m_t)
        
        ind = (ind_q_eval==i);
        
        if any(ind)
            
            if nargout > 1
                variance(logical(ind)) = obj.output_scaling(i.*ones(sum(ind),1),2).^2 .* variance(logical(ind));
            end

            mean(logical(ind)) = obj.output_scaling(i.*ones(sum(ind),1),1) + obj.output_scaling(i.*ones(sum(ind),1),2) .* mean(logical(ind));
            
        end
        
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


