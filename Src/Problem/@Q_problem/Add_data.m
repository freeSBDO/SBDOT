function [] = Add_data( obj, x_add, y_add, g_add, n_add )
    %ADD_DATA Add input/output dataset to problem object
    %   x_add is the input cell of matrix to add (n_x by m_x)
    %	y_add is the objective cell of matrix to add (n_x by 1)
    %	g_add is empty as Q_problems are unconstrained
    %   n_add is the number of input points per qualitative combination
    %
    % Syntax :
    % obj.Add_data(x_add,y_add,n_add); , as Q_problem is unconstrained

    % Checks
    obj.Input_assert( x_add );
    obj.Output_assert( y_add, g_add);

    temp_idx = ind2subVect(obj.m_t,1:prod(obj.m_t));
    temp_idx = arrayfun(@(k) repmat(arrayfun(@(j) obj.t{j}(temp_idx(k,j)), 1:length(temp_idx(k,:))),...
        n_add(k),1), 1:prod(obj.m_t), 'UniformOutput', false);
    temp_idx = cell2mat(temp_idx');
    
    assert( isequal(x_add(:,(obj.m_x+1):end), temp_idx), ...
        'SBDOT:Q_problem:wrong_data_format_for_adding', ...
        ['Data entry, via eval function, shall respect consistence between num_x and x_eval, ',...
        'and also respect the order of indexation of qualitave subscipts, as it can be seen ',...
        'by calling: ind2subVect(obj.m_t,1:prod(obj.m_t)); with obj your Q_problem object.']); 
    
    % Update object data
    temp = cumsum( n_add );
    temp = [ [1, temp(1:(end-1))+1]; temp ];
    
    if or(isempty(obj.x), isempty(obj.y))
            obj.x = cell(1,prod(obj.m_t));
            obj.y = cell(1,prod(obj.m_t));
            if obj.m_g >0
                obj.g = cell(1,prod(obj.m_t));
            end
    end
    
    ind_temp = 1:length(temp);
    ind_temp = ind_temp(n_add~=0);
    
    obj.x(ind_temp) = arrayfun(@(k) [obj.x{k}; x_add(temp(1,k):temp(2,k),:)],...
        ind_temp,'UniformOutput',false);
    obj.y(ind_temp) = arrayfun(@(k) [obj.y{k}; y_add(temp(1,k):temp(2,k),:)],...
        ind_temp,'UniformOutput',false);
    
    if obj.m_g >0
        obj.g(ind_temp) = arrayfun(@(k) [obj.g{k}; g_add(temp(1,k):temp(2,k),:)],...
            ind_temp,'UniformOutput',false);
    end
    
    obj.n_x = obj.n_x + n_add;

end

