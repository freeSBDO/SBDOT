function [ meas ] = Var_meas( obj, data, nb_points )
% VAR_MEAS
% Compute the variance robustness measure

meas = var( reshape( data, obj.CRN_samples, nb_points ), 1 )';

end

