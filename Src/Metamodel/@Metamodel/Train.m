function [] = Train( obj )
% TRAIN 
%   Learn the statistical relationship of the data
%   Here it is mainly assertions
%
% Syntax :
% []=obj.train();

switch class(obj.prob)
    case 'Problem'
        
        assert( obj.prob.n_x >= 2 ,...
            'SBDOT:Metamodel:EmptyTrain',...
            'Problem object must contained at least 2 training points');
        
    case 'Problem_multifi'
        
        assert( obj.prob.prob_HF.n_x >= 2 ,...
            'SBDOT:Metamodel:EmptyTrain',...
            'High Fidelity Problem object must contained at least 2 training points');
        
        assert( obj.prob.prob_LF.n_x >= 2 ,...
            'SBDOT:Metamodel:EmptyTrain',...
            'Low Fidelity Problem object must contained at least 2 training points');
        
    case 'Q_problem'
        
        assert( all ( obj.prob.n_x >= 2 ) ,...
            'SBDOT:Metamodel:EmptyTrain',...
            'Problem object must contained at least 2 training points');
end

obj.Update_training_data();

end

