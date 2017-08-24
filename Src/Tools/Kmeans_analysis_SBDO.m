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
