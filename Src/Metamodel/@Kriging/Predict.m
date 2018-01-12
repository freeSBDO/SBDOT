function [ mean, variance, grad_mean, grad_variance ] = Predict( obj, x_eval )
% PREDICT 
%   Predict the output value at new input points
%
%   Syntax examples :
%       Mean=obj.Predict(x_eval);
%       [Mean,Variance]=obj.Predict(x_eval);
%       [Mean, Variance, Grad_mean]=obj.Predict(x_eval);
%       [Mean, Variance, Grad_mean, Grad_variance]=obj.Predict(x_eval);

    % Superclass method
    x_eval_scaled = obj.Predict@Metamodel( x_eval );

    n_eval = size( x_eval, 1 );

    switch nargout
        case {0,1} % Mean

            mean = obj.k_oodace.predict( x_eval_scaled );

        case 2 % Mean variance

            [ mean, variance ] = ...
                obj.k_oodace.predict( x_eval_scaled );

        case 3 % Mean variance grad_mean

            mean = zeros( n_eval, 1 );
            variance  = zeros( n_eval, 1 );
            grad_mean = zeros( obj.prob.m_x, n_eval );
            
            for i = 1 : n_eval
                
                [ mean(i,:), variance(i,:) ] = ...
                    obj.k_oodace.predict( x_eval_scaled(i,:) );
                
                grad_mean(:,i) =  ...
                    obj.k_oodace.predict_derivatives( x_eval_scaled(i,:) );
                
            end
            
            grad_mean = grad_mean;

        case 4 % Mean variance grad_mean grad_variance

            mean = zeros( n_eval, 1 );
            variance = zeros( n_eval, 1 );
            grad_mean = zeros( obj.prob.m_x, n_eval );
            grad_variance = zeros( obj.prob.m_x, n_eval );
            
            for i = 1 : n_eval
                
            	[ mean(i,:), variance(i,:) ] = ...
                    obj.k_oodace.predict( x_eval_scaled(i,:) );   
                
                [ grad_mean(:,i), grad_variance(:,i) ] =  ...
                    obj.k_oodace.predict_derivatives( x_eval_scaled(i,:) );            
            end
            
            grad_mean = grad_mean';
            grad_variance = grad_variance';
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


