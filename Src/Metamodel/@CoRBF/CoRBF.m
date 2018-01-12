classdef CoRBF < Metamodel
    % CoRBF Class
    % Radial Basis Function metamodel for multifidelity problem
    %
    % obj = CoRBF( prob, y_ind, g_ind, varargin)
    %
    % Mandatory inputs :
    %   - prob is a Problem_multifi object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %
    % Optional inputs [default value], 
    % * has to be replaced by HF or LF depending on the option applies to 
    % high fidelity model or low fidelity model :
    %
    %   'corr_*' is the correlation function to use     
    %   ['Corrmatern52'], 'Corrgauss', 'Corrlinear' , 'Corrthinplatespline' , 'Corrmultiquadric' , 'Corrcubic', 'Corrinvmultiquadric', 'Corrmatern32'
    %   'hyp_corr_*' is the correlation length parameter (if set, it is not optimized)
    %   []
    %   'rho' is the scaling factor between models (if set, it is not optimized)        
    %   []
    %   'hyp_corr0_*' is the initial correlation length for optimization
    %   [Auto calibrate with training dataset]
    %   'rho0' is the initial scaling factor for optimization        
    %   [Auto calibrate with training dataset]
    %   'lb_hyperp_*' is the lower bound of correlation length
    %   [Auto calibrate with training dataset]
    %   'ub_hyperp_*' is the upper bound of correlation length
    %   [Auto calibrate with training dataset]
    %   'lb_rho' is the lower bound of scaling factor  
    %   [Auto calibrate with training dataset]
    %   'ub_rho' is the upper bound of scaling factor       
    %   [Auto calibrate with training dataset]
    %   'estimator_*' is the method for hyperparameter estimation 
    %   ['LOO'] , 'CV'
    %   'optimizer_*' is the optimizer algorithm to select 
    %   ['CMAES'] , 'fmincon'
    %
    
    properties
        
        % Optional inputs 
        corr        % Correlation function of coRBF
        hyp_corr    % Correlation length paramete (log scale)
        lb_hyp_corr % Lower bound of correlation length
        ub_hyp_corr % Upper bound of correlation length
        rho         % Scaling factor
        lb_rho      % Lower bound of scaling factor
        ub_rho      % Upper bound of scaling factor
        hyp_corr0   % Initial correlation length for optimization
        rho0        % Initial scaling parameter for optimization
        estimator   % Method for estimating parameters
        optimizer   % Optimization method for hyperparameters
                
        % Computed variables
        RBF_c       % Low fidelity RBF (coarse)
        RBF_d       % Difference model RBF
               
    end
    
    methods
        
        function obj=CoRBF(prob,y_ind,g_ind,varargin)
            % CoRBF constructor (see also Metamodel)
            %
            % Initialized a CoRBF object with mandatory inputs :
            % 	obj=CoRBF(prob,y_ind,g_ind)
            %
            % Initialized a CoRBF object with optionnal inputs :
            % 	obj=Cokriging(prob,y_ind,g_ind,varargin)
            %   obj=Cokriging(prob,y_ind,g_ind,'regpoly','regpoly0')
            %
            % Optionnal inputs [default value], * has to be replaced by HF or LF :
            %   'corr_*'      ['Corrmatern52'], 'Corrgauss', 'Corrlinear' , 'Corrthinplatespline' , 'Corrmultiquadric' , 'Corrcubic', 'Corrinvmultiquadric', 'Corrmatern32'
            %   'hyp_corr_*'  [Auto calibrate with training dataset]
            %   'rho'         [Auto calibrate with training dataset]
            %   'hyp_corr0_*' [Auto calibrate with training dataset]
            %   'rho0'        [Auto calibrate with training dataset]
            %   'lb_hyperp_*' [Auto calibrate with training dataset]
            %   'ub_hyperp_*' [Auto calibrate with training dataset]
            %   'lb_rho'      [Auto calibrate with training dataset]
            %   'ub_rho'      [Auto calibrate with training dataset]
            %   'estimator_*'  ['LOO'] , 'CV'  
            %   'optimizer_*'  ['CMAES'] , 'fmincon' 
            
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addOptional('rho',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('rho0',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('lb_rho',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_rho',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));            
            p.addOptional('corr_LF','Corrgauss',@(x)(isa(x,'char'))&&(strcmp(x,'Corrgauss')||strcmp(x,'Corrmatern32')||strcmp(x,'Corrmatern52')||strcmp(x,'Corrlinear')||strcmp(x,'Corrthinplatespline')||strcmp(x,'Corrinvmultiquadric')||strcmp(x,'Corrmultiquadric')||strcmp(x,'Corrcubic')));
            p.addOptional('hyp_corr_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('hyp_corr0_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_corr_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_hyp_corr_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('estimator_LF','LOO',@(x)(isa(x,'char'))&&(strcmp(x,'LOO')||strcmp(x,'CV')));
            p.addOptional('optimizer_LF','CMAES',@(x)(isa(x,'char'))&&(strcmp(x,'CMAES')||strcmp(x,'fmincon')));
            
            p.addOptional('corr_HF','Corrgauss',@(x)(isa(x,'char'))&&(strcmp(x,'Corrgauss')||strcmp(x,'Corrmatern32')||strcmp(x,'Corrmatern52')||strcmp(x,'Corrlinear')||strcmp(x,'Corrthinplatespline')||strcmp(x,'Corrinvmultiquadric')||strcmp(x,'Corrmultiquadric')||strcmp(x,'Corrcubic')));
            p.addOptional('hyp_corr_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('hyp_corr0_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_corr_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_hyp_corr_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('estimator_HF','LOO',@(x)(isa(x,'char'))&&(strcmp(x,'LOO')||strcmp(x,'CV')));
            p.addOptional('optimizer_HF','CMAES',@(x)(isa(x,'char'))&&(strcmp(x,'CMAES')||strcmp(x,'fmincon')));
            p.parse(varargin{:})
            in = p.Results;
            unmatched = p.Unmatched;
            
            % Superclass constructor
            obj@Metamodel(prob,y_ind,g_ind,unmatched)
            
            % Store
            obj.corr = { in.corr_LF , in.corr_HF };
            obj.hyp_corr = {in.hyp_corr_LF , in.hyp_corr_HF};
            obj.hyp_corr0 = {in.hyp_corr0_LF , in.hyp_corr0_HF};
            obj.lb_hyp_corr = {in.lb_hyp_corr_LF , in.lb_hyp_corr_HF};
            obj.ub_hyp_corr = {in.ub_hyp_corr_LF , in.ub_hyp_corr_HF};
            obj.lb_rho = in.lb_rho;
            obj.ub_rho = in.ub_rho;
            obj.rho0 = in.rho0;
            obj.rho = in.rho;
            obj.estimator = {in.estimator_LF , in.estimator_HF};
            obj.optimizer = {in.optimizer_LF , in.optimizer_HF};
            
            % Training
            obj.Train();
            
        end
        
        [] = Clean( obj , type )
        [] = Def_hyp_corr( obj )
        [ LOO ] = Obj_diff_opt( obj, x , yc_e)
        [ y_pred, power] = Predict( obj, x_eval )
        [] = Train( obj )
        
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


