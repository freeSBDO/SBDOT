function out = Likelihood( obj, F, hp )
    % LIKELIHOOD computes the likelihood associated to kriging
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       F is the regression matrix
    %       hp contains the values of hyperparameters on which the function is evaluated
    %
    %   Output:
    %       out returns the value of the likelihood function
    %
    % Syntax :
    %   out = Likelihood( obj, F, hp );
    
    if size(hp,1)==1
        hp = hp';
    end
    
    param = {obj.hyp_reg, obj.hyp_sigma2, obj.hyp_corr, obj.hyp_tau, obj.hyp_dchol};
    param(1, obj.optim_idx) = mat2cell( hp', 1, obj.optim_nr_parameters );

    
	% correlation
	[obj, err] = obj.Update_sto ( param );
    
    if ~isempty(err)
        out = +Inf;
        return;
    end
    
	% regression (get least squares solution)
	[obj, err] = obj.Update_reg ( F, param );
    
	if ~isempty(err)
		out = +Inf;
		return;
	end

    % likelihood
    out = feval( obj.marginal_likelihood, obj );
    
end
