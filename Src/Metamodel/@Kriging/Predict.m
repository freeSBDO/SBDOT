function varargout = Predict( obj, x_eval )
    % PREDICT Predict the output value at new input points
    %
    % Syntax :
    % Mean=obj.Predict(x_eval);
    % [Mean,Variance]=obj.Predict(x_eval);
    % [Mean, Variance, Grad_mean]=obj.Predict(x_eval);
    % [Mean, Variance, Grad_mean, Grad_variance]=obj.Predict(x_eval);

    % Superclass method
    x_eval_scaled = obj.Predict@Metamodel( x_eval );

    n_eval = size( x_eval, 1 );

    switch nargout
        case {0,1} % Mean

            varargout{1} = obj.k_oodace.predict( x_eval_scaled );

        case 2 % Mean variance

            [ varargout{1}, varargout{2} ] = ...
                obj.k_oodace.predict( x_eval_scaled );

        case 3 % Mean variance grad_mean

            varargout{1} = zeros( n_eval, 1 );
            varargout{2} = zeros( n_eval, 1 );
            varargout{3} = zeros( obj.prob.m_x, n_eval );
            
            for i = 1 : n_eval
                
                [ varargout{1}(i,:), varargout{2}(i,:) ] = ...
                    obj.k_oodace.predict( x_eval_scaled(i,:) );
                
                varargout{3}(:,i) =  ...
                    obj.k_oodace.predict_derivatives( x_eval_scaled(i,:) );
                
            end
            
            varargout{3} = varargout{3}';

        case 4 % Mean variance grad_mean grad_variance

            varargout{1} = zeros( n_eval, 1 );
            varargout{2} = zeros( n_eval, 1 );
            varargout{3} = zeros( obj.prob.m_x, n_eval );
            varargout{4} = zeros( obj.prob.m_x, n_eval );
            
            for i = 1 : n_eval
                
            	[ varargout{1}(i,:), varargout{2}(i,:) ] = ...
                    obj.k_oodace.predict( x_eval_scaled(i,:) );   
                
                [ varargout{3}(:,i), varargout{4}(:,i) ] =  ...
                    obj.k_oodace.predict_derivatives( x_eval_scaled(i,:) );            
            end
            
            varargout{3} = varargout{3}';
            varargout{4} = varargout{4}';

        otherwise

            error( 'SBDOT:Kriging:PredictNargout',...
                'The number of output argument asked for Predict is not valid' )

    end
end

