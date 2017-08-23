classdef NSGA_2 < handle
    % NSGA_2 
    % Nondominated Sorting Genetic Algorithm II
    % For contrained and unconstrained problems
    
    properties
        function_name       % String or function handle for numerical model evaluation
        lb                  % dimension of the input space (scalar value, positive integer)
        ub                  % number of objectives (scalar value, positive integer)        
        n_pop               % population number(=100 by default)
        max_gen             % maximal number of generations (=100 by default)
        fraction_croisement % probability of crossing (=2/n_var by default)
        ratio_croisement    % parameter for crossing (=1.2 by default)
        fraction_mutation   % probability of mutation (=2/n_var by default)
        scale_mutation      % scale parameter of mutation (=0.1 by default)
        shrink_mutation     % deviation of gaussian mutation (=0.5 by default)
        display             % display informations (=0 by default)
        n_var               % number of parameters of objective function
        
        n_gen             % Actual generation number
        crowding_distance % Crowding distance of individuals
        rank_pop          % Front rank of individuals
        
        x                  % resulting input
        y                  % resulting output
        g                  % resulting constraint
        constraint_logical % Logical value if optimization is constrained
        hist               % population history during optimization
    end
    
    methods
        
        function obj = NSGA_2( function_name, lb, ub, n_var, varargin)
            p = inputParser;
            p.KeepUnmatched=true;
            p.PartialMatching=false;
            p.addRequired('function_name',@(x)validateattributes(x,{'function_handle','char'},{'nonempty'}))
            p.addRequired('lb',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addRequired('ub',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addRequired('n_var',@(x)validateattributes(x,{'numeric'},{'nonempty','scalar'}))
            p.addOptional('n_pop',100,@(x)validateattributes(x,{'numeric'},{'even'}));
            p.addOptional('max_gen',100,@isnumeric);
            p.addOptional('fraction_croisement',1/n_var,@isnumeric);
            p.addOptional('ratio_croisement',1.2,@isnumeric);
            p.addOptional('fraction_mutation',1/n_var,@isnumeric);
            p.addOptional('scale_mutation',0.1,@isnumeric);
            p.addOptional('shrink_mutation',0.5,@isnumeric);
            p.addOptional('display',false,@islogical);
            p.parse(function_name,lb,ub,n_var,varargin{:})
            in=p.Results;
            
            obj.function_name=in.function_name;
            obj.lb=in.lb;
            obj.ub=in.ub;
            obj.n_pop=in.n_pop;
            obj.max_gen=in.max_gen;
            obj.fraction_croisement=in.fraction_croisement;
            obj.ratio_croisement=in.ratio_croisement;
            obj.fraction_mutation=in.fraction_mutation;
            obj.scale_mutation=in.scale_mutation;
            obj.shrink_mutation=in.shrink_mutation;
            obj.display=in.display;
            obj.n_var=in.n_var;
            
            %% Initialization
            
            % First population
            x_temp = stk_sampling_maximinlhs( obj.n_pop, obj.n_var, [obj.lb; obj.ub], 500 );            
            obj.x = x_temp.data;
            
            obj.n_gen=1;
            
            % Function evaluation
            [ obj.y, obj.g ] = feval( obj.function_name, obj.x );
            
            if isempty(obj.g)
                obj.constraint_logical = false;
            else
                obj.constraint_logical = true;
            end
            
            % Sorting fronts            
            obj.Domination_sorting();
            
            obj.hist(1).x = obj.x;
            obj.hist(1).y = obj.y;
            if obj.constraint_logical
                obj.hist(1).g = obj.g;
            end
            
            obj.Opt();
            
        end
        
        [] = Opt(obj);
        [] = Restart(obj, iter_sup);
        
        [] = Domination_sorting(obj);
        [ x_selected ] = Selection(obj);
        [ x_crossed ] = Croisement(obj, x_selected);
        [ x_mutated ] = Mutation(obj, x_crossed);
        
        [ int_Front_population, int_rank_pop ] = Fast_non_dominated_sort(obj, y, pop_number);
        [ Front_population ] = Crowding_distance_sorting(obj, int_Front_population, int_rank_pop);
        [ crowding_distance ] = Crowding_distance_assignement(obj, I, y);        
        
    end
    
end

