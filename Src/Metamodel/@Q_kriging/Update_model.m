function obj = Update_model( obj, F, hp )
    % UPDATE_MODEL updates the overall model (applying Update_sto and Update_reg).
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       F is the regression matrix
    %       hp contains the values of hyperparameters
    %
    %   Output:
    %       obj is the updated input obj
    %
    % Syntax :
    %   obj = obj.Update_model( F, hp );
    
	% correlation
	[obj, err] = obj.Update_sto( hp );
	if ~isempty( err )
		error(['Q_kriging:Update_model:' err '(Update_sto)']);
	end
	
	% regression (get least squares solution)
	[obj, err] = obj.Update_reg( F, hp );
    if ~isempty( err )
        error(['Q_kriging:Update_model:' err '(Update_reg)']);
    end
    
    % reinterpolation (Forrester2006)
    if obj.reinterpolation
        
       obj.C_reinterp = chol( obj.C*obj.C' - obj.Sigma )';
       
       obj.Ft_reinterp = obj.C_reinterp \ F;
       [~, obj.R_reinterp] = qr(obj.Ft_reinterp,0);
       
    end

end