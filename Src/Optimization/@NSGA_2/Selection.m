function [ x_selected ] = Selection( obj )
% SELECTION 
% Binary tournament selection

randnum = ceil( obj.n_pop .* rand( 2 * obj.n_pop ,1 ) );

pop1 = randnum( 1:2:2*obj.n_pop ); % first pop
pop2 = randnum( 2:2:2*obj.n_pop ); % second pop

% Binary tournament using the crowded comparison operator
rank_cond = ( obj.rank_pop(pop1,:) < obj.rank_pop(pop2,:) );
crowd_cond = ( obj.rank_pop(pop1,:) == obj.rank_pop(pop2,:) &....
    obj.crowding_distance(pop1,:) > obj.crowding_distance(pop2,:) );

selection_pop_bin = ( rank_cond | crowd_cond );

x_selected = [ pop1(selection_pop_bin,:) ; pop2(~selection_pop_bin,:) ];

end

