function [ ] = Sampling( obj, num_x_LF, num_x_HF, type )
    % SAMPLING Create a sampling plan and evaluates it
    %   *num_x_LF is the number of sampling points to create of LF problem
    %   *num_x_HF is the number of sampling points to create of HF problem
    %   *type is the type of the sampling. Allowed list :
    %   ['Nested'], 'LHS'.
    %
    % Syntax :
    % obj.LHS_sampling( num_x );
    % obj.LHS_sampling( num_x, type );

    % Checks
    validateattributes( num_x_LF, {'numeric'}, {'nonempty','scalar','positive'} )
    validateattributes( num_x_HF, {'numeric'}, {'nonempty','scalar','positive'} )
    if nargin <= 3
        type = 'Nested';
    end

    % Sample building
    
    x_temp1 = stk_sampling_maximinlhs( num_x_LF, obj.prob_HF.m_x, [obj.prob_HF.lb; obj.prob_HF.ub], 500 );
    x_LF_sampling = x_temp1.data;
    
    x_temp2 = stk_sampling_maximinlhs( num_x_HF, obj.prob_HF.m_x, [obj.prob_HF.lb; obj.prob_HF.ub], 500 );
    x_HF_sampling = x_temp2.data;    
    
    switch type

        case 'LHS' % Latin Hypercube Maximin Optimized
            % LH from Lib/stk toolbox is used    
            
            if obj.display
                fprintf( ['\nLHS sampling of ',num2str(num_x_LF),...
                    ' LF points and ',num2str(num_x_HF),...
                    ' HF points created with stk toolbox.\n'] );
            end            

        case 'Nested' % Orthogonal Latin Hypercube
            % OLHS from Lib/stk toolbox is used
            
            %TODO :
            [~, I] = pdist2( x_LF_sampling, x_HF_sampling, ...
                'euclidean', 'Smallest', 1 );
            
            x_LF_sampling( I', :) = [];
            
            x_LF_sampling = [ x_LF_sampling; x_HF_sampling ];

            if obj.display
                fprintf( ['\nNested sampling of ',num2str(num_x_LF),...
                    ' LF points and ',num2str(num_x_HF),...
                    ' HF points created with stk toolbox.\n'] );
            end
        
        otherwise

            error( 'SBDOT:Sampling_multifi:type',...
                ['The type of sampling you specified is not correct, ',...
                'choose between ''LHS'' and ''Nested''.'] )

    end

    % Sample evaluation
    obj.Eval( x_LF_sampling, 'LF' );
    obj.Eval( x_HF_sampling, 'HF' );

end

