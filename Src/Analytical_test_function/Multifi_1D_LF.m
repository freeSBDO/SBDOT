function y_LF =Multifi_1D_LF( x )
    %Branin
    % x is a ... by 1 matrix of input points
    %   variable 1 (in column 1) is set between [0 1]
    %
    % y_LF is a ... by 1 matrix of high fidelity objective values
    %   Multifi_1D_lF is a multifidelity test function
    %
    % Ref : TODO ( Forrester )
    
A=0.5;
B=10;
C=5;

ye_c = (( 6*x -2 ).^2) .* sin( 12*x - 4 );

y_LF = A*ye_c + B*( x-0.5 )-C;
end
