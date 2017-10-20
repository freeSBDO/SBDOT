function x_sampling = Sampling( obj, num_x, type )
    % SAMPLING Create a sampling plan
    %   *num_x is the number of sampling points to create
    %   *type is the type of the sampling. Allowed list :
    %   ['LHS'], 'Sobol', 'Halton'.
    %   *x_sampling is the input matrix num_x-by-m_x.
    %
    % Syntax :
    % obj.Sampling( num_x );
    % obj.Sampling( num_x, type );
    
    % 2017/10/20 : 'OLHS' option not implemented thus suppressed from help
    % and error message (agl)

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

            x_temp = stk_sampling_halton_rr2( num_x, obj.m_x );
            x_sampling = x_temp.data;
            x_sampling = Unscale_data( x_sampling, obj.lb, obj.ub);
            
            if obj.display
                fprintf( ['\n Halton sampling of ',num2str(num_x),...
                    ' points created with stk toolbox.\n'] );
            end            

        otherwise

            error( 'SBDOT:Sampling:type',...
                ['The type of sampling you specified is not correct, ',...
                'choose between ''LHS'', ''Sobol'' and ''Halton''.'] )

    end

end

