function [ cent_K, ind_K, cluster_dist ] = Kmeans_SBDO( x, k )
% KMEANS_SBDOO : clustering algorithm to partition data
%
%   x (n by m matrix) is the dataset to partition.
%   => n is the number of point in the dataset, m is the dimension of the
%   input space.
%
%   k is the number of cluster to create. 
%
%
%   cent_K (k by m matrix) are the k centroids.
%
%   ind_k (n by 1 matrix) is the column vector containing the corresponding
%   cluster of each points (value equal 1 for cluster 1, 2 for cluster 2,
%   etc...).
%
%   cluster_dist (k by 1 matrix) is the matrix of distance between cluster points and
%   each centroid. 
%
% Syntax :
% cent_K = Kmeans_SBDO(x,k);
% [cent_K,ind_K] = Kmeans_SBDO(x,k);
% [cent_K,ind_K,cluster_dist] = Kmeans_SBDO(x,k);

% Input checks
p = inputParser;
p.KeepUnmatched=false;
p.PartialMatching=false;
p.addRequired('x',@(x)validateattributes(x,{'numeric'},{'nonempty'}));
p.addRequired('k',@(x)validateattributes(x,{'numeric'},{'nonempty','scalar','integer','positive'}));
p.parse(x,k)
in=p.Results;

% Intialization of centroids 
n=size(in.x,1);
cent_init=randperm(n,in.k);
cent_K=in.x(cent_init,:);

% Variable initialization befor while loop
cent_K0=[];
ind_K=[];
dist_cent=[];

while ~isequal(cent_K0,cent_K);
    
    % update
    cent_K0=cent_K; 
    % euclidean distance of each points to centroids
    dist_cent(:,:)=sqrt(abs(sum((bsxfun(@minus,permute(cent_K0,[3 2 1]),in.x)).^2,2)));
    % reveal the closest centroids of each points
    [~,ind_K]=min(dist_cent,[],2);
    % compute centroid
    for i=1:in.k
        if all(~(ind_K==i))
            cent_K(i,:)=cent_K0(i,:);
        else            
            cent_K(i,:)=mean(in.x(ind_K==i,:),1);
            cluster_dist(i,:)=sum(dist_cent(ind_K==i,i));
        end
    end
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


