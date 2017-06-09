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
            Test_metamodel.verifyError(@()Kriging('bob',1,[]),'MATLAB:invalidConversion');
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
            obj.Sampling(20);
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'bob',true),'SBDOT:Metamodel:unmatched')
            
            % Error on construction
            krig=Kriging(obj,1,[]);
            Test_metamodel.verifyTrue(isa(krig,'Kriging'));
            Test_metamodel.verifyEqual(krig.y_ind,1);
            
            
            % Training test
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',true);   
            Test_metamodel.verifyError(@()Kriging(obj,1,[]),'SBDOT:Metamodel:EmptyTrain');
            obj.Sampling(20);
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'ub_hyp_corr',[1,2]),'SBDOT:Kriging:HypBounds_miss');
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'lb_hyp_corr',[1,2]),'SBDOT:Kriging:HypBounds_miss');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'lb_hyp_corr',[2 2],'ub_hyp_corr',[1 1]),'SBDOT:Kriging:HypBounds');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'lb_hyp_corr',[2 2 2],'ub_hyp_corr',[1 1]),'SBDOT:Kriging:HypBounds_size');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'lb_hyp_corr',[2 2],'ub_hyp_corr',[1 1 1]),'SBDOT:Kriging:HypBounds_size');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'hyp_corr',[1 1 1]),'SBDOT:Kriging:Hyp_val_size');
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'reg',true,'ub_hyp_reg',1),'SBDOT:Kriging:RegBounds_miss');
            Test_metamodel.verifyWarning(@()Kriging(obj,1,[],'reg',true,'lb_hyp_reg',1),'SBDOT:Kriging:RegBounds_miss');
            Test_metamodel.verifyError(@()Kriging(obj,1,[],'reg',true,'ub_hyp_reg',0,'lb_hyp_reg',1),'SBDOT:Kriging:RegBounds');
            Kriging(obj,1,[],'reg',true,'hyp_reg',1e-5)
            Kriging(obj,1,[],'reg',true,'hyp_corr',[0.2 0.2])
            
            % Predict test
            krig=Kriging(obj,1,[]);
            Test_metamodel.verifyError(@()krig.Predict([1 2 3 4]),'SBDOT:Metamodel:dimension_input');
            [a]=krig.Predict([1 2]);
            [a,b]=krig.Predict([1 2]);
            [a,b,c]=krig.Predict([1 2]);
            [a,b,c,d]=krig.Predict([1 2]);
        end
        
    end
    
end

