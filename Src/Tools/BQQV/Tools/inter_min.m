function d_min = inter_min ( x, k ,r, d )
    % INTER_MIN computes the opposite of the minimum inter-point distance
    % for the set of k points x in spheric coordinates on the the
    % hypersphere of radius r in dimension d.
    % 
    %   Inputs:
    %       x set of points in spheric coordinates
    %       r radius of the hypersphere
    %       k number of points in the set
    %       d the dimension of the problem
    %
    %   Output:
    %       d_min the opposite of the minimum inter-point distance for the set
    %
    % Syntax:
    %   d_min = inter_min ( x, k ,r, d );
    
    x = reshape(x',k,d-1);
    x = hypersph2cart( [r*ones(1,k); x'] )';
    temp = ipdm(x);
    d_min = -min( temp(logical(tril(ones(k),-1))) );

end