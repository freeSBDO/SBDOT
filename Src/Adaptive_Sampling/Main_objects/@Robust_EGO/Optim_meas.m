function [ obj_val ] = Optim_meas( obj, x )
% OPTIM_MEAS
%

[ obj_val, ~, g_rob ] = obj.Eval_rob_meas(x);

if obj.m_g>0
    
    obj_val( any(g_rob > 0, 2), : ) = NaN;
    
end

end

