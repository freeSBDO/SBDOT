function [ x_mutated ] = Mutation( obj, x_crossed )
% MUTATION 
%   Mutate parameters values using gaussian mutation

mutation_flag = rand( obj.n_pop, obj.n_var ); % rand for mutation selection

% Estimate mutation value
scale_mutation_new = obj.scale_mutation - ...
    obj.shrink_mutation * obj.scale_mutation * obj.n_gen / obj.max_gen;

mutation_val = scale_mutation_new .* (obj.ub - obj.lb);

% Mutation
x_mutated = x_crossed + ...
    ( mutation_flag < obj.fraction_mutation ) .* ...
    bsxfun( @times, randn( obj.n_pop, obj.n_var ), mutation_val );

% Keep parameters into bounds
A = bsxfun( @lt, x_mutated, obj.lb );
B = bsxfun( @gt, x_mutated, obj.ub );

x_mutated = x_mutated .* (~A & ~B) + ...
    bsxfun( @times, A, obj.lb ) + bsxfun( @times, B, obj.ub );

end

