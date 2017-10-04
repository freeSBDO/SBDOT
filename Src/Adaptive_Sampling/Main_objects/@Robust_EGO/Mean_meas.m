function [ meas ] = Mean_meas( obj, data, nb_points )
% MEAN_MEAS 
% Compute the mean robustness measure

meas = mean( reshape( data, obj.CRN_samples, nb_points ), 1 )';

end

