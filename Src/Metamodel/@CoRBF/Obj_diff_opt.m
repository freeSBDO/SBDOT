function [ LOO ] = Obj_diff_opt( obj, x , yc_e)
% OBJ_DIFF_OPT 
%   Objective function for hyperperarameter optimization of difference model
%   - x are the hyperparameters (hyp_corr and/or rho)
%   - yc_e are the prediction values of LF model at HF datapoints 

% Extract hyp_corr and rho
if isempty(obj.hyp_corr{2}) && isempty(obj.rho) 
    hyp_corr_temp = x(2:end);   
    rho_temp = x(1);
elseif isempty(obj.hyp_corr{2}) && ~isempty(obj.rho) 
    hyp_corr_temp = x;
    rho_temp = obj.rho;
elseif ~isempty(obj.hyp_corr{2}) && isempty(obj.rho)
    hyp_corr_temp = obj.hyp_corr{2};
    rho_temp = x;
end

% Create difference model with hyperparameters
RBF_d_temp = RBF(obj.prob.prob_HF, obj.y_ind, obj.g_ind, ...
    'corr', obj.corr{2} ,'hyp_corr', hyp_corr_temp, 'lb_hyp_corr', obj.lb_hyp_corr{2}, ...
    'ub_hyp_corr', obj.ub_hyp_corr{2}, ...
    'estimator', obj.estimator{2}, 'optimizer', obj.optimizer{2}, ...
    'shift_output',[ones(size(yc_e,1),1) -rho_temp*yc_e]);

% Extract LOO value of this model
LOO = RBF_d_temp.Loo_error(log10(hyp_corr_temp));

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


