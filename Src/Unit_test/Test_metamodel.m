classdef Test_metamodel < matlab.unittest.TestCase
    %TEST_PROBLEM class : Unit test for class Problem
    % Test list :
    % Metamodel
    % - Error on Required inputs during parsing
    % - Error on empty/nonempty labels for output and constraints
    % Kriging
    % - Error on Optional inputs during parsing  
    % - Wrong Optional input
    % - Error on construction
    
    properties
        
    end
    
    % Test Method Block
    methods (Test)
        
        function testErrorMetamodel(Test_metamodel)
            
            % Error on Required inputs during parsing            
            Test_metamodel.verifyError(@()Kriging('bob',1,[]),'MATLAB:InputParser:ArgumentFailedValidation');
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',true); 
            obj.Sampling(20);
            Test_metamodel.verifyError(@()Kriging(obj,true,[]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[1 2],[]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,1,true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,1,[1 2]),'MATLAB:InputParser:ArgumentFailedValidation');
            
            % Error on Optional inputs
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'shift_output','bo'),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'shift_output',[1 2 3]),'SBDOT:Metamodel:shift_output_size');

            % Error on empty/nonempty labels for output and constraints
            Test_metamodel.verifyError(@()Kriging(obj,[],[]),'SBDOT:Metamodel:lab_empty');
            Test_metamodel.verifyError(@()Kriging(obj,[1],[2]),'SBDOT:Metamodel:lab_nonempty');
        end
        
        function testErrorKriging(Test_metamodel)
            
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',true);   
            % Error on Optional inputs during parsing
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'regpoly','1'),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'corr','bob'),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'reg',1),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'hyp_corr',false),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'hyp_corr',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'hyp_reg',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'hyp_reg',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'lb_hyp_corr',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'lb_hyp_corr',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'ub_hyp_corr',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'ub_hyp_corr',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'lb_hyp_reg',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'lb_hyp_reg',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'ub_hyp_reg',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()Kriging(obj,[],[],'ub_hyp_reg',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');

            % Wrong Optional input
            obj.Get_design(20);
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'bob',true),'SBDOT:Metamodel:unmatched')
            
            % Error on construction
            krig=Kriging(obj,1,[]);
            obj.Get_design(20);
            Test_metamodel.verifyTrue(isa(krig,'Kriging'));
            Test_metamodel.verifyEqual(krig.y_ind,1);
            
            
            % Training test
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',true);   
            Test_metamodel.verifyError(@()Kriging(obj,1,[]),'SBDOT:Metamodel:EmptyTrain');
            obj.Get_design(20);
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'ub_hyp_corr',[1,2]),'SBDOT:Kriging:HypBounds_miss');
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'lb_hyp_corr',[1,2]),'SBDOT:Kriging:HypBounds_miss');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'lb_hyp_corr',[2 2],'ub_hyp_corr',[1 1]),'SBDOT:Kriging:HypBounds');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'lb_hyp_corr',[2 2 2],'ub_hyp_corr',[1 1]),'SBDOT:Kriging:HypBounds_size');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'lb_hyp_corr',[2 2],'ub_hyp_corr',[1 1 1]),'SBDOT:Kriging:HypBounds_size');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'hyp_corr',[1 1 1]),'SBDOT:Kriging:Hyp_val_size');
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'reg',true,'ub_hyp_reg',1),'SBDOT:Kriging:RegBounds_miss');
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'reg',true,'lb_hyp_reg',1),'SBDOT:Kriging:RegBounds_miss');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'reg',true,'ub_hyp_reg',0,'lb_hyp_reg',1),'SBDOT:Kriging:RegBounds');
            Kriging(obj,1,[],'reg',true,'hyp_reg',1e-5);
            Kriging(obj,1,[],'reg',true,'hyp_corr',[0.2 0.2]);
            
            % Predict test
            krig=Kriging(obj,1,[]);
            Test_metamodel.verifyError(@()krig.Predict([1 2 3 4]),'SBDOT:Metamodel:dimension_input');
            [a]=krig.Predict([1 2]);
            [a,b]=krig.Predict([1 2]);
            [a,b,c]=krig.Predict([1 2]);
            [a,b,c,d]=krig.Predict([1 2]);
        end
        
        function testErrorRBF(Test_metamodel)
            
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',true);   
            % Error on Optional inputs during parsing
            Test_metamodel.verifyError(@()RBF(obj,[],[],'corr','bobi'),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()RBF(obj,[],[],'estimator','bob'),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()RBF(obj,[],[],'hyp_corr',false),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()RBF(obj,[],[],'hyp_corr',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()RBF(obj,[],[],'lb_hyp_corr',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()RBF(obj,[],[],'lb_hyp_corr',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()RBF(obj,[],[],'ub_hyp_corr',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_metamodel.verifyError(@()RBF(obj,[],[],'ub_hyp_corr',[1;2]),'MATLAB:InputParser:ArgumentFailedValidation');

            % Wrong Optional input
            obj.Get_design(20);
            Test_metamodel.verifyWarning(@()RBF(obj,1,[],'bob',true),'SBDOT:Metamodel:unmatched')
            
            % Error on construction
            rbf=RBF(obj,1,[]);
            Test_metamodel.verifyTrue(isa(rbf,'RBF'));
            Test_metamodel.verifyEqual(rbf.y_ind,1);
            
            
            % Training test
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',true);   
            obj.Get_design(20);
            
            % corr
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrcubic');
            Test_metamodel.verifyEqual(rbf.corr,'Corrcubic');
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrgauss');
            Test_metamodel.verifyEqual(rbf.corr,'Corrgauss');
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrinvmultiquadric');
            Test_metamodel.verifyEqual(rbf.corr,'Corrinvmultiquadric');
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrlinear');
            Test_metamodel.verifyEqual(rbf.corr,'Corrlinear');
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrmatern32');
            Test_metamodel.verifyEqual(rbf.corr,'Corrmatern32');
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrmatern52');
            Test_metamodel.verifyEqual(rbf.corr,'Corrmatern52');
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrmultiquadric');
            Test_metamodel.verifyEqual(rbf.corr,'Corrmultiquadric');
            rbf = RBF( obj , 1 , [] , 'corr', 'Corrthinplatespline');
            Test_metamodel.verifyEqual(rbf.corr,'Corrthinplatespline');
            % estimator
            rbf = RBF( obj , 1 , [] , 'estimator', 'LOO');
            Test_metamodel.verifyEqual(rbf.estimator,'LOO');
            rbf = RBF( obj , 1 , [] , 'estimator', 'CV');
            Test_metamodel.verifyEqual(rbf.estimator,'CV');
            % hyp_corr
            rbf = RBF( obj , 1 , [] , 'hyp_corr', [0.5 0.5]);
            Test_metamodel.verifyEqual(rbf.hyp_corr,log10([0.5 0.5]));
            % lb_hyp_corr ub_hyp_corr
            rbf = RBF( obj , 1 , [] , 'lb_hyp_corr', [0.5 0.5], 'ub_hyp_corr', [1 1]);
            Test_metamodel.verifyEqual(rbf.hyp_corr_bounds,[0.5 1]);
            Test_metamodel.verifyEqual(rbf.lb_hyp_corr,log10([0.5 0.5]));
            Test_metamodel.verifyEqual(rbf.ub_hyp_corr,log10([1 1]));
            % optimizer
            rbf = RBF( obj , 1 , [] , 'optimizer', 'CMAES' );
            Test_metamodel.verifyEqual(rbf.optimizer,'CMAES');
            rbf = RBF( obj , 1 , [] , 'optimizer', 'fmincon' );
            Test_metamodel.verifyEqual(rbf.optimizer,'fmincon')
            
            rbf = RBF( obj , 1 , []);
            
            % Predict test
            Test_metamodel.verifyError(@()rbf.Predict([1 2 3 4]),'SBDOT:Metamodel:dimension_input');
            [a]=rbf.Predict([1 2]);
            [a,b]=rbf.Predict([1 2]);
            
        end
        
        function testErrorCokriging(Test_metamodel)
            
            prob_HF=Problem('Multifi_1D_HF',1,1,0,0,1);
            prob_LF=Problem('Multifi_1D_LF',1,1,0,0,1);
            prob=Problem_multifi(prob_LF,prob_HF);
            prob.Eval ([0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],'LF');
            prob.Eval ([0;0.4;0.6;1],'HF');
            
            % Wrong Optional input
            Test_metamodel.verifyWarning(@()Cokriging(prob,1,[],'bob',true),'SBDOT:Metamodel:unmatched')
            
            % Error on construction
            cokrig=Cokriging(prob,1,[]);
            Test_metamodel.verifyTrue(isa(cokrig,'Cokriging'));
            Test_metamodel.verifyEqual(cokrig.y_ind,1);                        
            
            % corr
            cokrig=Cokriging(prob,1,[], 'corr_LF','corrmatern32', 'corr_HF','corrmatern32');
            Test_metamodel.verifyEqual(cokrig.corr{1},@ooDACE.basisfunctions.corrmatern32);
            Test_metamodel.verifyEqual(cokrig.corr{2},@ooDACE.basisfunctions.corrmatern32);            
            % estimator
            cokrig=Cokriging(prob,1,[],'estim_hyp_LF',@pseudoLikelihood,'estim_hyp_HF',@marginalLikelihood);
            Test_metamodel.verifyEqual(cokrig.estim_hyp{1},@pseudoLikelihood);
            Test_metamodel.verifyEqual(cokrig.estim_hyp{2},@marginalLikelihood);            
            % hyp_corr
            cokrig=Cokriging(prob,1,[],'hyp_corr_LF',0.1,'hyp_corr_HF',0.1);
            Test_metamodel.verifyEqual(cokrig.hyp_corr,[0.1;0.1]);
            % lb_hyp_corr ub_hyp_corr
            cokrig=Cokriging(prob,1,[],'lb_hyp_corr_LF',0.1,'ub_hyp_corr_LF',0.5);
            Test_metamodel.verifyEqual(cokrig.hyp_corr_bounds{1},[0.1 0.5]);            
            % optimizer
            cokrig = Cokriging( prob , 1 , [] , 'go_opt_LF',true );
            Test_metamodel.verifyEqual(cokrig.go_opt{1},true);
                        
            % Predict test
            [a]=cokrig.Predict(0.2);
            [a,b]=cokrig.Predict(0.2);
            [a,b,c]=cokrig.Predict(0.2);
            [a,b,c,d]=cokrig.Predict(0.2);
            
        end
        
    end
    
end

