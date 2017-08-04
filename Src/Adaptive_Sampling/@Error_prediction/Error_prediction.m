classdef Error_prediction < Adaptive_sampling
    %ERROR_PREDICTION Metamodel prediction error reduction algorithm
    %   Detailed explanation goes here
    
    properties
        
        meta_type
        crit_type
        error_value        
        options_optim
        
    end
    
   
    methods
        
        function obj = Error_prediction(prob, y_ind, g_ind, meta_type ,varargin)
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('meta_type',@(x)isequal(x,@Kriging)||isequal(x,@RBF)||isequal(x,@Cokriging));
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
            assert(length(y_ind)==1 || length(g_ind)==1,...
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

