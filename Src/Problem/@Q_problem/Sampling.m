function x_sampling = Sampling( obj, num_x, type, maximin_type, n_iter, n_threshold )
    % SAMPLING Create a sampling plan per qualitative combination:
    % (if m_t = [2, 3] then it will apply @Problem.Sampling 6 times) 
    %   *num_x is the number of sampling points to create
    %   *type is the type of the sampling. Allowed list :
    %   ['LHS'], 'OLHS', 'Sobol', 'Halton'.
    %
    % Syntax :
    % obj.Sampling( num_x );
    % obj.Sampling( num_x, type );
    
    % Sample building
    if strcmpi(type, 'SLHS')
        
        x_sampling = obj.SLHS(num_x, maximin_type, n_iter, n_threshold);
        
        if obj.display
            fprintf( ['\n Sampling of ',mat2str(num_x),...
                        ' points created with @Q_problem.SLHS method.\n'] );
        end
        
    else
        
        x_sampling = cell(1,length(num_x));
    
        display_temp = obj.display;
        obj.display = false;
        
        for i = 1:length(num_x)
            x_sampling{i} = Sampling@Problem( obj, num_x(i), type );
        end

        obj.display = display_temp;

        if obj.display
            fprintf( ['\n Sampling of ',mat2str(num_x),...
                        ' points created with stk toolbox.\n'] );
        end
       
    end
    
    Temp_Idx = ind2subVect(obj.m_t,1:size(x_sampling,2));
    
    x_sampling = arrayfun(@(k) [x_sampling{k},...
        repmat(arrayfun(@(j) obj.t{j}(Temp_Idx(k,j)), 1:length(Temp_Idx(k,:))),...
        num_x(k),1)], 1:size(x_sampling,2), 'UniformOutput', false);
    
end

