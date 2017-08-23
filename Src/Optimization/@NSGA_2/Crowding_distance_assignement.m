function [ crowding_distance ] = Crowding_distance_assignement( obj, I, y )
% CROWDING_DISTANCE_ASSIGNEMENT
% crowding_distance_assignement : Calculate crowding distance

n = length(I);
max_y = max( y (I,:) );
min_y = min( y(I,:) );

crowding_distance_temp = Inf *ones( n, size(y,2) );
[ y_sort, ind_sort ] = sort( y(I,:), 1 );
crowding_distance_temp( 2:n-1 , : ) = bsxfun( @rdivide,...
    y_sort(3:n,:) - y_sort(1:n-2,:), max_y - min_y );

for i=1:size(y,2)
    
    crowding_distance( ind_sort(:,i), i ) = crowding_distance_temp( :, i );
    
end

crowding_distance = sum( crowding_distance, 2 );

end

