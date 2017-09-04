function [ meas ] = Mean_meas( obj, data, nb_points )
% MEAN_MEAS 
%

meas = mean( reshape( data, obj.CRN_samples, nb_points ), 1 )';

end

