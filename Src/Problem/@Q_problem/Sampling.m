function x_sampling = Sampling( obj, num_x, type, maximin_type, n_iter, n_threshold )
    % Sampling contructs the desired design of experiments for qualitative
    % problems
    %
    %   Inputs:
    %       obj the object of class Q_problem
    %       num_x the number of points per slices (should be the same)
    %       type (optional) the type of design desired
    %       [default = 'SLHS', 'LHS', 'OLHS', 'Halton', 'Sobol']
    %       maximin_type (optional) select the optimization method
    %       [default = 'Threshold', 'Monte_Carlo']
    %       n_iter (optional) number of iterations (Monte_Carlo or Threshold)
    %       n_threshold (optional) number of thresholds (Threshold)
    %
    %   Output:
    %       x_sampling the design
    %
    % Syntax :
    % x_sampling = Sampling( obj, num_x );
    % x_sampling = Sampling( obj, num_x, ''Monte_Carlo', n_iter );
    % x_sampling = Sampling( obj, num_x, 'Threshold', n_iter, n_threshold  );
    
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

