function [] = Train( obj )
% TRAIN learn the statistical relationship of the data
%
% Syntax :
% []=obj.train();

% Superclass method
obj.Train@Metamodel();

if obj.prob.display, fprintf('\nTraining starting...');end


if isempty(obj.hyp_corr)
    
    % Default bounds
    if isempty( obj.lb_hyp_corr ) || isempty( obj.ub_hyp_corr )
        
        if xor( isempty(obj.lb_hyp_corr), isempty(obj.ub_hyp_corr) )
            warning('SBDOT:RBF:HypBounds_miss','Both bounds lb_hyp_corr and ub_hyp_corr have to be defined ! Default values are applied')
        end
        
        % Bounds based on inter-distances of training points
        [ hyp_corr0_temp, lb_hyperp_temp, ub_hyperp_temp ] = Theta_bound( obj.x_train );
        obj.lb_hyp_corr = log10( ( 1./(2*ub_hyperp_temp) ).^2 ) * ones(1,obj.prob.m_x);
        obj.ub_hyp_corr = log10( ( 1./(2*lb_hyperp_temp) ).^2 ) * ones(1,obj.prob.m_x);
        obj.hyp_corr0 = log10( ( 1./(2*hyp_corr0_temp) ).^2 ) * ones(1,obj.prob.m_x);
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
        
    end
    
else
    
    assert( size(obj.hyp_corr,2) == obj.prob.m_x ,...
        'SBDOT:RBF:Hyp_val_size',...
        'hyp_corr0 must be of size 1-by-m_x');
    
    obj.hyp_corr0 = log10(obj.hyp_corr);
    obj.lb_hyp_corr = log10(obj.hyp_corr);
    obj.ub_hyp_corr = log10(obj.hyp_corr);
    
end


obj.diff_man=abs(bsxfun(@minus,permute(obj.x_train,[3 2 1]),obj.x_train));
obj.diff(:,:)=sum(obj.diff_man,2); % Compute distances between training points

obj.f_mat = [ obj.x_train, ones( obj.prob.n_x, 1 ) ]; % Polynomial matrix

obj.corr_mat = feval( obj.corr );

