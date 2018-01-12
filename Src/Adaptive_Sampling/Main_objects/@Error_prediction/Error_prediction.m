classdef Error_prediction < Adaptive_sampling
    %ERROR_PREDICTION 
    % Metamodel prediction error reduction algorithm
    %
    % obj = Error_prediction(prob, y_ind, g_ind, meta_type, varargin)
    %
    % Mandatory inputs :
    %   - prob is a Problem/Problem_multifi object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %   - meta_type is the type of metamodel to use (@Kriging or @Cokriging)
    %
    % Optional inputs [default value]:
    %   - 'crit_type' criterion for optimization.
    %   ['MSE'], 'IMSE'(kriging only)
    %   - 'options_optim' is a structure for optimization of EI criterion
    %   see Set_options_optim for example of parameters structure
    %   * Optional inputs for Kriging or Cokriging or RBF or CoRBF apply
    %   * Optional inputs for Adaptive_sampling apply
    
    properties
        
        % Mandatory inputs
        meta_type      % Type of metamodel 
        
        % Optional inputs
        crit_type      % Error optimization criterion 
        options_optim  % Structure of user optimization options
        
        % Computed variables        
        error_value    % criterion value        
        
    end
    
   
    methods
        
        function obj = Error_prediction(prob, y_ind, g_ind, meta_type ,varargin)
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('meta_type',@(x)isequal(x,@Kriging)||isequal(x,@RBF)||isequal(x,@Cokriging)||isequal(x,@CoRBF));
            p.addOptional('crit_type','MSE',@(x)(isa(x,'char'))&&(strcmpi(x,'MSE')||strcmpi(x,'IMSE')));
            p.addOptional('options_optim',[],@(x)isstruct(x));
            p.parse(meta_type,varargin{:})
            in = p.Results;
            unmatched = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            unmatched = unmatched';
            
            % Superclass constructor
            obj@Adaptive_sampling(prob,y_ind,g_ind,unmatched{:});
            
            % Store
            obj.crit_type = in.crit_type;
            obj.options_optim = in.options_optim;
            obj.meta_type = in.meta_type;
            
            % Checks
            assert( obj.m_y == 1 || obj.m_g == 1,...
                'SBDOT:Error_prediction:y_index',...
                'Only one output can be used in Error_prediction');
            
            % Set optimization options
            obj.Set_options_optim( obj.options_optim )
            
            % Train metamodel
            if obj.m_y >=1
                for i=1:obj.m_y
                    metamodel_int_y(i,:) = ...
                        obj.meta_type(obj.prob, obj.y_ind(i), [], obj.unmatched_params{:});
                end
                obj.meta_y = metamodel_int_y;
            end
            
            if obj.m_g >=1
                for i=1:obj.m_g
                    metamodel_int_g(i,:) = ...
                        obj.meta_type(obj.prob, [], obj.g_ind(i), obj.unmatched_params{:});
                end
                obj.meta_g = metamodel_int_g;
            end        
                        
            % Launch optimization sequence
            obj.Opt();            
            
        end
        
        [] = Set_options_optim( obj, user_opt )
        [] = Conv_check_crit( obj )        
        [] = Opt_crit( obj )
        [ error_value ] = Error_crit( obj , x )
        [ func_val ] = Meta_int1( obj, x )
        [ func_val ] = Meta_int2( obj, x, y )
        [ func_val ] = Meta_int3( obj, x, y, z)
                
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


