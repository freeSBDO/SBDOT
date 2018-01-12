function obj = Train( obj )
    % TRAIN learn the statistical relationship of the data
    %
    %   Syntax :
    %       []=obj.Train();

    % Superclass method
    obj.Train@Metamodel();

    if obj.prob.display, fprintf('\nTraining starting...');end

    x_mat = cell2mat( obj.x_train' );
    x_mat = x_mat(:,1:obj.prob.m_x);

    if isempty(obj.hyp_corr)

        % Default bounds
        if isempty( obj.lb_hyp_corr ) || isempty( obj.ub_hyp_corr )

            if xor( isempty(obj.lb_hyp_corr), isempty(obj.ub_hyp_corr) )
                warning('SBDOT:Q_kriging:HypBounds_miss',...
                    'Both bounds lb_hyp_corr and ub_hyp_corr have to be defined ! Default values are applied')
            end

            % Bounds based on inter-distances of training points

            [ hyp_corr_0_temp, lb_hyperp_temp, ub_hyperp_temp ] = Theta_bound( x_mat );
            obj.lb_hyp_corr = log10( ( 1./(2*ub_hyperp_temp) ).^2 );
            obj.ub_hyp_corr = log10( ( 1./(2*lb_hyperp_temp) ).^2 );
            obj.hyp_corr_0 = log10( ( 1./(2*hyp_corr_0_temp) ).^2 );

        else

            assert( size(obj.lb_hyp_corr,2) == obj.prob.m_x ,...
                'SBDOT:Q_kriging:HypBounds_size',...
                'lb_hyp_corr must be of size 1-by-m_x');

            assert( size(obj.ub_hyp_corr,2) == obj.prob.m_x ,...
                'SBDOT:Q_kriging:HypBounds_size',...
                'ub_hyp_corr must be of size 1-by-m_x');

            assert( all( obj.lb_hyp_corr < obj.ub_hyp_corr ),...
                'SBDOT:Q_kriging:HypBounds',...
                'lb_hyp_corr must be lower than ub_hyp_corr');
            
            assert( all( obj.lb_hyp_corr > zeros(size(obj.lb_hyp_corr)) ),...
                'SBDOT:Q_kriging:HypBounds_values',...
                'lb_hyp_corr must be strictly positive');

            obj.ub_hyp_corr = log10( obj.ub_hyp_corr );
            obj.lb_hyp_corr = log10( obj.lb_hyp_corr );

            if isempty(obj.hyp_corr_0)
                
                obj.hyp_corr_0 = ( obj.lb_hyp_corr + obj.ub_hyp_corr ) ./ 2;
                
            else
                
                assert( size(obj.hyp_corr_0,2) == obj.prob.m_x ,...
                    'SBDOT:Q_kriging:hyp_corr_0_size',...
                    'hyp_corr_0 must be of size 1-by-m_x');
            
                assert( all( and(obj.hyp_corr_0<10^obj.ub_hyp_corr,obj.hyp_corr_0>10^obj.lb_hyp_corr ) ), ...
                    'SBDOT:Q_kriging:hyp_corr_0_OutBounds', ...
                    'hyp_corr_0 must be within the range defined by HypBounds');
                
                obj.hyp_corr_0 = log10( obj.hyp_corr_0 );
                
            end

            
        end
        
    else
        
        assert( size(obj.hyp_corr,2) == obj.prob.m_x ,...
            'SBDOT:Q_kriging:Hyp_corr_size',...
            'hyp_corr must be of size 1-by-m_x');
        
        assert( all(obj.hyp_corr > 0) ,...
            'SBDOT:Q_kriging:Hyp_corr_values',...
            'hyp_corr must be positive');
        
        obj.hyp_corr = log10( obj.hyp_corr );
        
        if any([~isempty(obj.lb_hyp_corr),~isempty(obj.ub_hyp_corr),~isempty(obj.hyp_corr_0)])
        
            warning('SBDOT:Q_kriging:Unused_Arg',...
                'hyp_corr was not set to empty and at least another component of hyp_corr is not empty. Other hyp_corr entries will be set to default value.');
            obj.hyp_corr_0 = [];
            obj.lb_hyp_corr = [];
            obj.ub_hyp_corr = [];
            
        end
        
    end

    obj.reg_max_level_interactions = obj.prob.m_x;

    % Regression (if asked)
    if obj.reg

        if obj.prob.display, fprintf('\nRegression activated\n');end

        if isempty(obj.hyp_reg)

            if isempty( obj.lb_hyp_reg ) || isempty( obj.ub_hyp_reg )

                if xor( isempty(obj.lb_hyp_reg), isempty(obj.ub_hyp_reg) )
                    warning('SBDOT:Q_kriging:RegBounds_miss',...
                        'Both bounds lb_hyp_reg and ub_hyp_reg have to be defined ! Default values are applied')
                end

                obj.lb_hyp_reg = log10(1e-8);
                obj.ub_hyp_reg = log10(max( var(cell2mat(obj.f_train')), 1e-7 ));
                obj.hyp_reg_0 = log10(0.5*1e-7);
                
            else

                assert( size(obj.lb_hyp_reg,2) == 1 ,...
                    'SBDOT:Q_kriging:RegBounds_size',...
                    'lb_hyp_reg must be of size 1');

                assert( size(obj.ub_hyp_reg,2) == 1 ,...
                    'SBDOT:Q_kriging:RegBounds_size',...
                    'ub_hyp_reg must be of size 1');
                
                assert( all( obj.lb_hyp_reg < obj.ub_hyp_reg , 2),...
                    'SBDOT:Q_kriging:RegBounds',...
                    'lb_hyp_reg must be lower than ub_hyp_reg');
                
                assert( all( obj.lb_hyp_reg > 0 , 2),...
                    'SBDOT:Q_kriging:RegBounds',...
                    'lb_hyp_reg and ub_hyp_reg must be positive');

                obj.ub_hyp_reg = log10( obj.ub_hyp_reg );
                obj.lb_hyp_reg = log10( obj.lb_hyp_reg );
            
                if isempty(obj.hyp_reg_0)
                    
                    obj.hyp_reg_0 = (obj.lb_hyp_reg + obj.ub_hyp_reg)/2;
                    
                else
                    
                    assert( all( and(obj.hyp_reg_0<10^obj.ub_hyp_reg,obj.hyp_reg_0>10^obj.lb_hyp_reg ) ), ...
                    'SBOT:Q_kriging:hyp_reg_0_OutBounds', ...
                    'hyp_reg_0 must be within the range defined by HypBounds');
                
                    obj.hyp_reg_0 = log10( obj.hyp_reg_0 );
                
                end
                
            end

            obj.reinterpolation = true;

        else
            
            if any([~isempty(obj.lb_hyp_reg),~isempty(obj.ub_hyp_reg),~isempty(obj.hyp_reg_0)])

                warning('SBDOT:Q_kriging:Unused_Arg',...
                    'hyp_reg was not set to empty and at least another component of hyp_reg is not empty. Other hyp_reg entries will be set to default value.');
                obj.hyp_reg_0 = [];
                obj.lb_hyp_reg = [];
                obj.ub_hyp_reg = [];

            end
            
            obj.Sigma = obj.hyp_reg;
            obj.hyp_reg = log10(obj.hyp_reg);
            
        end
        
    elseif any([~isempty(obj.hyp_reg),~isempty(obj.lb_hyp_reg),~isempty(obj.ub_hyp_reg),~isempty(obj.hyp_reg_0)])
        
        warning('SBDOT:Q_kriging:Unused_Arg',...
            'reg boolean was set to false and at least one component of hyp_reg is not empty. Hyp_reg entries will be set to default value.');
        obj.hyp_reg = [];
        obj.hyp_reg_0 = [];
        obj.lb_hyp_reg = [];
        obj.ub_hyp_reg = [];
        
    end

    if obj.var_opti
        
        if ~isempty(obj.hyp_sigma2)

            warning('SBDOT:Q_kriging:Unused_Arg',...
                'var_opti boolean was set to true and hyp_sigma2 is not empty. Hyp_sigma2 will be set to default value.');
            obj.hyp_sigma2 = [];
        
        end
        
        if isempty(obj.hyp_sigma2_0), obj.hyp_sigma2_0 = Inf; end

    elseif any([~isempty(obj.lb_hyp_sigma2),~isempty(obj.ub_hyp_sigma2),~isempty(obj.hyp_sigma2_0)])

            warning('SBDOT:Q_kriging:Unused_Arg',...
                'var_opti boolean was set to false and at least another component of hyp_sigma2 is not empty. Hyp_sigma2 entries will be set to default value.');
            obj.hyp_sigma2_0 = [];
            obj.lb_hyp_sigma2 = [];
            obj.ub_hyp_sigma2 = [];
        
    end
    
    if isempty(obj.hyp_tau)

        if isempty( obj.lb_hyp_tau ) || isempty( obj.ub_hyp_tau )

            if xor( isempty(obj.lb_hyp_tau), isempty(obj.ub_hyp_tau) )
                warning('SBDOT:Q_kriging:TauBounds_miss',...
                    'Both bounds lb_hyp_tau and ub_hyp_tau have to be defined ! Default values are applied')
            end

            obj.hyp_tau_0 = obj.Init_tau_id();

            if strcmp(obj.tau_type,'choleski') || strcmp(obj.tau_type,'heteroskedastic')

                obj.lb_hyp_tau = 10e-5 .* ones(1,sum(arrayfun(@(k) sum(1:k), (obj.prob.m_t-1))));
                obj.ub_hyp_tau = (pi-(10e-5)) .* ones(1,sum(arrayfun(@(k) sum(1:k), (obj.prob.m_t-1))));

            else
                
                obj.lb_hyp_tau = arrayfun(@(k) -1/(k-1),obj.prob.m_t);
                obj.ub_hyp_tau = ones(1,length(obj.prob.m_t));

            end

        else
        
            if strcmp(obj.tau_type, 'choleski') || strcmp(obj.tau_type, 'heteroskedastic')
                
                m = obj.prob.m_t;
                m = sum(m.*(m-1)/2);

                assert( size(obj.lb_hyp_tau,2) == m ,...
                    'SBDOT:Q_kriging:TauBounds_size',...
                    'For the Choleski and Heteroskedastic methods, lb_hyp_tau must be of size 1-by-sum(m_t.*(m_t-1)/2)');

                assert( size(obj.ub_hyp_tau,2) == m ,...
                    'SBDOT:Q_kriging:TauBounds_size',...
                    'For the Choleski and Heteroskedastic methods, ub_hyp_tau must be of size 1-by-sum(m_t.*(m_t-1)/2)');

                assert( all( obj.lb_hyp_tau < obj.ub_hyp_tau , 2),...
                'SBDOT:Q_kriging:TauBounds',...
                'lb_hyp_tau must be lower than ub_hyp_tau');
            
                assert( and (all( obj.ub_hyp_tau < pi ), all( obj.lb_hyp_tau > 0 )),...
                'SBDOT:Q_kriging:TauBounds_Chol_Heterosked',...
                'lb_hyp_tau and ub_hyp_tau must be positive and lower than pi');
            
            else

                assert( size(obj.lb_hyp_tau,2) == length(obj.prob.m_t) ,...
                    'SBDOT:Q_kriging:TauBounds_size',...
                    'For the isotropic method, lb_hyp_tau must be of size 1-by-m_t');

                assert( size(obj.ub_hyp_tau,2) == length(obj.prob.m_t) ,...
                    'SBDOT:Q_kriging:TauBounds_size',...
                    'For the isotropic method, ub_hyp_tau must be of size 1-by-m_t');

                assert( all( obj.lb_hyp_tau < obj.ub_hyp_tau , 2),...
                'SBDOT:Q_kriging:TauBounds',...
                'lb_hyp_tau must be lower than ub_hyp_tau');
            
                assert( and (all( obj.ub_hyp_tau < 1 ), all( obj.lb_hyp_tau > arrayfun(@(k) -1/(k-1),obj.prob.m_t) )),...
                'SBDOT:Q_kriging:TauBounds_Isotropic',...
                'lb_hyp_tau must be greater than -1/(m_t(k)-1); ub_hyp_tau must be lower than 1');
            
            end
                
            if isempty(obj.hyp_tau_0)
                
                obj.hyp_tau_0 = (obj.lb_hyp_tau + obj.ub_hyp_tau)/2;
                
            else
                
                assert( size(obj.hyp_tau_0,2) == size(obj.lb_hyp_tau,2) ,...
                    'SBDOT:Q_kriging:hyp_tau_0_size',...
                    'hyp_tau_0 and hyp_tau_bounds must have the same size');

                assert( all( and(obj.hyp_tau_0<obj.ub_hyp_tau,obj.hyp_tau_0>obj.lb_hyp_tau ) ), ...
                'SBDOT:Q_kriging:hyp_tau_0_OutBounds', ...
                'hyp_tau_0 must be within the range defined by HypBounds');
            
            end
            
        end

    else
        
        if strcmp(obj.tau_type, 'choleski') || strcmp(obj.tau_type, 'heteroskedastic')
            
            m = obj.prob.m_t;
            m = sum(m.*(m-1)/2);
        
            assert(size(obj.hyp_tau,2) == m, 'SBDOT:Q_kriging:hyp_tau_wrong_size',...
                horzcat('hyp_tau is of size ', num2str(size(obj.hyp_tau,2)), ', and should be of size ',...
                num2str(m), ' in regard of m_t'));
        
            assert( and (all( obj.hyp_tau < pi ), all( obj.hyp_tau > 0 )),...
            'SBDOT:Q_kriging:Tau_Chol_Heterosked',...
            'hyp_tau must be positive and lower than pi');
        
        else
            
            assert(size(obj.hyp_tau,2) == length(obj.prob.m_t), 'SBDOT:Q_kriging:hyp_tau_wrong_size',...
                horzcat('hyp_tau is of size ', num2str(size(obj.hyp_tau,2)), ', and should be of size ',...
                num2str(length(obj.prob.m_t)), ' in regard of m_t'));
            
            assert( and (all( obj.hyp_tau < 1 ), all( obj.hyp_tau > arrayfun(@(k) -1/(k-1),obj.prob.m_t) )),...
            'SBDOT:Q_kriging:Tau_Isotropic',...
            'hyp_tau must be greater than -1/(m_t(k)-1) and lower than 1');
        
        end
        
        if any([~isempty(obj.lb_hyp_tau),~isempty(obj.ub_hyp_tau),~isempty(obj.hyp_tau_0)])
            warning('SBDOT:Q_kriging:Unused_Arg',...
                'hyp_tau was not set to empty and at least another component of hyp_tau is not empty. Other hyp_tau entries will be set to default value.');
            obj.hyp_tau_0 = [];
            obj.lb_hyp_tau = [];
            obj.ub_hyp_tau = [];
        end
        
    end

    if strcmp(obj.tau_type,'heteroskedastic')
        
        if isempty(obj.hyp_dchol)
            
            if isempty( obj.lb_hyp_dchol ) || isempty( obj.ub_hyp_dchol )

                if xor( isempty(obj.lb_hyp_dchol), isempty(obj.ub_hyp_dchol) )
                    warning('SBDOT:Q_kriging:DcholBounds_miss',...
                        'Both bounds lb_hyp_dchol and ub_hyp_dchol have to be defined ! Default values are applied')
                end

                obj.lb_hyp_dchol = 10e-5 .* ones(1, sum(obj.prob.m_t));
                obj.ub_hyp_dchol = 10 .* ones(1, sum(obj.prob.m_t));
                obj.hyp_dchol_0 = sqrt(mean(var(x_mat))*ones(sum(obj.prob.m_t),1));
                obj.hyp_dchol_0 = arrayfun(@(k) min(max(k,10e-5),10),obj.hyp_dchol_0);

            else

                assert( size(obj.lb_hyp_dchol,2) == sum(obj.prob.m_t) ,...
                    'SBDOT:Q_kriging:DcholBounds_size',...
                    'For the heteroskedastic method, lb_hyp_tau must be of size 1-by-sum(m_t)');

                assert( size(obj.ub_hyp_dchol,2) == sum(obj.prob.m_t) ,...
                    'SBDOT:Q_kriging:DcholBounds_size',...
                    'For the heteroskedastic method, ub_hyp_tau must be of size 1-by-sum(m_t)');
                
                assert( all( obj.lb_hyp_dchol < obj.ub_hyp_dchol , 2),...
                'SBDOT:Q_kriging:DcholBounds',...
                'lb_hyp_dchol must be lower than ub_hyp_dchol');

                assert( all( obj.lb_hyp_dchol > 0 ),...
                'SBDOT:Q_kriging:DcholBounds',...
                'lb_hyp_dchol and ub_hyp_dchol must be positive row vectors');

                if isempty(obj.hyp_dchol_0)
                    
                    obj.hyp_dchol_0 = (obj.lb_hyp_dchol + obj.ub_hyp_dchol)/2;
                    
                else
                    
                    assert( size(obj.hyp_dchol_0,2) == size(obj.lb_hyp_dchol,2) ,...
                        'SBDOT:Q_kriging:hyp_dchol_0_size',...
                        'hyp_dchol_0 and hyp_dchol_bounds must have the same size');
                    
                    assert( all( and(obj.hyp_dchol_0<obj.ub_hyp_dchol,obj.hyp_dchol_0>obj.lb_hyp_dchol ) ), ...
                    'SBDOT:Q_kriging:hyp_dchol_0_OutBounds', ...
                    'hyp_dchol_0 must be within the range defined by HypBounds');

                end

            end
            
        else
            
            assert(size(obj.hyp_dchol,2) == sum(obj.prob.m_t), 'SBDOT:Q_kriging:hyp_dchol_wrong_size',...
            horzcat('hyp_dchol is of size ', num2str(size(obj.hyp_dchol,2)), ', and should be of size ',...
            num2str(sum(obj.prob.m_t)), ' in regard of m_t'));
        
            assert( all( obj.hyp_dchol > 0 ),...
            'SBDOT:Q_kriging:DcholBounds',...
            'hyp_dchol must be a positive row vector');
        
            if any([~isempty(obj.lb_hyp_dchol),~isempty(obj.ub_hyp_dchol),~isempty(obj.hyp_dchol_0)])
                warning('SBDOT:Q_kriging:Unused_Arg',...
                    'hyp_dchol was not set to empty and at least another component of hyp_dchol is not empty. Other hyp_dchol entries will be set to default value.');
                obj.hyp_dchol_0 = [];
                obj.lb_hyp_dchol = [];
                obj.ub_hyp_dchol = [];
            end
            
        end
        
    elseif any([~isempty(obj.hyp_dchol),~isempty(obj.lb_hyp_dchol),~isempty(obj.ub_hyp_dchol),~isempty(obj.hyp_dchol_0)])
        
        warning('SBDOT:Q_kriging:Unused_Arg',...
            'tau_type was not set to heteroskedastic and at least one component of hyp_dchol is not empty. Hyp_dchol entries will be set to default value.');
        obj.hyp_dchol = [];
        obj.hyp_dchol_0 = [];
        obj.lb_hyp_dchol = [];
        obj.ub_hyp_dchol = [];
        
    end
    

    obj = obj.Set_optim( obj.hyp_reg, obj.hyp_sigma2, obj.hyp_corr, obj.hyp_tau, obj.hyp_dchol );
    obj = obj.Fit( obj.x_train, obj.f_train );

    if obj.prob.display, fprintf(['\nKriging with ',func2str(obj.corr),' correlation function is created.\n\n']);end

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


