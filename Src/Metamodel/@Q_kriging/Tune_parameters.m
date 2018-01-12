function [obj, optimHp, perf] = Tune_parameters( obj, F )
    % TUNE_PARAMETERS optimized the value of the log-likelihhod to tune
    % hyperparameters
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       F is the regression matrix
    %
    %   Output:
    %       obj is the updated input obj
    %       optimHP are the optimal values of hyperparameters
    %       perf is the optimal value of the log-likelihood
    %
    % Syntax :
    % [obj, optimHp, perf] = Tune_parameters( obj, F );
    
    func = @(optimParam) Likelihood( obj, F, optimParam );

    allParam = {obj.hyp_reg_0, obj.hyp_sigma2_0, obj.hyp_corr_0, obj.hyp_tau_0, obj.hyp_dchol_0};
    
    for i = 1:length(allParam)
        
        if size(allParam{i},2)>1
            
            allParam{i} = allParam{i}';
            
        end
        
    end
    
    allBounds = {[obj.lb_hyp_reg;obj.ub_hyp_reg],...
                 [obj.lb_hyp_sigma2;obj.ub_hyp_sigma2],...
                 [obj.lb_hyp_corr;obj.ub_hyp_corr],...
                 [obj.lb_hyp_tau;obj.ub_hyp_tau],...
                 [obj.lb_hyp_dchol;obj.ub_hyp_dchol]};

    % select only variables and bounds of variables that we optimize
    initialPopulation = cell2mat(allParam(:,obj.optim_idx)');
    bounds = cell2mat(allBounds(:,obj.optim_idx))';

    % Optimize
    
    opts.LBounds = bounds(:,1); opts.UBounds = bounds(:,2);
    
    if strcmp(obj.optim_method, 'cmaes')
        
        [optimHp, perf] = cmaes(func, initialPopulation, [], opts);
        
    else
        
        options = optimoptions('fmincon','Display','none','Algorithm',obj.optim_method);
        [optimHp, perf] = fmincon(func, initialPopulation', [], [], [], [], opts.LBounds', opts.UBounds', [], options);
        
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


