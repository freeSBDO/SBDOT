function [ meas, id_meas ] = Worstcase_meas( obj, data , nb_points )
% WORSTCASE_MEAS 
% 
[ meas , id_meas ] = max( reshape( data, obj.CRN_samples, nb_points ), [], 1);
meas = meas';

end

