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


