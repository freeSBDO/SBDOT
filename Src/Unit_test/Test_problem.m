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
    % - Evaluate same point twice error
    % - Differences between specification and reality
    % - Evaluation failure
    % Sampling
    % - Failure with sampling
    % Test coverage
    % - Parallel evaluation
    % - Saving file
    % - Round input before evaluation
    
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
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15],'tol_eval',true),'MATLAB:InputParser:ArgumentFailedValidation');
            Test_problem.verifyError(@()Problem('Branin',2,1,1,[-5 0],[10 15],'save_file',true),'MATLAB:InputParser:ArgumentFailedValidation');

            % Wrong Optional input
            Test_problem.verifyWarning(@()Problem('Branin',2,1,1,[-5 0],[10 15],'bob',true),'SBDOT:Problem:unmatched')
            
            % Error on construction
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            Test_problem.verifyTrue(isa(obj,'Problem'));
            Test_problem.verifyEqual(obj.m_x,2);
            Test_problem.verifyEqual(obj.m_y,1);
            Test_problem.verifyEqual(obj.m_g,1);
            Test_problem.verifyEqual(obj.lb,[-5 0]);
            Test_problem.verifyEqual(obj.ub,[10 15]);
            
        end
        
        function testErrorEvaluation(Test_problem)
            
            % Error on Eval inputs during parsing
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);            
            Test_problem.verifyError(@()obj.Eval([16 18]),'SBDOT:Problem:eval_bound');
            Test_problem.verifyError(@()obj.Eval([0 0;0 0]),'SBDOT:Problem:eval_notunique');
            Test_problem.verifyError(@()obj.Eval([0 0 0 0]),'SBDOT:Problem:dimension_input');
            
            % Evaluate same point twice error
            obj.Eval([0 0]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:already_eval');       
            
            % Differences between specification and reality of the simulator
            obj=Problem('Branin',2,2,1,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:dimension_output');
            obj=Problem('Branin',2,1,2,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:dimension_constraint');
            obj=Problem(@(x)(sum(x,2)),2,1,1,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');

            % Evaluation failure
            obj=Problem('bobi',2,1,1,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');
            obj=Problem(deal(@(x)({x(1)+1 2 3 4})),2,2,1,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'round',true,'round_range',[0.01 0.01 0.01]);
            Test_problem.verifyError(@()obj.Eval([0.002 0.002]),'SBDOT:Round_data:round_range');
                % Unknow error from the simulator for/parallel eval
            obj=Problem(@(x)(error('bob')),2,1,1,[-5 0],[10 15]);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');
            obj=Problem(@(x)(error('bob')),2,1,1,[-5 0],[10 15],'parallel',true);
            Test_problem.verifyError(@()obj.Eval([0 0]),'SBDOT:Problem:eval_failed');
            
        end
        
        function testErrorSampling(Test_problem)
            
            % Failure with sampling
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            obj.Sampling(20);
            Test_problem.verifyEqual(obj.n_x,20);
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            obj.Sampling(20,'LHS');
            Test_problem.verifyEqual(obj.n_x,20);
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            obj.Sampling(20,'Sobol');
            Test_problem.verifyEqual(obj.n_x,20);
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            obj.Sampling(20,'Halton');
            Test_problem.verifyEqual(obj.n_x,20);
            Test_problem.verifyError(@()obj.Sampling(20,'TRI'),'SBDOT:Sampling:type');
                     
        end
        
        function testCoverage(Test_problem)
            
            obj=Problem('Branin',2,1,1,[-5 0],[10 15]);
            obj.Eval([-5 0]);
            obj.Eval([0 0]);
            Test_problem.verifyEqual(obj.n_x,2);
            
            obj=Problem('Branin',2,1,0,[-5 0],[10 15],'parallel',true);
            obj.Sampling(20);
            
            obj=Problem('Branin',2,1,0,[-5 0],[10 15]);
            obj.Sampling(20);
                        
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'save_file','bobi');
            obj.Sampling(20);
            delete('bobi.mat')
            
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'parallel',true,'save_file','bobi');
            obj.Sampling(20);
            delete('bobi.mat')
            
            obj=Problem('Branin',2,1,1,[-5 0],[10 15],'round',true,'round_range',[0.01 0.01]);
            obj.Eval([0.002 0.002]);
            Test_problem.verifyEqual(obj.x,[0 0]);

        end
    end
    
end

