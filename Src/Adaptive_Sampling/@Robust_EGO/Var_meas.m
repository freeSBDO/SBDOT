function [ meas ] = Var_meas( obj, data, nb_points )
% VAR_MEAS
% 

meas = var( reshape( data, obj.CRN_samples, nb_points ), 1 )';

end

