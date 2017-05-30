function [ x ] = Unscale_data( x_scaled, lb, ub )
    % UNSCALE_DATA Unscale data between lb and ub
    %
    %   *x_scaled (n by m_x matrix) is the scaled input matrix of the dataset
    %   *lb (1 by m_x matrix) is the lower bound of the input data
    %   *ub (1 by m_x matrix) is the upper bound of the input data
    %
    % Syntax :
    % [x]=scale_datal(x_scaled,lb,ub);

    % Parser
    p = inputParser;
    p.KeepUnmatched=true;
    p.PartialMatching=false;
    p.addRequired('x_scaled',@(x)validateattributes(x,{'numeric'},{'nonempty'}));
    p.addOptional('lb',min(x),@(x)validateattributes(x,{'numeric'},{'nonempty','row'}));
    p.addOptional('ub',max(x),@(x)validateattributes(x,{'numeric'},{'nonempty','row'}));
    p.parse(x_scaled,lb,ub);
    in=p.Results;

    x_scaled = in.x_scaled;
    lb = in.lb;
    ub = in.ub;
    
    %% Checks
    m = size(x_scaled,2);
    assert( size(lb,2) == m, ...
        'SBDOT:unscale_data:lb_argument', ...
        'lb must be a row vector of size 1 by m_x');
    assert( size(ub,2) == m, ...
        'SBDOT:unscale_data:ub_argument', ...
        'ub must be a row vector of size 1 by m_x');

    % Data unscaling

    x = bsxfun( @plus, bsxfun( @times, x_scaled, ub-lb ), lb);

end

