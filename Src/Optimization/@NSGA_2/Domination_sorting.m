function [] = Domination_sorting( obj )
% DOMINATION_SORTING 
% Sort population based on domination operator

[ int_Front_population, int_rank_pop ] = obj.Fast_non_dominated_sort( obj.y, 1:size(obj.y,1) );

[Front_population] = obj.Crowding_distance_sorting( int_Front_population, int_rank_pop );

obj.x = obj.x( Front_population, : );
obj.y = obj.y( Front_population, : );

if obj.constraint_logical
    obj.g = obj.g( Front_population, : );
end

end

