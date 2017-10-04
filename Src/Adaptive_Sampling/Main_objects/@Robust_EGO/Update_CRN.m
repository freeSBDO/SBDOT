function [ x_CRN ] = Update_CRN( obj, x_test )
% UPDATE_CRN
%   (see also Compute_CRN help)
%   * photonic variable :
%   phot_int = CRN_mat * cd_min (which is the minimum values of photonic variables)
%   x_CRN = phot_int + x_test (+-10% of minimum photonic parameters values)
%   * environmental variable :
%   x_CRN = CRN_mat 
%   ** if a variable is photonic and environmental, the photonic sequence
%   is used.
%   * classic variable
%   x_CRN = CRN_mat + x_test

x_CRN = zeros( size(x_test,1) * obj.CRN_samples, obj.prob.m_x );

% Minimum length of photonic variables
cd_min = repmat( min(x_test(:,obj.phot_lab),[],2),1,nnz(obj.phot_lab)); 

phot_int = bsxfun( @times,...
    permute(obj.CRN_matrix(:,obj.phot_lab), [1 3 2]), ...
    permute(cd_min, [3 1 2]) );

x_CRN(:,obj.phot_lab) = reshape( bsxfun( @plus, ...
    phot_int, ...
    permute( x_test(:,obj.phot_lab), [3 1 2] ) ), ...
    size(x_test,1) * obj.CRN_samples, nnz(obj.phot_lab) );

x_test(:,obj.phot_lab) = [];

x_CRN(:, ~obj.phot_lab & ~obj.env_lab ) = reshape( ...
    bsxfun( @plus, ...
    permute( obj.CRN_matrix(:, ~obj.phot_lab & ~obj.env_lab ),[1 3 2]), ...
    permute(x_test,[3 1 2]) ), ...
    size(x_test,1)*obj.CRN_samples, size(x_test,2) );

x_CRN( :, obj.env_lab ) = repmat( obj.CRN_matrix(:,obj.env_lab),...
    size(x_test,1), 1 );

end

