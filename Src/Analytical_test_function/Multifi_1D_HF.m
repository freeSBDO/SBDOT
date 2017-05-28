function y_HF =Multifi_1D_HF( x )
    %Branin
    % x is a ... by 1 matrix of input points
    %   variable 1 (in column 1) is set between [0 1]
    %
    % y_HF is a ... by 1 matrix of high fidelity objective values
    %   Multifi_1D_HF is a multifidelity test function
    %
    % Ref : TODO ( Forrester )
    
y_HF = (( 6*x -2 ).^2) .* sin( 12*x - 4 );

end
