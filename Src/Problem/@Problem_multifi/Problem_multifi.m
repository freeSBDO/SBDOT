classdef Problem_multifi < handle
    % PROBLEM_MULTIFI class
    % Define the features of the model to later use for multifidelity 
    % metamodeling or optimization purpose.
    
    properties
        
        % Mandatory inputs
        prob_HF     % High fidelity model Problem object
        prob_LF     % Low fidelity model Problem object
        
        % Constructed inputs
        display     % Logical, displaying information (true = allowed)
        m_x         % Dimension of the input space
        m_y         % Number of objectives
        m_g         % Number of contraints                
        lb          % Lower bound of input space (row vector 1 by m_x)
        ub          % Upper bound of input space (row vector 1 by m_x)
        
    end
    
    methods
        
        function obj = Problem_multifi( prob_LF, prob_HF )
            % Problem_multifi constructor
            % Initialized a Problem_multifi object with mandatory inputs :
            % 	obj=Problem( prob_LF, prob_HF)
            
            % Parser for input validation
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('prob_LF',@(x)isa(x,'Problem'))
            p.addRequired('prob_HF',@(x)isa(x,'Problem'))
            p.parse( prob_LF, prob_HF)
            in = p.Results;
                                        
            % Store            
            obj.prob_LF = in.prob_LF;
            obj.prob_HF = in.prob_HF;
            
            % Check that HF and LF problem have the same parameters
            obj.Check_pb();
            
            obj.display = obj.prob_HF.display;
            obj.prob_LF.display = false;
            obj.prob_HF.display = false;
            
            % Display
            if obj.display
                fprintf(['\nMultifidelity Problem object successfully constructed with: \n',...
                    num2str(obj.m_x),' design variable(s), ',...
                    num2str(obj.m_y),' objective(s) and ',...
                    num2str(obj.m_g),' constraint(s).\n\n'])
            end
            
        end
        
        [] = Sampling( obj, num_x_LF, num_x_HF, type );
        
        [ y_eval, g_eval, x_eval ] = Eval( obj, x_eval, which_pb );
        
    end
    
end

