function [] = Opt( obj )
% OPT 
%   Launch NSGA-II algorithm

if obj.display
    fprintf(sprintf('NSGA-II current generation : %3.0i / %3.0i',obj.n_gen,obj.max_gen))
end
while obj.n_gen <= obj.max_gen
    
    % Selection
    x_selected = obj.Selection();
    % Crossing
    x_crossed = obj.Croisement( obj.x(x_selected,:) );
    % Mutation
    x_mutation = obj.Mutation( x_crossed );
    
    % Function evaluation
    [ y_new, g_new ]=feval( obj.function_name, x_mutation );
    
    % Combine previous and new population
    obj.x = [ obj.x ; x_mutation ];
    obj.y = [ obj.y ; y_new ];
    if obj.constraint_logical
        obj.g = [ obj.g; g_new ];
    end
    
    % Sorting fronts and extract only n_pop points
    obj.Domination_sorting();
    
    % Display
    if obj.display
        fprintf(repmat('\b',1,9));
        fprintf(sprintf('%3.0i / %3.0i',obj.n_gen,obj.max_gen))
    end
    
    % Next generation
    obj.n_gen=obj.n_gen+1;
    
    % Store history
    obj.hist(obj.n_gen).x = obj.x;
    obj.hist(obj.n_gen).y = obj.y;
    if obj.constraint_logical
        obj.hist(obj.n_gen).g = obj.g;
    end
end

if obj.display, fprintf('\n');end

end

