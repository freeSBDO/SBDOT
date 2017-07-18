function ind = sub2tril(sub, n)
    % SUB2TRIL has the same function as sub2indVect execpt that it works
    % with triangular matrices
    % 
    %   Inputs:
    %       sub is the subscript
    %       n is the number of rows (i.e. columns since matrices are squares)
    %
    %   Output:
    %       ind is the index consistent to the indexing of a triangular matrix
    %
    % Syntax:
    %   ind = sub2tril( sub, n );
    
    ind = n*(n+1)/2-(n-sub(:,2)).*(n-sub(:,2)+1)/2-(n-sub(:,1));
    
end