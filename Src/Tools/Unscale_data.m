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
    p.addOptional('lb',min(x_scaled),@(x)validateattributes(x,{'numeric'},{'nonempty','row'}));
    p.addOptional('ub',max(x_scaled),@(x)validateattributes(x,{'numeric'},{'nonempty','row'}));
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





% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


