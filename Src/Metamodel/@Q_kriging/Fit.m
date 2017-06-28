function obj = Fit( obj, samples, values )
    % FIT fits all the necessary hyperparameters in regards of the set of
    % options chosen.
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       samples are the normalized input values of the model
    %       values are the normalized output values of the model
    %
    %   Output:
    %       obj is the updated obj input
    %
    % Syntax :
    % obj = obj.Fit( samples, values );
    
    obj = obj.Set_data( samples, values );
    
    % Preprocessing
    if ~obj.optim_idx(1,obj.REG)
        
        % stochastic kriging
        if ~isempty( obj.Sigma )
            obj.Sigma = obj.Sigma;
        else
            % add a small number to ease ill-conditioning
            obj.Sigma = (sum(obj.prob.n_x)+10)*eps;
        end

        o = (1:sum(obj.prob.n_x))';               
        obj.Sigma = sparse( o, o, obj.Sigma);
        
    end

    if ischar( obj.regpoly )

        switch obj.regpoly
            case ''
                dj = [];                    % no regression function (constant=0)
            case 'regpoly0'
                dj = 0;                     % constant
            case 'regpoly1'
                dj = [0 ; 1];               % constant + linear terms
            case 'regpoly2'
                dj = [0 ; 1 ; 2];           % constant + linear + quadratic interactions
            case 'regpoly3'
                dj = [0 ; 1 ; 2 ; 3];       % all the above + cubic interactions
            case 'regpoly4'
                dj = [0 ; 1 ; 2 ; 3 ; 4];   % all the above + quartic interactions
        end

        obj.regpoly = obj.Generate_degrees( dj );
        
    end

    mat_samples = cell2mat(obj.samples');
    mat_values = cell2mat(obj.values');
    mat_q_var = cell2mat(obj.q_var');
    
    F = obj.Regression_matrix([mat_samples,mat_q_var]);
    alpha = (F'*F)\(F'*mat_values);
    temp = mat_values-F*alpha;
    
    if ~obj.optim_idx(obj.SIGMA2)
        
        if isempty(obj.hyp_sigma2)
            obj.hyp_sigma2 = log10(var(mat_values-F*alpha));
        end
        
    else
        
        if isempty( obj.lb_hyp_sigma2 ) || isempty( obj.ub_hyp_sigma2 )

            if xor( isempty(obj.lb_hyp_sigma2), isempty(obj.ub_hyp_sigma2) )
                warning('SBDOT:Q_kriging:VarBounds_miss',...
                    'Both bounds lb_hyp_sigma2 and ub_hyp_sigma2 have to be defined ! Default values are applied')
            end

            obj.hyp_sigma2_0 = log10(var(temp));
                
            obj.hyp_lb_sigma2 = log10(1e-8);
            obj.hyp_ub_sigma2 = log10(abs(min(temp)-max(temp)));

        else

            assert( all( obj.lb_hyp_sigma2 < obj.ub_hyp_sigma2 , 2),...
            'SBDOT:Q_kriging:Sigma2Bounds',...
            'lb_hyp_sigma2 must be lower than ub_hyp_sigma2');
        
            assert( all (obj.lb_hyp_sigma2 > 0 ),...
            'SBDOT:Q_kriging:Sigma2_Lower_Bound',...
            'lb_hyp_tau must be strictly positive');

            if isempty(obj.hyp_sigma2_0)
                obj.hyp_sigma2_0 = log10(var(temp));
            else
                
                assert( all( and(obj.hyp_sigma2_0<obj.ub_hyp_sigma2,obj.hyp_sigma2_0>obj.lb_hyp_sigma2 ) ), ...
                'SBOT:Q_kriging:hyp_sigma2_0_OutBounds', ...
                'hyp_sigma2_0 must be within the range defined by HypBounds');
            
            end
            
        end
        
    end

    % Correlation matrix preprocessing

    n = sum(obj.prob.n_x);
    nSamples = 1:n;
    idx = nSamples(ones(n, 1),:);
    
    if strcmp(obj.tau_type, 'heteroskedastic')
        
        a = tril( idx, 0 );
        b = triu( idx, 0 )';
        
    else
        
        a = tril( idx, -1 );
        b = triu( idx, 1 )';
        
    end
    
    a = a(a~=0);
    b = b(b~=0);
    dist_idx_psi = [a b];

    dist = mat_samples(a,:) - mat_samples(b,:);

    clear a b idx

    obj.dist = dist;
    obj.dist_idx_psi = dist_idx_psi;

    hp = {obj.hyp_reg, obj.hyp_sigma2, obj.hyp_corr, obj.hyp_tau, obj.hyp_dchol};
    
    [obj, optimHp, ~] = obj.Tune_parameters( F );
    
    hp(1,obj.optim_idx) = mat2cell( optimHp, 1, obj.optim_nr_parameters );

    obj.Update_model( F, hp );
    
end