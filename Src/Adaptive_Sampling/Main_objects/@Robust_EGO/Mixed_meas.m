function [ meas ] = Mixed_meas( obj, data, nb_points )
% MIXED_MEAS 
%

data_mat = reshape( data, obj.CRN_samples, nb_points );
meas = mean(data_mat,1)' + std(data_mat,0,1)';


end

