function obj = Set_optim(obj, hyp_reg, hyp_sigma2, hyp_corr, hyp_tau, hyp_dchol)
    % SET_OPTIM initialize optim_idx and optim_nr_parameters. They are used
    % in order to keep track of which hyper_param is optimized or not.
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       hyp_reg is same format as obj.hyp_reg
    %       hyp_sigma2 is same format as obj.hyp_sigma2
    %       hyp_corr is same format as obj.hyp_corr
    %       hyp_tau is same format as obj.hyp_tau
    %       hyp_dchol is same format as obj.hyp_dchol
    %
    %   Output:
    %       obj is the updated obj input
    %
    % Syntax :
    % obj = obj.( hyp_reg, hyp_sigma2, hyp_corr, hyp_tau, hyp_dchol )
    
    obj.optim_idx = cellfun( @isempty, {hyp_reg, hyp_sigma2, hyp_corr, hyp_tau, hyp_dchol} );
    
    obj.optim_idx(obj.SIGMA2) = and ( obj.var_opti, obj.optim_idx(obj.SIGMA2) );
    obj.optim_idx(obj.REG)    = and ( obj.reg, obj.optim_idx(obj.REG) );
    obj.optim_idx(obj.DCHOL)  = and ( strcmp(obj.tau_type, 'heteroskedastic'), obj.optim_idx(obj.DCHOL) );
    
    optim_nr_parameters = [ length(obj.hyp_reg_0),...
                            length(obj.hyp_sigma2_0),...
                            length(obj.hyp_corr_0),...
                            length(obj.hyp_tau_0),...
                            length(obj.hyp_dchol_0) ];
    
    obj.optim_nr_parameters = optim_nr_parameters(obj.optim_idx);

    % warn the user early if something is not possible
    assert( or(~obj.reinterpolation, obj.optim_idx(obj.REG)),...
        'SBDOT:Set_optim:Conflict_in_optionnal_parameters',...
        'Reinterpolation of the kriging error only makes sense for regression kriging.');
    
    assert( or(~obj.reinterpolation, ~obj.optim_idx(obj.SIGMA2)),...
        'SBDOT:Set_optim:Conflict_in_optionnal_parameters',...
        ['Reinterpolation of the predicted variance not possible when sigma2 is included ',...
        'in the hyperparameter optimization (stochastic kriging).'] );

    obj.hyp_reg = hyp_reg;
    obj.hyp_sigma2 = hyp_sigma2;
    obj.hyp_corr = hyp_corr;
    obj.hyp_tau = hyp_tau;
    obj.hyp_dchol = hyp_dchol;
    
end