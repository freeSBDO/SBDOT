function [] = Get_design( obj, num_x, type )
    % GET_DESIGN Create a sampling plan and evaluates it
    %   *num_x is the number of sampling points to create
    %   *type is the type of the sampling. Allowed list :
    %   ['LHS'], 'OLHS', 'Sobol', 'Halton'.
    %
    % Syntax :
    % obj.Get_design( num_x );
    % obj.Get_design( num_x, type );
    
    if nargin <= 2
        type = 'LHS';
    end
    
    % Sampling
    x_sampling = obj.Sampling( num_x, type );
    
    % Evaluation
    obj.Eval( num_x, x_sampling );

end
