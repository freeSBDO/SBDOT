function [ k_opt, grad_totatl_dist ] = Kmeans_analysis_SBDO( x, varargin )
%% kmeans_analysis_SBDO : Analysis of the number of cluster to partition data with kmeans
%
%   x (n by m matrix) is the dataset to partition.
%   => n is the number of point in the dataset, m is the dimension of the
%   input space.
%
%   k {optional} (scalar) is the maximal number of cluster allowed

% Input checks
p = inputParser;
p.KeepUnmatched=false;
p.PartialMatching=false;
p.addRequired('x',@(x)validateattributes(x,{'numeric'},{'nonempty'}));
p.addOptional('k_max',50,@(x)validateattributes(x,{'numeric'},{'nonempty','scalar','integer','positive'}));
p.addOptional('display',true,@islogical);
p.parse(x,varargin{:})
in=p.Results;

n=size(in.x,1);
if in.k_max>n
    in.k_max=n;
end

% Main loop
for i=1:in.k_max    
    [~,~,cluster_dist]=Kmeans_SBDO(in.x,i);
    total_dist(i)=sum(cluster_dist);        
end

grad_totatl_dist=total_dist(2:end)-total_dist(1:end-1);
k_opt=find(grad_totatl_dist>0,1);

if in.display
    % Plot
    figure
    subplot(1,2,1)
    hold on
    plot(1:in.k_max,total_dist,'k-')
    xlabel('Number of cluster')
    ylabel('Sum of distances between cluster points and centroid')
    hold off
    subplot(1,2,2)
    hold on
    plot(1:in.k_max-1,grad_totatl_dist,'k-')
    xlabel('Number of cluster')
    ylabel('Gradient of distances')
    hold off
end

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


