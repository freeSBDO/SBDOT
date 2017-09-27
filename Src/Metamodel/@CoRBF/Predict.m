function [ y_pred, power] = Predict( obj, x_eval )
    % PREDICT Predict the output value at new input points
    %
    % Syntax :
    % Mean=obj.Predict(x_eval);
    % [Mean,Variance]=obj.Predict(x_eval);
    % [Mean, Variance, Grad_mean]=obj.Predict(x_eval);
    % [Mean, Variance, Grad_mean, Grad_variance]=obj.Predict(x_eval);

    % Superclass method

    switch nargout
        case {0,1} % Mean

            y_pred = obj.rho*obj.RBF_c.Predict(x_eval) ...
                + obj.RBF_d.Predict(x_eval);

        case 2 % Mean variance

            y_pred = obj.rho*obj.RBF_c.Predict(x_eval) ...
                + obj.RBF_d.Predict(x_eval);
            [~,power] = obj.RBF_d.Predict(x_eval);
        
    end    
    
end

