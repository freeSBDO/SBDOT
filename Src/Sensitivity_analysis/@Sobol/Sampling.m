function [ A, B ] = Sampling( obj )
% SAMPLING
% Generate Sobol sampling for indice computation
% See Saltelli et. al. 2009 (section 5.1)

if isa(obj.func_obj,'Problem')
    lb = obj.func_obj.lb;
    ub = obj.func_obj.ub;
else
    lb = obj.func_obj.prob.lb;
    ub = obj.func_obj.prob.ub;
end

x_temp = stk_sampling_sobol( obj.n_MC, 2*obj.m, [lb lb; ub ub], true );
x_sampling = x_temp.data;

A = x_sampling( :, 1:obj.m );
B = x_sampling( :, obj.m+1:end );

end

