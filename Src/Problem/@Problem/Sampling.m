function [ ] = Sampling( obj, num_x, type )
    % SAMPLING Create a sampling plan and evaluates it
    %   *num_x is the number of sampling points to create
    %   *type is the type of the sampling. Allowed list :
    %   ['LHS'], 'OLHS', 'Sobol', 'Halton'.
    %
    % Syntax :
    % obj.LHS_sampling( num_x );
    % obj.LHS_sampling( num_x, type );

    % Checks
    validateattributes( num_x, {'numeric'}, {'nonempty','scalar','integer','positive'} )
    if nargin <= 2
        type = 'LHS';
    end

    % Sample building
    switch type

        case 'LHS' % Latin Hypercube Maximin Optimized
            % LH from Lib/stk toolbox is used

            x_temp = stk_sampling_maximinlhs( num_x, obj.m_x, [obj.lb; obj.ub], 500 );
            x_sampling = x_temp.data;
            
            if obj.display
                fprintf( ['\n LH maximin sampling of ',num2str(num_x),...
                    ' points created with stk toolbox.\n'] );
            end

        case 'OLHS' % Orthogonal Latin Hypercube
            % OLHS from Lib/stk toolbox is used

            x_temp = stk_sampling_olhs( num_x, obj.m_x, [obj.lb; obj.ub] );
            x_sampling = x_temp.data;
            
            if obj.display
                fprintf( ['\n OLH sampling of ',num2str(num_x),...
                    ' points created with stk toolbox.\n'] );
            end          

        case 'Sobol' % Sobol sequence
            % Sobol from Lib/stk toolbox is used
            
            x_temp = stk_sampling_sobol( num_x, obj.m_x, [obj.lb; obj.ub], true );
            x_sampling = x_temp.data;

            if obj.display
                fprintf( ['\n Sobol sampling of ',num2str(num_x),...
                    ' points created with stk toolbox.\n'] );
            end
            
        case 'Halton' % Halton sequence
            % Halton from Lib/stk toolbox is used

            x_temp = stk_sampling_halton_rr2( num_x, obj.m_x, [obj.lb; obj.ub], true );
            x_sampling = x_temp.data;
            
            if obj.display
                fprintf( ['\n Halton sampling of ',num2str(num_x),...
                    ' points created with stk toolbox.\n'] );
            end            

        otherwise

            error( 'SBDOT:Sampling:type',...
                ['The type of sampling you specified is not correct, ',...
                'choose between ''LHS'', ''OLHS'', ''Sobol'' and ''Halton''.'] )

    end

    % Sample evaluation
    obj.Eval( x_sampling );

end

