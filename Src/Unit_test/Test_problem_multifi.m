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





% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