switch obj.corr
    case 'Cubic'
        
        
        
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:); % RBF coefficients
        obj.b=param(obj.Problem{1}.n_x+1:obj.Problem{1}.n_x+obj.Problem{1}.m_x); % RBF coefficients
        obj.a=param(end); % RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with cubic correlation function is created\n\n');end
        
    case 'Linear'
        
        obj.P=ones(obj.Problem{1}.n_x,1); % Polynomial matrix
        [obj.corr_mat,param]=obj.linear_ker;
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:); % RBF coefficients
        obj.b=zeros(obj.Problem{1}.m_x,1); % RBF coefficients
        obj.a=param(obj.Problem{1}.n_x+1); % RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with linear correlation function is created\n\n');end
        
        
    case 'ThinPlateSpline'
        
        obj.P=[obj.x_scaled{1},ones(obj.Problem{1}.n_x,1)]; % Polynomial matrix
        [obj.corr_mat,param]=obj.thinplatespline_ker;
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:); % RBF coefficients
        obj.b=param(obj.Problem{1}.n_x+1:obj.Problem{1}.n_x+obj.Problem{1}.m_x); % RBF coefficients
        obj.a=param(end); % RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with thin plane spline correlation function is created\n\n');end
        
    case 'Multiquadric'
        
        obj.P=ones(obj.Problem{1}.n_x,1); % Polynomial matrix
        if isempty(obj.gamma)
            
            %[mean_theta,obj.lb_theta,obj.ub_theta] = theta_bound(obj.x_scaled{1});
            % Optimization options
            opt.TolX=1e-4;
            opt.TolFun=1e-4;
            opt.DispModulo=0;
            opt.Restarts=2;
            opt.LBounds=zeros(1,obj.Problem{1}.m_x);
            opt.UBounds=ones(1,obj.Problem{1}.m_x);
            
            obj.gamma = cmaes(@obj.gamma_estimator, 0.5*ones(1,obj.Problem{1}.m_x), [], opt);
        end
        
        % correlation matrix
        [obj.corr_mat,param]=obj.multiquadric_ker(obj.gamma);
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:);% RBF coefficients
        obj.a=param(obj.Problem{1}.n_x+1);% RBF coefficients
        obj.b=zeros(obj.Problem{1}.m_x,1);% RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with multiquadric correlation function is created\n\n');end
        
    case 'pmultiquadric'
        
        obj.P=ones(obj.Problem{1}.n_x,1); % Polynomial matrix
        if isempty(obj.gamma)
            
            %[mean_theta,obj.lb_theta,obj.ub_theta] = theta_bound(obj.x_scaled{1});
            % Optimization options
            opt.TolX=1e-4;
            opt.TolFun=1e-4;
            opt.DispModulo=0;
            opt.Restarts=2;
            opt.LBounds=[zeros(1,obj.Problem{1}.m_x) -10/2];
            opt.UBounds=[10*ones(1,obj.Problem{1}.m_x) 10/2];
            
            obj.gamma = cmaes(@obj.gamma_estimator, [0.5*ones(1,obj.Problem{1}.m_x) 0.5], [], opt);
        end
        
        % correlation matrix
        [obj.corr_mat,param]=obj.pmultiquadric_ker(obj.gamma);
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:);% RBF coefficients
        obj.a=param(obj.Problem{1}.n_x+1);% RBF coefficients
        obj.b=zeros(obj.Problem{1}.m_x,1);% RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with multiquadric correlation function is created\n\n');end
        
    case 'Inv_multiquadric'
        
        obj.P=ones(obj.Problem{1}.n_x,1); % Polynomial matrix
        if isempty(obj.gamma)
            
            %[mean_theta,obj.lb_theta,obj.ub_theta] = theta_bound(obj.x_scaled{1});
            % Optimization options
            opt.TolX=1e-4;
            opt.TolFun=1e-4;
            opt.DispModulo=0;
            opt.Restarts=2;
            opt.LBounds=zeros(1,obj.Problem{1}.m_x);
            opt.UBounds=ones(1,obj.Problem{1}.m_x);
            
            obj.gamma = cmaes(@obj.gamma_estimator, 0.5*ones(1,obj.Problem{1}.m_x), [], opt);
        end
        
        % correlation matrix
        [obj.corr_mat,param]=obj.inv_multiquadric_ker(obj.gamma);
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:);% RBF coefficients
        obj.a=param(obj.Problem{1}.n_x+1);% RBF coefficients
        obj.b=zeros(obj.Problem{1}.m_x,1);% RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with inv_multiquadric correlation function is created\n\n');end
        
    case 'Gaussian'
        
        if isempty(obj.gamma)
            
            [mean_theta,obj.lb_theta,obj.ub_theta] = theta_bound(obj.x_scaled{1});
            % Optimization options
            opt.TolX=1e-4;
            opt.Restarts=2;
            opt.IncPopSize=2;
            opt.TolFun=1e-4;
            opt.DispModulo=0;
            opt.LBounds=obj.lb_theta*ones(1,obj.Problem{1}.m_x);
            opt.UBounds=obj.ub_theta*ones(1,obj.Problem{1}.m_x);
            
            obj.gamma = cmaes(@obj.gamma_estimator, mean_theta*ones(1,obj.Problem{1}.m_x), [], opt);
        end
        
        % correlation matrix
        [obj.corr_mat,param]=obj.gauss_ker(obj.gamma);
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:);% RBF coefficients
        obj.a=0;% RBF coefficients
        obj.b=zeros(obj.Problem{1}.m_x,1);% RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with gaussian correlation function is created\n\n');end
        
    case 'Matern52'
        
        if isempty(obj.gamma)
            
            [mean_theta,obj.lb_theta,obj.ub_theta] = theta_bound(obj.x_scaled{1});
            % Optimization options
            opt.TolX=1e-4;
            opt.Restarts=2;
            opt.IncPopSize=2;
            opt.TolFun=1e-4;
            opt.DispModulo=0;
            opt.LBounds=obj.lb_theta*ones(1,obj.Problem{1}.m_x);
            opt.UBounds=obj.ub_theta*ones(1,obj.Problem{1}.m_x);
            
            obj.gamma = cmaes(@obj.gamma_estimator, mean_theta*ones(1,obj.Problem{1}.m_x), [], opt);
        end
        
        % correlation matrix
        [obj.corr_mat,param]=obj.matern52_ker(obj.gamma);
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:);% RBF coefficients
        obj.a=0;% RBF coefficients
        obj.b=zeros(obj.Problem{1}.m_x,1);% RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with Matern52 correlation function is created\n\n');end
        
    case 'Wendland'
        
        if isempty(obj.gamma)
            
            [mean_theta,obj.lb_theta,obj.ub_theta] = theta_bound(obj.x_scaled{1});
            % Optimization options
            opt.TolX=1e-4;
            opt.Restarts=2;
            opt.IncPopSize=2;
            opt.TolFun=1e-4;
            opt.DispModulo=0;
            opt.LBounds=obj.lb_theta*ones(1,obj.Problem{1}.m_x);
            opt.UBounds=obj.ub_theta*ones(1,obj.Problem{1}.m_x);
            
            obj.gamma = cmaes(@obj.gamma_estimator, mean_theta*ones(1,obj.Problem{1}.m_x), [], opt);
        end
        
        % correlation matrix
        [obj.corr_mat,param]=obj.Wendland_ker(obj.gamma);
        
        obj.lambda=param(1:obj.Problem{1}.n_x,:);% RBF coefficients
        obj.a=0;% RBF coefficients
        obj.b=zeros(obj.Problem{1}.m_x,1);% RBF coefficients
        if obj.Problem{1}.display, fprintf('RBF with gaussian correlation function is created\n\n');end
        
    otherwise
        error('SBDO:RBF:wrong_corr','RBF type is false, check obj.corr')
end
end
end

