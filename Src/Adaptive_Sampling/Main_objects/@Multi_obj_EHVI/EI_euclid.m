function EI = EI_euclid (~,zp_mean, zp_std, zi, zr)

PI_ref1 = stk_distrib_normal_cdf (zr, zp_mean, zp_std);  % m x p
PI_ref2 = prod (PI_ref1, 2);                                  % m x 1

% Compute signed decomposition wrt to the reference zr
% (note: stk_dominatedhv removes non-dominated points and duplicates from zi)
S = stk_dominatedhv (zi, zr, 1);

if ~ isempty (S.sign)
    
    % Shift rectangle number to third dimension
    Rs = shiftdim (S.sign,  -2);
    Ra = shiftdim (S.xmin', -1);
    Rb = shiftdim (S.xmax', -1);
    
    PIa = stk_distrib_normal_cdf (Ra ,...
        zp_mean , zp_std);
    PIb = stk_distrib_normal_cdf (Rb ,...
        zp_mean , zp_std);
    
    PI_int = PI_ref2 - sum (bsxfun (@times, Rs, prod (PIb - PIa, 2)), 3);
    
    if PI_int <= 1e-6
        
        EI = 0;
        
    else
        
        phia = stk_distrib_normal_pdf (Ra, zp_mean, zp_std);  % m x p x R
        phib = stk_distrib_normal_pdf (Rb, zp_mean, zp_std);
        phi_ref = stk_distrib_normal_pdf (zr, zp_mean, zp_std);
        
        pEIa = zp_mean.*PIa - zp_std.*phia;
        pEIb = zp_mean.*PIb - zp_std.*phib;
        pEI_ref = zp_mean.*PI_ref1 - zp_std.*phi_ref;
        
        Phi_diff = PIb - PIa;
        
        EI_diff = pEIb - pEIa;
        
        for i = 1 : size(zp_mean,2)
            
            indice_prod = setdiff( 1:size(zp_mean,2) , i);
            y_centroid_ref(1,i,:) = prod(PI_ref1(:,indice_prod,:),2) .* pEI_ref(:,i,:);
            y_centroid_1(1,i,:)  = prod(Phi_diff(:,indice_prod,:),2) .* EI_diff(:,i,:);
        end
        
        y_centroid_2 = sum(bsxfun (@times, Rs, y_centroid_ref - y_centroid_1), 3);
        %y_centroid_2 =  y_centroid_ref - sum(bsxfun (@times, Rs, y_centroid_1), 3);

        y_centroid_final = y_centroid_2 ./ PI_int;
        % distance
        distances_to_PF = sum((bsxfun(@minus,y_centroid_final,zi)).^2);
        
        closest_id = find(distances_to_PF == min(distances_to_PF));
        
        EI = distances_to_PF(closest_id(1))*PI_int;
    end
    
end % if

end % function


