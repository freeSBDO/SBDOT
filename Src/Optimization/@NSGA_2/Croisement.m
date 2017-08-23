function [ x_crossed ] = Croisement( obj, x_selected )
% CROISEMENT
% Crossing parameters values

param_pop1 = x_selected( 1:2:obj.n_pop, : ); % parent 1
param_pop2 = x_selected( 2:2:obj.n_pop, : ); % parent 2

croisement_flag = rand( obj.n_pop/2, obj.n_var ); % rand for crossing selection
randNum = rand( obj.n_pop/2,obj.n_var ); % rand to change the parents

param_pop1_croisement = param_pop1 + ...
    ( croisement_flag < obj.fraction_croisement ) .* randNum.* ...
    obj.ratio_croisement .* ( param_pop1 - param_pop2 );
param_pop2_croisement = param_pop2 -...
    ( croisement_flag < obj.fraction_croisement ) .* randNum .* ...
    obj.ratio_croisement .* ( param_pop1 - param_pop2 );

x_crossed = [ param_pop1_croisement ; param_pop2_croisement ]; % childrens

% Keep parameters into bounds
A = bsxfun( @lt, x_crossed, obj.lb );
B = bsxfun( @gt, x_crossed, obj.ub );

x_crossed = x_crossed .* (~A & ~B) + ...
    bsxfun( @times, A, obj.lb ) + bsxfun( @times, B, obj.ub );


end

