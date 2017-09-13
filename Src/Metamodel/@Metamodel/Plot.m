function [Y_plot,X_plot] = Plot( obj, inputs_ind, cut_values )
    % PLOT Plot the metamodel using cut planes if necessary 
    %   *inputs_ind is the index of parameters to plot
    %   *cut_values is row vector with cut values to apply to other parameters, sorted by parameter index
    %
    % Syntax :
    % []=obj.plot([1 5],[0.024 0.1 0.003]);
    
    p = inputParser;
    p.KeepUnmatched=true;
    p.PartialMatching=false;
    p.addRequired('inputs_ind',@(x)isnumeric(x)&& length(x)<=2);
    p.addRequired('cut_values',@(x)isnumeric(x) && (isrow(x)||isempty(x)));
    p.parse(inputs_ind,cut_values);
    in=p.Results;
    
    inputs_ind = in.inputs_ind;
    cut_values = in.cut_values;
    
    % Checks
    assert( length(inputs_ind) + length(cut_values) == obj.prob.m_x,...
        'SBDOT:Metamodel:inputs&cuts',...
        'Inputs missing, either the number of inputs for plot or the number of cut values is not correctly specified')
    
    % Plot
    figure
    switch length(inputs_ind)
        case 1
            
            % 1D
            X_plot = linspace( obj.prob.lb(inputs_ind), ...
                obj.prob.ub(inputs_ind), 200 )';
            
            if ~isempty(cut_values)
                
                X_cut = bsxfun(@times, ones( 200, length(cut_values) ), ...
                    cut_values );
                X_test( :, inputs_ind ) = X_plot;
                X_test( :, setdiff( 1:obj.prob.m_x, inputs_ind ) ) = X_cut;
                
            else
                
                X_test = X_plot;
                
            end
            
            Y_plot = obj.Predict( X_test );
            % TODO 
            % fill ([X_plot;flipud(X_plot)],[mean+1.96var;flipud],'k','FaceAlpha',0.3,'EdgeColor','none')
            
            plot( X_plot, Y_plot, 'k-');
            
            hold on
            xlabel(['Parameter ',num2str(inputs_ind(1))])
            ylabel('Response surface')
            
        case 2
            
            %2D
            [ X_plot1, X_plot2 ] = meshgrid( ...
                linspace( obj.prob.lb( inputs_ind(1) ),...
                    obj.prob.ub( inputs_ind(1) ), 200), ...
                linspace( obj.prob.lb( inputs_ind(2) ), ...
                    obj.prob.ub( inputs_ind(2) ), 200) );
                                            
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
            
            Y_plot = obj.Predict( X_test );
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

