classdef Test_problem < matlab.unittest.TestCase
    %TEST_PROBLEM class : Unit test for class Problem
    % Test list :
    % Constructor
    % - Error on Required inputs during parsing  
    % - Error on bounds dimension 
    % - Error on Optional inputs during parsing
    % - Wrong Optional input
    % - Error on construction
    % Evaluation
    % - Error on Eval inputs during parsing
    % - Differences between specification and reality
    % - Evaluation failure
    % Sampling
    % - Failure with sampling
    
    properties
        
    end
    
    % Test Method Block
    methods (Test)
        
        function testErrorConstructor(Test_problem)
            
            % Error on Required inputs during parsing            
            Test_problem.verifyError(@()Problem(1,2,1,1,[-5 0 0],[10 15]),'MATLAB:invalidType');
            Test_problem.verifyError(@()Problem('Branin','2',1,1,[-5 0],[10 15]),'MATLAB:invalidType');
            Test_problem.verifyError(@()Problem('Branin',2,'1',1,[-5 0],[10 15]),'MATLAB:invalidType');
            Test_problem.verifyError(@()Problem('Branin',2,1,'1',[-5 0],[10 15]),'MATLAB:invalidType');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0]',[10 15]),'MATLAB:expectedRow');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15]'),'MATLAB:expectedRow');
            
            % Error on bounds dimension 
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 10 0],[0 15]),'SBDOT:Problem:lb_argument');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 10],[0 15 0]),'SBDOT:Problem:ub_argument');
            
            % Error on Optional inputs during parsing
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',1),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15],'display','bob'),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15],'round',1),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15],'round_range',false),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15],'Tol_eval',true),'MATLAB:InputParser:ArgumentFailedValidation');
            
            % Wrong Optional input
            Test_problem.verifyWarning(@()Problem('Branin',2,1,1,[-5 0],[10 15],'bob',true),'SBDOT:Problem:unmatched')
            
            % Error on construction
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            Test_problem.verifyTrue(isa(obj,'Problem'));
            
        end
        
        function testErrorEvaluation(Test_problem)
            
            % Error on Eval inputs during parsing
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);            
            Test_problem.verifyError(@()obj.Eval([16 18]),'SBDOT:Problem:eval_bound');
            Test_problem.verifyError(@()obj.Eval([0 0;0 0]),'SBDOT:Problem:eval_notunique');
            Test_problem.verifyError(@()obj.Eval([0 0 0 0]),'SBDOT:Problem:dimension_input');

            % Differences between specification and reality
            obj=Problem('Branin',2,2,1,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:dimension_output');
            obj=Problem('Branin',2,1,2,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:dimension_constraint');
            
            % Evaluation failure
            obj=Problem('bobi',2,1,1,[-5 0],[10 15]);            
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');
            obj=Problem(@(x)(error('blob')),2,1,1,[-5 0],[10 15]); 
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');
            obj=Problem(@(x)(error('blob')),2,1,1,[-5 0],[10 15]); 
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');
            obj=Problem(deal(@(x)({x(1)+1 2 3 4})),2,2,1,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');

        end
        
        function testErrorSampling(Test_problem)
            
            % Failure with sampling
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            obj.Sampling(20);
            Test_problem.verifyEqual(obj.n_x,20);
            Test_problem.verifyError(@()obj.Sampling(20,'TRI'),'SBDOT:Sampling:type');
                     
        end
    end
    
end

