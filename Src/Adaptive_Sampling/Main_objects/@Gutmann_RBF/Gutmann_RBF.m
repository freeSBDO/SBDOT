classdef Gutmann_RBF < Adaptive_sampling
    % GUTMANN_RBF 
    % Gutmann optimization algorithm with RBF
    % Single objective RBF (or co-RBF) based optimization method.
    % unconstrained or constrained problems.
    % 
    % obj = Gutmann_RBF(prob, y_ind, g_ind, meta_type, varargin)
    %    
    % Mandatory inputs :
    %   - problem is a Problem/Problem_multifi object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %   - meta_type is the type of metamodel to use (@RBF or @CoRBF)
    %
    % Optional inputs [default value]:
    %   - 'cycle_length' parameter for the trade-off between exploration and explotation 
    %   [5]
    %   - 'options_optim' is a structure for optimization of Gutmann criterion
    %   see Set_options_optim for example of parameters structure
    %   * Optional inputs for RBF or CoRBF apply
    %   * Optional inputs for Adaptive_sampling apply
    %
    
    properties
        
        % Mandatory inputs
        meta_type      % Type of metamodel 
        
        % Optional inputs
        options_optim  % Structure of user optimization options
        cycle_length   % Cycle length for W_n
        
        % Computed variables        
        n0             % Number of initial points in the DOE
        k_n            % Used in min target computation
        gutmann_val    % Optimization criterion value at current iteration
        
    end
    
    methods
        
        function obj = Gutmann_RBF(prob, y_ind, g_ind, meta_type ,varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('meta_type',@(x)isequal(x,@RBF)||isequal(x,@CoRBF));
            p.addOptional('options_optim',[],@(x)isstruct(x));
            p.addOptional('cycle_length',5,@(x)isnumeric(x));
            p.parse(meta_type,varargin{:})
            in = p.Results;
            unmatched = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            unmatched = unmatched';
            
            % Superclass constructor
            obj@Adaptive_sampling(prob,y_ind,g_ind,unmatched{:});
            
            % Store
            obj.options_optim = in.options_optim;
            obj.meta_type = in.meta_type;
            obj.cycle_length = in.cycle_length;
            
            % Checks
            assert( obj.m_y == 1,...
                'SBDOT:Error_prediction:y_index',...
                'Only one objective can be used in Gutmann_RBF');
            
            % Set optimization options
            obj.Set_options_optim( obj.options_optim );
            if isa( obj.prob, 'Problem' )
                obj.n0 = obj.prob.n_x;
            else
                obj.n0 = obj.prob.prob_HF.n_x;
            end
            
            % Train metamodel
            metamodel_int_y = ...
                obj.meta_type(obj.prob, obj.y_ind, [], obj.unmatched_params{:});
            
            obj.meta_y = metamodel_int_y;
            
            
            if obj.m_g >= 1
                for i = 1 : obj.m_g
                    metamodel_int_g(i,:) = ...
                        obj.meta_type(obj.prob, [], obj.g_ind(i), obj.unmatched_params{:});
                end
                obj.meta_g = metamodel_int_g;
            end
                       
        end
        
        [] = Set_options_optim( obj, user_opt );
        [] = Conv_check_crit( obj );    
        [] = Opt_crit( obj );
        [] = Find_min_value( obj );
        [ y_pred ] = Prediction( obj, x );
        [ crit ] = Gutmann_crit( obj, x, min_target );
        
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


