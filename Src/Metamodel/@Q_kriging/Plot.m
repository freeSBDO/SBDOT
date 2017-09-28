function [] = Plot( obj, inputs_ind, cut_values, comb_ind, n_eval )
    % PLOT Plot the metamodel using cut planes if necessary 
    %   *inputs_ind is the index of parameters to plot
    %   *cut_values is row vector with cut values to apply to other parameters, sorted by parameter index
    %   *comb_ind is either the index or the row subscript indicating the combination of categorical levels desired for the plot
    %
    % Syntax :
    % []=obj.Plot([1 5],[0.024 0.1 0.003],[2 3 2]);
    
    p = inputParser;
    p.KeepUnmatched=true;
    p.PartialMatching=false;
    p.addRequired('inputs_ind',@(x)isnumeric(x)&& length(x)<=2);
    p.addRequired('cut_values',@(x)isnumeric(x) && (isrow(x)||isempty(x)));
    p.addRequired('comb_ind',@(x)isnumeric(x));
    p.addOptional('n_eval',[],@(x)isnumeric(x) && (isscalar(x)||isempty(x)) );
    p.parse(inputs_ind,cut_values,comb_ind);
    in=p.Results;
    
    inputs_ind = in.inputs_ind;
    cut_values = in.cut_values;
    comb_ind = in.comb_ind;
    n_eval = in.n_eval;
    
    % Checks
    assert( length(inputs_ind) + length(cut_values) == obj.prob.m_x,...
        'SBDOT:Q_kriging.Plot:inputs&cuts',...
        'Inputs missing, either the number of inputs for plot or the number of cut values is not correctly specified')

    validateattributes(comb_ind,{'numeric'},{'nonempty','2d','positive'});
    comb_ind = uint8(comb_ind);
    if size(comb_ind,2) == 1
        
        assert( all ( comb_ind <= prod(obj.prob.m_t) ),...
            'SBDOT:Q_kriging.Predict:Wrong_comb_ind_Index', ...
            'Index for qualitative evaluation shall be positive integer column lower than prod(m_t)');        
    
    else
        
        assert( size(comb_ind, 2) == length(obj.prob.m_t),...
            'SBDOT:Q_kriging.Predict:Wrong_comb_ind_Size',...
            'comb_ind shall either be a single index of or a row of subsctips of size length(m_t)');
        
        
        assert( all ( comb_ind <= obj.prob.m_t ),...
            'SBDOT:Q_kriging.Predict:Wrong_comb_ind_Subscript', ...
            'comb_ind subscripts shall be within the number of levels in m_t');
        
    end 
    
    % Plot
    figure
    switch length(inputs_ind)
        case 1
            
            % 1D
            
            if isempty(n_eval)
                n_eval = 1000;
            end
            
            X_plot = linspace( obj.prob.lb(inputs_ind), ...
                obj.prob.ub(inputs_ind), n_eval )';
            
            if ~isempty(cut_values)
                
                X_cut = bsxfun(@times, ones( n_eval, length(cut_values) ), ...
                    cut_values );
                X_test( :, inputs_ind ) = X_plot;
                X_test( :, setdiff( 1:obj.prob.m_x, inputs_ind ) ) = X_cut;
                
            else
                
                X_test = X_plot;
                
            end
            
            Y_plot = obj.Predict( X_test, repmat(comb_ind, size(X_test,1), 1) );
            
            plot( X_plot, Y_plot, 'k-');
            
            hold on
            xlabel(['Parameter ',num2str(inputs_ind(1))])
            ylabel('Response surface')
            
        case 2
            
            if isempty(n_eval)
                n_eval = 100;
            end
            
            %2D
            [ X_plot1, X_plot2 ] = meshgrid( ...
                linspace( obj.prob.lb( inputs_ind(1) ),...
                    obj.prob.ub( inputs_ind(1) ), n_eval), ...
                linspace( obj.prob.lb( inputs_ind(2) ), ...
                    obj.prob.ub( inputs_ind(2) ), n_eval) );
                                            
            X_plot = [ reshape( X_plot1, size( X_plot1, 1)^2, 1)...
                reshape( X_plot2, size( X_plot2, 1 )^2, 1) ];
            
            reshape_size = size(X_plot1);
            
            if ~isempty(cut_values)
                
                X_cut = bsxfun( @times, ...
                    ones( size( X_plot1, 1 )^2, length(cut_values) ),...
                    cut_values );
                
                X_test(:, inputs_ind) = X_plot;
                X_test( :, setdiff( 1:obj.prob.m_x, inputs_ind ) ) = X_cut;
                
            else
                
                X_test = X_plot;
                
            end
            
            Y_plot = obj.Predict( X_test, repmat(comb_ind, size(X_test,1), 1) );
            surf( X_plot1, X_plot2, reshape( Y_plot, reshape_size ), ...
                'EdgeColor','none');
            colorbar
            hold on
            xlabel(['Parameter ',num2str( inputs_ind(1) )])
            ylabel(['Parameter ',num2str( inputs_ind(2) )])
            zlabel('Response surface')
            
        otherwise
            
            error('SBDOT:Metamodel:plot_input',...
                'The number of inputs for plot is too high, 2 is the maximum but you can plot a cut plane of your input space')
    end
    
    hold off
    
end

