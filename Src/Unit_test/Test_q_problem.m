classdef Test_q_problem < matlab.unittest.TestCase
    %TEST_PROBLEM class : Unit test for class Problem
    % Test list :
    % Constructor
    % - Error on Required inputs during parsing  
    % - Error on construction
    % Evaluation
    % - Error on Eval inputs during parsing
    % - Evaluate same point twice error
    % - Wrong Format for Adding Data
    % Test coverage
    % - Parallel evaluation
    % - Saving file
    % - Round input before evaluation
    
    properties
        
    end
    
    % Test Method Block
    methods (Test)
        
        function testErrorConstructor(Test_q_problem)
            
            % Error on Required inputs during parsing
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', 't', 2, 1, 0, [2,3,2,3], [0, 0], [1, 1]),'MATLAB:invalidType');
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', {['s';'t'],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]},...
                2, 1, 0, [2,3,2,3], [0, 0], [1, 1]),'MATLAB:invalidType');
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', {[1,2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]},...
                2, 1, 0, [2,3,2,3], [0, 0], [1, 1]),'MATLAB:expectedColumn');
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', {[1;2;3],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]},...
                2, 1, 0, [2,3,2,3], [0, 0], [1, 1]),'MATLAB:incorrectSize');
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]},...
                2, 1, 0, 'm_t', [0, 0], [1, 1]),'MATLAB:invalidType');
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', {1,[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]},...
                2, 1, 0, [1,3,2,3], [0, 0], [1, 1]),'SBDOT:Q_problem:insuficient_levels');
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]},...
                2, 1, 0, [2,3,2,3]', [0, 0], [1, 1]),'MATLAB:expectedRow');
            Test_q_problem.verifyError(@()Q_problem('Q_sin_cos', {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]}',...
                2, 1, 0, [2,3,2,3], [0, 0], [1, 1]),'MATLAB:expectedRow');

            % Error on construction
            obj=Q_problem('Q_sin_cos', {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]}, 2, 1, 0, [2,3,2,3], [0, 0], [1, 1]);
            Test_q_problem.verifyTrue(isa(obj,'Q_problem'));
            Test_q_problem.verifyEqual(obj.t,{[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]});
            Test_q_problem.verifyEqual(obj.m_t,[2,3,2,3]);
            
        end
        
        function testErrorEvaluation(Test_q_problem)
            
            % Error on Eval inputs during parsing
            obj=Q_problem('Q_sin_cos', {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]}, 2, 1, 0, [2,3,2,3], [0, 0], [1, 1]);          
            Test_q_problem.verifyError(@()obj.Eval([1,zeros(1,35)],{[16,18,1,0.5,0.6,0.7]}),'SBDOT:Q_problem:eval_bound');
            Test_q_problem.verifyError(@()obj.Eval([1,zeros(1,35)],{[0.5,0.5,3,0.5,0.6,0.7]}),'SBDOT:Q_problem:wrong_q_levels');
            Test_q_problem.verifyError(@()obj.Eval([1,zeros(1,34)],{[0.5,0.5,2,0.5,0.6,0.7]}),'SBDOT:Q_problem:sample_size_specifications');
            Test_q_problem.verifyError(@()obj.Eval([1,zeros(1,35)]',{[0.5,0.5,2,0.5,0.6,0.7]}),'MATLAB:expectedRow');
            Test_q_problem.verifyError(@()obj.Eval([],{[0.5,0.5,2,0.5,0.6,0.7]}),'MATLAB:expectedNonempty');
            Test_q_problem.verifyError(@()obj.Eval([-1,zeros(1,35)],{[0.5,0.5,2,0.5,0.6,0.7]}),'MATLAB:expectedNonnegative');
            Test_q_problem.verifyError(@()obj.Eval('s',{[0.5,0.5,2,0.5,0.6,0.7]}),'MATLAB:invalidType');
            
            % Evaluate same point twice error
            obj.Eval([1,zeros(1,35)],{[0.6,0.7,1,0.5,0.6,0.7]});
            Test_q_problem.verifyError(@()obj.Eval([1,zeros(1,35)],{[0.6,0.7,1,0.5,0.6,0.7]}),'SBDOT:Q_problem:already_eval');
            
            % Error on Add_data due to format
            obj=Q_problem('Q_sin_cos', {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]}, 2, 1, 0, [2,3,2,3], [0, 0], [1, 1]);
            Test_q_problem.verifyError(@()obj.Eval([1,zeros(1,35)],{[0.6,0.7,2,0.5,0.6,0.7]}),'SBDOT:Q_problem:wrong_data_format_for_adding');
        end
        
        function testCoverage(Test_q_problem)
            
            t = {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]};
            m_x = 2;
            m_y = 1;
            m_g = 0;
            m_t = [2,3,2,3];
            lb = [0, 0]; ub = [1, 1];
            
            obj=Q_problem('Q_sin_cos', t, m_x, m_y, m_g, m_t, lb, ub);
            obj.Eval([1,zeros(1,35)],{[0.5,0.5,1,0.5,0.6,0.7]});
            obj.Eval([0,1,zeros(1,34)],{[0.5,0.53,2,0.5,0.6,0.7]});
            Test_q_problem.verifyEqual(obj.n_x,[1,1,zeros(1,34)]);
            
            obj=Q_problem('Q_sin_cos', t, m_x, m_y, m_g, m_t, lb, ub,...
                'parallel', true);
            obj.Get_design(20);
            
            obj=Q_problem('Q_sin_cos', t, m_x, m_y, m_g, m_t, lb, ub);
            obj.Get_design(20);
                        
            obj=Q_problem('Q_sin_cos', t, m_x, m_y, m_g, m_t, lb, ub,...
                'save_file', 'bobi');
            obj.Get_design(20);
            delete('bobi.mat')
            
            obj=Q_problem('Q_sin_cos', t, m_x, m_y, m_g, m_t, lb, ub,...
                'parallel', true, 'save_file', 'bobi');
            obj.Get_design(20);
            delete('bobi.mat')
            
            obj=Q_problem('Q_sin_cos', t, m_x, m_y, m_g, m_t, lb, ub,...
                'round',true,'round_range',[0.1 0.1]);
            obj.Eval([1,zeros(1,35)],{[0.002,0.002,1,0.5,0.6,0.7]});
            Test_q_problem.verifyEqual(obj.x{1},[0,0,1,0.5,0.6,0.7]);

        end
    end
    
end

