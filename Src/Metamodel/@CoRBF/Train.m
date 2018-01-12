function [] = Train( obj )
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

% Superclass method
obj.Train@Metamodel();

if obj.prob.display, fprintf('\nTraining starting...');end

% Train LF model
obj.RBF_c = RBF(obj.prob.prob_LF, obj.y_ind, obj.g_ind, ...
    'corr', obj.corr{1} ,'hyp_corr', obj.hyp_corr{1}, 'lb_hyp_corr', obj.lb_hyp_corr{1}, ...
    'ub_hyp_corr', obj.ub_hyp_corr{1}, ...
    'estimator', obj.estimator{1}, 'optimizer', obj.optimizer{1});

% Get prediction on HF datapoints
yc_e = obj.RBF_c.Predict(obj.prob.prob_HF.x);

% Hyperparameters settings and optimization of difference model
if isempty(obj.hyp_corr{2}) || isempty(obj.rho)
    
    obj.Def_hyp_corr(); % Auto calibrate with training dataset if needed
    
    if isempty(obj.hyp_corr{2}) && isempty(obj.rho)
        
        LBounds = [obj.lb_rho obj.lb_hyp_corr{2}];
        UBounds = [obj.ub_rho obj.ub_hyp_corr{2}];
        x0 = [obj.rho0 obj.hyp_corr0{2}];
        
    elseif isempty(obj.hyp_corr{2}) && ~isempty(obj.rho)
        
        LBounds = obj.lb_hyp_corr{2};
        UBounds = obj.ub_hyp_corr{2};
        x0 = obj.hyp_corr0{2};
        
    elseif ~isempty(obj.hyp_corr{2}) && isempty(obj.rho)
        
        LBounds = obj.lb_rho;
        UBounds = obj.ub_rho;
        x0 = obj.rho0;
        
    end
    
    switch obj.optimizer{2}
        
        case 'CMAES'
            
            opt.LBounds = LBounds;
            opt.UBounds = UBounds;
            opt.TolX = 1e-4;
            opt.Restarts = 2;
            opt.IncPopSize = 2;
            opt.TolFun = 1e-4;
            opt.DispModulo = 0;
            
            hyp_opt_temp = cmaes( @obj.Obj_diff_opt, x0, [], opt, yc_e);
            
        case 'fmincon'
            
            opt.Display = 'off';
            opt.UseParallel = false;
            
            hyp_opt_temp = fmincon( @(x)obj.Obj_diff_opt(x,yc_e), x0, ...
                [], [], [], [] , LBounds, UBounds, [], opt );
            
    end
    
    if isempty(obj.hyp_corr{2})
        obj.hyp_corr{2} = hyp_opt_temp(2:end);
    end
    if isempty(obj.rho)
    obj.rho = hyp_opt_temp(1);
    end
    
end

% Build difference model from previous hyperparameters obtained
obj.RBF_d = RBF(obj.prob.prob_HF, obj.y_ind, obj.g_ind, ...
    'corr', obj.corr{2} ,'hyp_corr', obj.hyp_corr{2}, ...
    'shift_output',[ones(size(yc_e,1),1) -obj.rho*yc_e]);

if obj.prob.display, fprintf(['\nRBF with ',obj.corr{2}(5:end),' HF correlation function is created.\n\n']);end

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


