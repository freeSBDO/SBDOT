function [] = Output_assert( obj, y_eval, g_eval )
    %OUTPUT_ASSERT Check outputs after evaluation
    %   *y_eval is the matrix of output values to assert
    %
    % Syntax :
    % obj.Output_assert( y_eval );
    
    assert( size(y_eval,2) == obj.m_y, ...
        'SBDOT:Problem:dimension_output', ...
        ['The number of objectives m_y that you set is not ', ...
        'the one obtained after evaluation of the function'] )

    if ~isempty( g_eval )

        assert( size(g_eval,2) == obj.m_g, ...
            'SBDOT:Problem:dimension_constraint', ...
            ['The number of constraints m_g that you set is not ', ...
            'the one obtained after evaluation of the function'] )

    end

end

