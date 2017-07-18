function A = vect2tril(sz, Vect, k)
    % VECT2TRIL transform a vector into its corresponding triagular matrix
    % 
    %   Inputs:
    %       sz corresponds to the size of the triangular matrix
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
    
end