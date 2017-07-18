classdef Test_q_kriging < matlab.unittest.TestCase
    %TEST_PROBLEM class : Unit test for class Problem
    % Test list :
    % Metamodel
    % - Error on Required inputs during parsing
    % - Error on empty/nonempty labels for output and constraints
    % Q_kriging
    % - Error on Optional inputs during parsing  
    % - Wrong Optional input
    % - Error on construction
    
    properties
        
    end
    
    % Test Method Block
    methods (Test)
        
        function testErrorQ_kriging(Test_q_kriging)
            
            t = {[1;2;3]};
            m_t = 3;
            m_x = 1;
            m_g = 1;
            m_y = 2;
            lb = 0; ub = 1;
            n_x = 7; n_eval = 100;
            func_str = 'emse_2';
            
            prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );
            prob.Get_design( n_x ,'LHS' )
            
            % Error on Construction
            q_krig = Q_kriging(prob,2,[],'tau_type','heteroskedastic');
            
            Test_q_kriging.verifyTrue(isa(q_krig,'Q_kriging'));
            Test_q_kriging.verifyEqual(q_krig.y_ind,2);
            Test_q_kriging.verifyTrue(strcmpi(q_krig.tau_type,'heteroskedastic'));
            
            % Training test
            
            % hyp_corr
            % Normal Use
            q_krig = Q_kriging(prob,2,[],'hyp_corr',0.5);
            Test_q_kriging.verifyEqual(q_krig.hyp_corr,log10(0.5));
            q_krig = Q_kriging(prob,2,[],'lb_hyp_corr',0.1,'ub_hyp_corr',1,'hyp_corr_0',0.7);
            Test_q_kriging.verifyEqual(q_krig.lb_hyp_corr,log10(0.1));
            Test_q_kriging.verifyEqual(q_krig.ub_hyp_corr,log10(1));
            Test_q_kriging.verifyEqual(q_krig.hyp_corr_0,log10(0.7));
            % Error
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'ub_hyp_corr',0.1),'SBDOT:Q_kriging:HypBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'lb_hyp_corr',0.1),'SBDOT:Q_kriging:HypBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'hyp_corr',0.5,'lb_hyp_corr',0.1),'SBDOT:Q_kriging:Unused_Arg');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_corr',1,'ub_hyp_corr',0.1),'SBDOT:Q_kriging:HypBounds');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_corr',-0.1,'ub_hyp_corr',1),'SBDOT:Q_kriging:HypBounds_values');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_corr',[0.1, 0.1],'ub_hyp_corr',1),'SBDOT:Q_kriging:HypBounds_size');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_corr',0.1,'ub_hyp_corr',[1, 1]),'SBDOT:Q_kriging:HypBounds_size');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_corr',0.1,'ub_hyp_corr',1,'hyp_corr_0',2),'SBDOT:Q_kriging:hyp_corr_0_OutBounds');
            Test_q_kriging.verifyError(@()Q_kriging(prob,1,[],'hyp_corr',[1 1]),'SBDOT:Q_kriging:Hyp_corr_size');
            Test_q_kriging.verifyError(@()Q_kriging(prob,1,[],'hyp_corr',-1),'SBDOT:Q_kriging:Hyp_corr_values');
            
            % hyp_tau
            % Normal Use
                % Choleski
                q_krig = Q_kriging(prob,2,[],'hyp_tau',[pi/2,pi/2,pi/2]);
                Test_q_kriging.verifyEqual(q_krig.hyp_tau,[pi/2,pi/2,pi/2]);
                q_krig = Q_kriging(prob,2,[],'lb_hyp_tau',[0.1,0.1,0.1],'ub_hyp_tau',[1,1,1],'hyp_tau_0',[0.7,0.7,0.7]);
                Test_q_kriging.verifyEqual(q_krig.lb_hyp_tau,[0.1,0.1,0.1]);
                Test_q_kriging.verifyEqual(q_krig.ub_hyp_tau,[1,1,1]);
                Test_q_kriging.verifyEqual(q_krig.hyp_tau_0,[0.7,0.7,0.7]);
                % Isotropic
                q_krig = Q_kriging(prob,2,[],'tau_type','isotropic','hyp_tau',0);
                Test_q_kriging.verifyEqual(q_krig.hyp_tau,0);
                q_krig = Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',-0.1,'ub_hyp_tau',0.9,'hyp_tau_0',0.5);
                Test_q_kriging.verifyEqual(q_krig.lb_hyp_tau,-0.1);
                Test_q_kriging.verifyEqual(q_krig.ub_hyp_tau,0.9);
                Test_q_kriging.verifyEqual(q_krig.hyp_tau_0,0.5);
            % Error
                % Choleski
                Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'ub_hyp_tau',[1,1,1]),'SBDOT:Q_kriging:TauBounds_miss');
                Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'lb_hyp_tau',[0.1,0.1,0.1]),'SBDOT:Q_kriging:TauBounds_miss');
                Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'hyp_tau',[pi/2,pi/2,pi/2],'lb_hyp_tau',[0.1,0.1,0.1]),'SBDOT:Q_kriging:Unused_Arg');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_tau',[1,1,1],'ub_hyp_tau',[0.1,0.1,0.1]),'SBDOT:Q_kriging:TauBounds');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_tau',[-0.1,0.1,0.1],'ub_hyp_tau',[1,1,1]),'SBDOT:Q_kriging:TauBounds_Chol_Heterosked');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_tau',[0.1,0.1,0.1],'ub_hyp_tau',[4,1,1]),'SBDOT:Q_kriging:TauBounds_Chol_Heterosked');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_tau',[0.1, 0.1],'ub_hyp_tau',[1,1,1]),'SBDOT:Q_kriging:TauBounds_size');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_tau',[0.1,0.1,0.1],'ub_hyp_tau',[1, 1]),'SBDOT:Q_kriging:TauBounds_size');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'lb_hyp_tau',[0.1,0.1,0.1],'ub_hyp_tau',[1,1,1],'hyp_tau_0',[2, 1, 1]),'SBDOT:Q_kriging:hyp_tau_0_OutBounds');
                Test_q_kriging.verifyError(@()Q_kriging(prob,1,[],'hyp_tau',[1, 1]),'SBDOT:Q_kriging:hyp_tau_wrong_size');
                % Isotropic
                Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'tau_type','isotropic','ub_hyp_tau',0.9),'SBDOT:Q_kriging:TauBounds_miss');
                Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',-0.1),'SBDOT:Q_kriging:TauBounds_miss');
                Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'tau_type','isotropic','hyp_tau',0.5,'lb_hyp_tau',-0.1),'SBDOT:Q_kriging:Unused_Arg');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',0.9,'ub_hyp_tau',-0.1),'SBDOT:Q_kriging:TauBounds');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',-2,'ub_hyp_tau',0.9),'SBDOT:Q_kriging:TauBounds_Isotropic');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',-0.1,'ub_hyp_tau',1.5),'SBDOT:Q_kriging:TauBounds_Isotropic');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',[-0.1, -0.1],'ub_hyp_tau',0.9),'SBDOT:Q_kriging:TauBounds_size');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',-0.1,'ub_hyp_tau',[0.9, 0.9]),'SBDOT:Q_kriging:TauBounds_size');
                Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','isotropic','lb_hyp_tau',-0.1,'ub_hyp_tau',0.9,'hyp_tau_0',2),'SBDOT:Q_kriging:hyp_tau_0_OutBounds');
                Test_q_kriging.verifyError(@()Q_kriging(prob,1,[],'tau_type','isotropic','hyp_tau',[0.5, 0.5]),'SBDOT:Q_kriging:hyp_tau_wrong_size');
                Test_q_kriging.verifyError(@()Q_kriging(prob,1,[],'tau_type','isotropic','hyp_tau',-2),'SBDOT:Q_kriging:Tau_Isotropic');
                
            % hyp_dchol
            % Normal Use
            q_krig = Q_kriging(prob,2,[],'tau_type','heteroskedastic','hyp_dchol',[0.5, 0.5, 0.5]);
            Test_q_kriging.verifyEqual(q_krig.hyp_dchol,[0.5, 0.5, 0.5]);
            q_krig = Q_kriging(prob,2,[],'tau_type','heteroskedastic','lb_hyp_dchol',[0.1,0.1,0.1],'ub_hyp_dchol',[1,1,1],'hyp_dchol_0',[0.7,0.7,0.7]);
            Test_q_kriging.verifyEqual(q_krig.lb_hyp_dchol,[0.1,0.1,0.1]);
            Test_q_kriging.verifyEqual(q_krig.ub_hyp_dchol,[1,1,1]);
            Test_q_kriging.verifyEqual(q_krig.hyp_dchol_0,[0.7,0.7,0.7]);
            % Error
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','ub_hyp_dchol',[1,1,1]),'SBDOT:Q_kriging:DcholBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','lb_hyp_dchol',[0.1,0.1,0.1]),'SBDOT:Q_kriging:DcholBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','hyp_dchol',[0.5,0.5,0.5],'lb_hyp_dchol',[0.1,0.1,0.1]),'SBDOT:Q_kriging:Unused_Arg');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'tau_type','choleski','hyp_dchol',[0.5,0.5,0.5]),'SBDOT:Q_kriging:Unused_Arg');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','lb_hyp_dchol',[1,1,1],'ub_hyp_dchol',[0.1,0.1,0.1]),'SBDOT:Q_kriging:DcholBounds');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','lb_hyp_dchol',[-0.1,0.1,0.1],'ub_hyp_dchol',[1,1,1]),'SBDOT:Q_kriging:DcholBounds');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','lb_hyp_dchol',[0.1, 0.1],'ub_hyp_dchol',[1,1,1]),'SBDOT:Q_kriging:DcholBounds_size');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','lb_hyp_dchol',[0.1,0.1,0.1],'ub_hyp_dchol',[1, 1]),'SBDOT:Q_kriging:DcholBounds_size');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'tau_type','heteroskedastic','lb_hyp_dchol',[0.1,0.1,0.1],'ub_hyp_dchol',[1,1,1],'hyp_dchol_0',[2,0.5,0.5]),'SBDOT:Q_kriging:hyp_dchol_0_OutBounds');
            Test_q_kriging.verifyError(@()Q_kriging(prob,1,[],'tau_type','heteroskedastic','hyp_dchol',[1 1]),'SBDOT:Q_kriging:hyp_dchol_wrong_size');
            Test_q_kriging.verifyError(@()Q_kriging(prob,1,[],'tau_type','heteroskedastic','hyp_dchol',[-1,0.5,0.5]),'SBDOT:Q_kriging:DcholBounds');
            
            % hyp_reg
            % Normal Use
            q_krig = Q_kriging(prob,2,[],'reg', true, 'hyp_reg', 0.5);
            Test_q_kriging.verifyEqual(q_krig.hyp_reg,log10(0.5));
            q_krig = Q_kriging(prob,2,[],'reg', true,'lb_hyp_reg',0.1,'ub_hyp_reg',1,'hyp_reg_0',0.7);
            Test_q_kriging.verifyEqual(q_krig.lb_hyp_reg,log10(0.1));
            Test_q_kriging.verifyEqual(q_krig.ub_hyp_reg,log10(1));
            Test_q_kriging.verifyEqual(q_krig.hyp_reg_0,log10(0.7));
            % Error
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'reg', true,'ub_hyp_reg',0.1),'SBDOT:Q_kriging:RegBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'reg', true,'lb_hyp_reg',0.1),'SBDOT:Q_kriging:RegBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'reg', true,'hyp_reg',0.5,'lb_hyp_reg',0.1),'SBDOT:Q_kriging:Unused_Arg');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'reg', true,'lb_hyp_reg',1,'ub_hyp_reg',0.1),'SBDOT:Q_kriging:RegBounds');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'reg', true,'lb_hyp_reg',-0.1,'ub_hyp_reg',1),'SBDOT:Q_kriging:RegBounds');
            
            % hyp_sigma2
            % Normal Use
            q_krig = Q_kriging(prob,2,[],'var_opti',true,'lb_hyp_sigma2',0.1,'ub_hyp_sigma2',1,'hyp_sigma2_0',0.7);
            Test_q_kriging.verifyEqual(q_krig.lb_hyp_sigma2,log10(0.1));
            Test_q_kriging.verifyEqual(q_krig.ub_hyp_sigma2,log10(1));
            Test_q_kriging.verifyEqual(q_krig.hyp_sigma2_0,log10(0.7));
            % Error
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'var_opti',true,'ub_hyp_sigma2',0.1),'SBDOT:Q_kriging:VarBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'var_opti',true,'lb_hyp_sigma2',0.1),'SBDOT:Q_kriging:VarBounds_miss');
            Test_q_kriging.verifyWarning(@()Q_kriging(prob,2,[],'hyp_sigma2',0.5,'lb_hyp_sigma2',0.1),'SBDOT:Q_kriging:Unused_Arg');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'var_opti',true,'lb_hyp_sigma2',1,'ub_hyp_sigma2',0.1),'SBDOT:Q_kriging:Sigma2Bounds');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'var_opti',true,'lb_hyp_sigma2',-0.1,'ub_hyp_sigma2',1),'SBDOT:Q_kriging:Sigma2_Lower_Bound');
            Test_q_kriging.verifyError(@()Q_kriging(prob,2,[],'var_opti',true,'reinterpolation',true),'SBDOT:Set_optim:Conflict_in_optionnal_parameters');
            
        end
        
    end
    
end

