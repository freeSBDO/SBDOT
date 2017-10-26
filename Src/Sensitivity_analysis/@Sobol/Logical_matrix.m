function M = Logical_matrix( obj )
% LOGICAL_MATRIX
% Build matrix M which each rows defines input variable indices
% linked to the current sobol partial indice computation
% Example : rows [0101] model indice S_2-4
% If m >= 10, only first order indices are computed 

if obj.m < 10 % 
    N = 2 ^ obj.m;
    M1 = zeros( N, obj.m);
    for k = 1 : obj.m
        v = [ zeros( 2^(k-1), 1 ) ; ones( 2^(k-1), 1 ) ];
        M1( : ,obj.m-k+ 1) = repmat( v, 2^(obj.m-k), 1);
    end
else
    % identity
    M1=[zeros(1,obj.m) ; eye(obj.m)];
end

M1( sum(M1,2) < 2, : ) = [];
M2 = eye( obj.m );
% First order indices will be computed first
M = [ M2 ; M1 ];

end

