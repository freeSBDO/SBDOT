function B = vect2full(sz, Vect, k)
    % VECT2TRIL transform a vector into its corresponding full symmetric matrix
    % 
    %   Inputs:
    %       sz corresponds to the size of the full matrix
    %       Vect is the vector of interest
    %       k is (like in tril function) defining the position of the first non-null diagonal
    %
    %   Output:
    %       A is the corresponding triangular matrix
    %
    % Syntax:
    %   A = vect2tril( sz, Vect, k );
    
    A = tril(ones(sz), k);
    A(~~A)=Vect;
    
    B = A + A';
    B(1:sz+1:end) = diag(A);
    
end