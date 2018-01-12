function [] = Get_design( obj, num_x, varargin)
    % GET_DESIGN Create a sampling plan and evaluates it
    %
    %   Inputs (Required):
    %       obj the object of class Q_problem
    %       num_x the number of points per slices (should be the same)
    %
    %   Inputs (Optional):
    %       type the type of design desired
    %       [default = 'SLHS', 'LHS', 'OLHS', 'Halton', 'Sobol']
    %       maximin_type selects the optimization method
    %       [default = 'Threshold', 'Monte_Carlo']
    %       n_iter number of iterations (Monte_Carlo or Threshold)
    %       n_threshold number of thresholds (Threshold)
    %
    % Syntax :
    % obj.Get_design( num_x );
    % obj.Get_design( num_x, type );
    
    p = inputParser;
    p.PartialMatching=false;
    p.addRequired('obj',@(x)isa(x,'Q_problem'));
    p.addRequired('num_x',@(x)validateattributes(x,{'numeric'},{'nonempty','row','integer','positive'}));
    p.addOptional('type','SLHS',@(x) any(validatestring(x, {'LHS','SLHS','OLHS','Halton','Sobol'})));
    p.addOptional('maximin_type','Threshold',@(x) any(validatestring(x, {'Monte_Carlo','Threshold'})));
    p.addOptional('n_iter',100,@(x)validateattributes(x,{'numeric'},{'nonempty','scalar','integer','positive'}));
    p.addOptional('n_threshold',10,@(x)validateattributes(x,{'numeric'},{'nonempty','scalar','integer','positive'}));
    p.parse(obj,num_x,varargin{:});
    in=p.Results;
    
    obj = in.obj;
    num_x = in.num_x;
    type = in.type;
    maximin_type = in.maximin_type;
    n_iter = in.n_iter;
    n_threshold = in.n_threshold;
    
    assert( or(size(num_x,2) == 1, size(num_x,2) == prod(obj.m_t)),...
        'SBDOT:Q_problem:t_argument',...
        'num_x shall either be of length equal to 1 or the number of qualitative combination');
    
    if size(num_x,2) == 1
        num_x = num_x*ones(1,prod(obj.m_t));
    end
    
    assert( length(unique(num_x)) == 1,...
        'SBDOT:Q_problem:Sliced_Sampling',...
        'When using sliced latin hypercube design, number of points should be homogeneous through slices.' );
    
    % Sampling
    x_sampling = obj.Sampling( num_x, type, maximin_type, n_iter, n_threshold );
    
    % Evaluation
    obj.Eval( num_x, x_sampling );

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


