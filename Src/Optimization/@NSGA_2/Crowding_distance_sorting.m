function [ Front_population ] = Crowding_distance_sorting( obj, int_Front_population, int_rank_pop )
% CROWDING_DISTANCE_SORTING

N=0;
iter=1;
crowding_distance_temp=[];
Front_population=[];

while obj.n_pop > ( N + length( int_Front_population{iter,:} ) )
    
    int_crowding_distance = obj.Crowding_distance_assignement( int_Front_population{iter,:}, obj.y );
    Front_population = [ Front_population ; int_Front_population{iter,:}' ];
    crowding_distance_temp = [ crowding_distance_temp ; int_crowding_distance ];
    N = N + length( int_Front_population{iter,:} );
    iter = iter+1;
    
end

if obj.n_pop == ( N + length( int_Front_population{iter,:} ) )
    
    int_crowding_distance = obj.Crowding_distance_assignement ( int_Front_population{iter,:} , obj.y );
    Front_population = [ Front_population ; int_Front_population{iter,:}' ];
    obj.crowding_distance = [ crowding_distance_temp ; int_crowding_distance ];
    
else
    
    int_crowding_distance = obj.Crowding_distance_assignement( int_Front_population{iter,:}, obj.y );
    sort_matrix = flipud( sortrows( [ int_crowding_distance, int_Front_population{iter,:}' ], 1 ) );
    Front_population = [ Front_population ; sort_matrix( 1:obj.n_pop-N,2 ) ];
    obj.crowding_distance = [ crowding_distance_temp ; sort_matrix( 1:obj.n_pop-N , 1) ];
    
end

obj.rank_pop = int_rank_pop( Front_population );

end

