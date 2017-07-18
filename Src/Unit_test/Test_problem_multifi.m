classdef Test_problem_multifi < matlab.unittest.TestCase
    %TEST_PROBLEM_mutlifi class : Unit test for class Problem_multifi
    %
    % Run test for Problem class before this one.
    %
    % Test list :
    % Constructor
    % - Error on Required inputs during parsing  
    % - Error on construction
    % Evaluation
    % - Error on Eval inputs during parsing
    % Sampling
    % - Failure with sampling
    
    properties
        
    end
    
    % Test Method Block
    methods (Test)
        
        function testErrorConstructor(Test_problem)
            
            % Error on Required inputs during parsing            
            Test_problem.verifyError(@()Problem_multifi([-5 0 0],[10 15]),'MATLAB:InputParser:ArgumentFailedValidation');
            
            % Error on construction
            obj_HF=Problem('Multifi_1D_HF',1,1,0,0,1);
            
            obj_LF=Problem('Multifi_1D_LF',2,1,0,[0 0],[1 1]);
            Test_problem.verifyError(@()Problem_multifi(obj_LF,obj_HF),...
                'SBDOT:Problem_multify:dimension_input');
            
            obj_LF=Problem('Multifi_1D_LF',1,2,0,0,1);
            Test_problem.verifyError(@()Problem_multifi(obj_LF,obj_HF),...
                'SBDOT:Problem_multify:dimension_objective');
            
            obj_LF=Problem('Multifi_1D_LF',1,1,1,0,1);
            Test_problem.verifyError(@()Problem_multifi(obj_LF,obj_HF),...
                'SBDOT:Problem_multify:dimension_constraint');
            
            obj_LF=Problem('Multifi_1D_LF',1,1,0,0.5,1);
            Test_problem.verifyError(@()Problem_multifi(obj_LF,obj_HF),...
                'SBDOT:Problem_multify:lb_difference');
            
            obj_LF=Problem('Multifi_1D_LF',1,1,0,0,1.5);
            Test_problem.verifyError(@()Problem_multifi(obj_LF,obj_HF),...
                'SBDOT:Problem_multify:ub_difference');
            
            obj_HF=Problem('Multifi_1D_HF',1,1,0,0,1);
            obj_LF=Problem('Multifi_1D_LF',1,1,0,0,1);
            obj=Problem_multifi(obj_LF,obj_HF);
            Test_problem.verifyTrue(isa(obj,'Problem_multifi'));
            
        end
        
        function testErrorEvaluation(Test_problem)
            
            % Which model eval...
            obj_HF=Problem('Multifi_1D_HF',1,1,0,0,1);
            obj_LF=Problem('Multifi_1D_LF',1,1,0,0,1);
            obj=Problem_multifi(obj_LF,obj_HF);
            Test_problem.verifyError(@()obj.Eval(0.5,'bob'),'SBDOT:Eval_multifi:which_pb');
            
        end
        
        function testErrorSampling(Test_problem)
            
            % Failure with sampling
            obj_HF=Problem('Multifi_1D_HF',1,1,0,0,1);
            obj_LF=Problem('Multifi_1D_LF',1,1,0,0,1);
            obj=Problem_multifi(obj_LF,obj_HF);
            obj.Sampling(20,5);            
            Test_problem.verifyEqual(obj.prob_HF.n_x,5);
            Test_problem.verifyEqual(obj.prob_LF.n_x,20);
            
            obj_HF=Problem('Multifi_1D_HF',1,1,0,0,1);
            obj_LF=Problem('Multifi_1D_LF',1,1,0,0,1);
            obj=Problem_multifi(obj_LF,obj_HF);
            obj.Sampling(20,5,'LHS');
            Test_problem.verifyEqual(obj.prob_HF.n_x,5);
            Test_problem.verifyEqual(obj.prob_LF.n_x,20);
            
            Test_problem.verifyError(@()obj.Sampling(20,5,'TRI'),'SBDOT:Sampling_multifi:type');
               
            obj_HF=Problem('Multifi_1D_HF',1,1,0,0,1);
            obj_LF=Problem('Multifi_1D_LF',1,1,0,0,1);
            obj=Problem_multifi(obj_LF,obj_HF);
            obj.Eval(0.5,'ALL');
            Test_problem.verifyEqual(obj.prob_HF.x,0.5);
            Test_problem.verifyEqual(obj.prob_LF.x,0.5);
            
        end
    end
    
end

