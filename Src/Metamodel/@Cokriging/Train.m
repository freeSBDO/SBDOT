function [] = Train( obj )
% TRAIN learn the statistical relationship of the data
%
% Syntax :
% []=obj.train();

% Superclass method
obj.Train@Metamodel();

if obj.prob.display, fprintf('\nTraining starting...');end

opts = ooDACE.CoKriging.getDefaultOptions();
opts = obj.Def_hyp_corr('LF',opts);
opts = obj.Def_hyp_corr('HF',opts);

opts.hpBounds = {[obj.lb_hyp_corr{1} ; obj.ub_hyp_corr{1}],...
    [obj.lb_hyp_corr{2} ; obj.ub_hyp_corr{2}]};

if isempty(obj.rho) 
    if isempty( obj.lb_rho ) || isempty( obj.ub_rho )
        
        if xor( isempty(obj.lb_rho), isempty(obj.ub_rho) )
            warning('SBDOT:Cokriging:rhoBounds_miss','Both bounds lb_rho and ub_rho have to be defined ! Default values are applied')
        end
        
        y_max = [max(obj.f_train{1}),max(obj.f_train{2})];
        y_min = [min(obj.f_train{2}),min(obj.f_train{1})];
        
        obj.lb_rho=-max(abs(y_max-y_min));
        obj.ub_rho=max(abs(y_max-y_min));
                
        if isempty(obj.rho0)            
            obj.rho0 = abs(max(obj.f_train{1})-min(obj.f_train{2}));        
        else
            
            assert( size(obj.rho0,2) == 2 ,...
            'SBDOT:Cokriging:rho0_size',...
            'rho0 must be of size 1-by-2');
            
            obj.hyp_corr0{i_var} = log10( obj.hyp_corr0{i_var} );
            
        end
        
    else
        
        assert( size(obj.lb_rho,2) == 2 ,...
            'SBDOT:Cokriging:rhoBounds_size',...
            'lb_rho must be of size 1-by-2');
        
        assert( size(obj.ub_rho,2) == 2 ,...
            'SBDOT:Cokriging:rhoBounds_size',...
            'ub_rho must be of size 1-by-2');
        
        assert( all( obj.lb_rho < obj.ub_rho , 2),...
            'SBDOT:Cokriging:rhoBounds',...
            'lb_rhor must be lower than ub_rho');
        
        if isempty(obj.rho0)            
            obj.rho0 = ( obj.ub_rho + obj.lb_rho ) ./ 2;  
        end
        
    end
    
else
    
    obj.lb_rho=obj.rho;
    obj.ub_rho=obj.rho;
    obj.rho0=obj.rho;
    
end

opts.rhoBounds = [obj.lb_rho ; obj.ub_rho];
opts.rho0 = obj.rho0; 

obj.ck_oodace = ooDACE.CoKriging( opts, obj.hyp_corr0, obj.regpoly, obj.corr);
obj.ck_oodace = obj.ck_oodace.fit(obj.x_train,obj.f_train);

if obj.prob.display, corr_name=func2str(obj.corr{2}); fprintf(['\nCokriging with ',corr_name(22:end),'HF correlation function is created.\n\n']);end

obj.hyp_corr = 10.^obj.ck_oodace.getHyperparameters;
obj.rho = obj.ck_oodace.getRho;

hyp_reg_temp = obj.ck_oodace.getSigma;
obj.hyp_reg{1} = hyp_reg_temp(1,1);
obj.hyp_reg{2} = hyp_reg_temp(obj.prob.prob_LF.n_x+1,obj.prob.prob_LF.n_x+1);

obj.hyp_corr_bounds = {10.^[min(obj.lb_hyp_corr{1}) , max(obj.ub_hyp_corr{1})] ,...
    10.^[min(obj.lb_hyp_corr{2}) , max(obj.ub_hyp_corr{2})]};
obj.hyp_reg_bounds = {[obj.lb_hyp_reg{1} , obj.ub_hyp_reg{1}], ...
    [obj.lb_hyp_reg{2} , obj.ub_hyp_reg{2}]};

end

