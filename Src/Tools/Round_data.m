function [ x_round ] = Round_data( x, range )
    % ROUND_DATA Round input based on user scale
    %
    %   *x (n by m_x matrix) is the scaled input matrix of the dataset
    %   *range is a vector (1 by m_x) of value corresponding to the user precision needed.
    %
    % Syntax :
    % [x_round]=Round_data(x,range);
    % example x = 10.25487 , range = 0.001 ====> x_round = 10.255
    
    assert( size(range,2) == size(x,2),...
        'SBDOT:Round_data:round_range',...
        'round range size is not correct');

    x_round = bsxfun( @times, ...
        round( bsxfun( @times, x, ( 1./range ) ) ), ...
        range);

end

