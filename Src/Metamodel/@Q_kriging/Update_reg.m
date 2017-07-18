function [obj, err] = Update_reg( obj, F, hp )
    % UPDATE_REG updates regression part of krigging fitting process
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       F is the regression matrix
    %       hp contains the values of hyperparameters
    %
    %   Output:
    %       obj is the updated input obj
    %       err is the error thrower
    %
    % Syntax :
    % 	[obj, err] = Update_reg( obj, F, hp );
    
	err = [];
    mat = cell2mat(obj.values');
    
    % Get least squares solution

	% Forward substitution
    
	Ft = obj.C \ F;

    % Ft can now be ill-conditioned -> QR factorisation of Ft = QR
    
    [Q,R] = qr(Ft,0);
    
    if  rcond(R) < 1e-10
        
		err = 'F/Ft is ill-conditioned.';
		return;
        
    end

    % Now we know Ft is good, compute Yt
    % so Yt = inv(C)Y <=> C Yt = Y -> solve for Yt
    
    Yt = obj.C \ mat;
	
    % transformation is done, now fit it:
    % Q is unitary = orthogonal for real values -> inv(Q) = Q'
    
    alpha = R \ (Q'*Yt); % polynomial coefficients

    residual = Yt - Ft*alpha;

    if obj.optim_idx( 1, obj.SIGMA2 )
        
        obj.hyp_sigma2 = 10.^hp{:,obj.SIGMA2};
        
    else 
        
        obj.hyp_sigma2 = sum(residual.^2) ./ size(mat, 1);
        
        if obj.reinterpolation
            
            tmp = ( obj.C*obj.C' ) - obj.Sigma;
            obj.sigma2_reinterp = (residual' * tmp * residual) ./ size(mat,1);
            
        end
        
    end
    
    % keep
    
	obj.alpha = alpha;
	
	obj.gamma = obj.C' \ residual;

	obj.Ft = Ft;
	obj.R = R;
    
end
