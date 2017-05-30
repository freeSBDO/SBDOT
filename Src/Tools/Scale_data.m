function [ x_scaled ] = Scale_data( x, lb, ub)
    % SCALE_DATA Scale data between 0 and 1
    %
    %   *x (n by m_x matrix) is the input matrix of the dataset
    %   *lb (1 by m_x matrix) is the lower bound of the input data 
    %   *ub (1 by m_x matrix) is the upper bound of the input data 
    %   
    % Syntax :
    % [x_scaled]=scale_datal(x,lb,ub);

    % Parser
    p = inputParser;
    p.KeepUnmatched=true;
    p.PartialMatching=false;
    p.addRequired('x',@(x)validateattributes(x,{'numeric'},{'nonempty'}));
    p.addOptional('lb',min(x),@(x)validateattributes(x,{'numeric'},{'nonempty','row'}));
    p.addOptional('ub',max(x),@(x)validateattributes(x,{'numeric'},{'nonempty','row'}));
    p.parse(x,lb,ub);
    in=p.Results;

    x = in.x;
    lb = in.lb;
    ub = in.ub;
    
    % Checks
    m = size(x,2);
    assert( size(lb,2) == m, ...
        'SBDOT:scale_data:lb_argument',...
        'lb must be a row vector of size 1 by m_x');
    assert( size(ub,2) == m, ...
        'SBDOT:scale_data:ub_argument', ...
        'ub must be a row vector of size 1 by m_x');

    % Data scaling

    x_scaled = bsxfun( @rdivide, bsxfun( @minus, x, lb), ub-lb );

end

