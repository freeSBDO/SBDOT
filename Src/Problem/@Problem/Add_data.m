function [] = Add_data( obj, x_add, y_add, g_add )
    %ADD_DATA Add input/output dataset to problem object
    %   x_add is the input matrix to add (n_x by m_x)
    %	y_add is the objective matrix to add (n_x by m_y)
    %	g_add is the constraint matrix to add (n_x by m_g)
    %
    % Syntax :
    % obj.add_rawDATA(x_add,y_add,g_add);
    % obj.add_rawDATA(x_add,y_add,[]); , if problem is unconstrained

    % Checks
    n_add = Input_assert( obj, x_add );
    obj.Output_assert( y_add, g_add);

    % Update object data
    obj.x = [ obj.x; x_add ];
    obj.y = [ obj.y; y_add ];
    obj.g = [ obj.g; g_add ];

    obj.n_x = obj.n_x + n_add;

end

