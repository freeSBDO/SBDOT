function x_sampling = Sampling( obj, num_x, type )
    % SAMPLING Create a sampling plan per qualitative combination:
    % (if m_t = [2, 3] then it will apply @Problem.Sampling 6 times) 
    %   *num_x is the number of sampling points to create
    %   *type is the type of the sampling. Allowed list :
    %   ['LHS'], 'OLHS', 'Sobol', 'Halton'.
    %
    % Syntax :
    % obj.Sampling( num_x );
    % obj.Sampling( num_x, type );
    
    % Checks
    validateattributes( num_x, {'numeric'}, {'nonempty','row','integer','positive'})
    
    assert( or(size(num_x,2) == 1, size(num_x,2) == prod(obj.m_t)),...
        'SBDOT:Q_problem:t_argument',...
        'num_x shall either be of length equal to 1 or the number of qualitative combination')
    
    if size(num_x,2) == 1
        num_x = num_x*ones(1,prod(obj.m_t));
    end
    
    display_temp = obj.display;
    
    % Sample building
    x_sampling = cell(1,length(num_x));
    
    obj.display = false;
    
    for i = 1:length(num_x)
        x_sampling{i} = Sampling@Problem( obj, num_x(i), type );
    end
    
    obj.display = display_temp;
    
    if obj.display
        fprintf( ['\n Sampling of ',mat2str(num_x),...
                    ' points created with stk toolbox.\n'] );
    end
                
    Temp_Idx = ind2subVect(obj.m_t,1:size(x_sampling,2));
    
    x_sampling = arrayfun(@(k) [x_sampling{k},...
        repmat(arrayfun(@(j) obj.t{j}(Temp_Idx(k,j)), 1:length(Temp_Idx(k,:))),...
        num_x(k),1)], 1:size(x_sampling,2), 'UniformOutput', false);
    
end

