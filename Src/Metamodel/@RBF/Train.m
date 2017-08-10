function [] = Train( obj )
% TRAIN learn the statistical relationship of the data
%
% Syntax :
% []=obj.train();

% Superclass method
obj.Train@Metamodel();

if obj.prob.display, fprintf('\nTraining starting...');end

% Matrix of squared manhattan distance
obj.diff_squared=abs(bsxfun(@minus,permute(obj.x_train,[3 2 1]),obj.x_train)).^2;

if isempty(obj.hyp_corr)
    
    % Default bounds
    if isempty( obj.lb_hyp_corr ) || isempty( obj.ub_hyp_corr )
        
        if xor( isempty(obj.lb_hyp_corr), isempty(obj.ub_hyp_corr) )
            warning('SBDOT:RBF:HypBounds_miss','Both bounds lb_hyp_corr and ub_hyp_corr have to be defined ! Default values are applied')
        end
        
        % Bounds based on inter-distances of training points
        [ hyp_corr0_temp, lb_hyperp_temp, ub_hyperp_temp ] = Theta_bound( obj.x_train );
        obj.lb_hyp_corr = log10( ( 1./(sqrt(2)*ub_hyperp_temp) ).^2 );
        obj.ub_hyp_corr = log10( ( 1./(sqrt(2)*lb_hyperp_temp) ).^2 );
        obj.hyp_corr0 = log10( ( 1./(sqrt(2)*hyp_corr0_temp) ).^2 );
    else
        
        assert( size(obj.lb_hyp_corr,2) == obj.prob.m_x ,...
            'SBDOT:RBF:HypBounds_size',...
            'lb_hyp_corr must be of size 1-by-m_x');
        
        assert( size(obj.ub_hyp_corr,2) == obj.prob.m_x ,...
            'SBDOT:RBF:HypBounds_size',...
            'ub_hyp_corr must be of size 1-by-m_x');
        
        assert( all( obj.lb_hyp_corr < obj.ub_hyp_corr , 2),...
            'SBDOT:RBF:HypBounds',...
            'lb_hyp_corr must be lower than ub_hyp_corr');
        
        obj.ub_hyp_corr = log10( obj.ub_hyp_corr );
        obj.lb_hyp_corr = log10( obj.lb_hyp_corr );
        obj.hyp_corr0 = ( obj.lb_hyp_corr + obj.ub_hyp_corr ) ./ 2;
        
    end
    
    switch obj.optimizer
        
        case 'CMAES'
            
            opt.LBounds = obj.lb_hyp_corr;
            opt.UBounds = obj.ub_hyp_corr;
            opt.TolX = 1e-4;
            opt.Restarts = 2;
            opt.IncPopSize = 2;
            opt.TolFun = 1e-4;
            opt.DispModulo = 0;
            
            obj.hyp_corr = cmaes( @obj.Loo_error, obj.hyp_corr0, [], opt );
            
        case 'fmincon'
            
            opt.Display = 'off';
            
            obj.hyp_corr = fmincon( @obj.Loo_error, obj.hyp_corr0, ...
                [], [], [], [] , obj.lb_hyp_corr, obj.ub_hyp_corr, [], opt );
            
    end
    
else
    
    assert( size(obj.hyp_corr,2) == obj.prob.m_x ,...
            'SBDOT:RBF:Hyp_val_size',...
            'hyp_corr must be of size 1-by-m_x');
        
    obj.hyp_corr = log10(obj.hyp_corr);
    obj.hyp_corr0 = obj.hyp_corr;
    obj.lb_hyp_corr = obj.hyp_corr;
    obj.ub_hyp_corr = obj.hyp_corr;
        
end

[corr_mat_temp, obj.f_mat, obj.zero_mat] = feval( obj.corr, obj, obj.diff_squared, obj.hyp_corr);

obj.corr_mat = corr_mat_temp + eye( size(corr_mat_temp,1) )*10000*eps;

param = [ obj.corr_mat obj.f_mat; obj.f_mat' obj.zero_mat ] \ ...
    [ obj.f_train ; zeros( size( obj.f_mat , 2 ) , 1 ) ];

obj.beta = param( 1:obj.prob.n_x , 1 );

obj.alpha = param( obj.prob.n_x+1 : end , 1 );
        
if obj.prob.display, fprintf(['\nRBF with ',obj.corr(5:end),' correlation function is created.\n\n']);end

obj.hyp_corr_bounds = 10.^[min(obj.lb_hyp_corr) , max(obj.ub_hyp_corr)];
obj.hyp_corr = 10.^obj.hyp_corr;

end

