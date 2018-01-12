function [] = Eval_error_handling( obj, ME, x_eval )
    %EVAL_ERROR_HANDLING Throw custom errors
    %   *ME is the error object
    %   *x_eval is the input vector that failed
    %
    % Syntax :
    % obj.Eval_error_handling( ME, x_eval );

    switch ME.identifier
        
        case 'MATLAB:UndefinedFunction'
            
            throw(MException('SBDOT:Problem:eval_failed', ...
                ['Evaluation failed at x = [',num2str(x_eval),']\n', ...
                ME.message,...
                'Check function_name variable or ensure that your function is in the Matlab path']));
        
        case 'MATLAB:maxlhs'
            
            throw(MException('SBDOT:Problem:eval_failed', ...
                ['Evaluation failed at x = [',num2str(x_eval),']\n', ...
                'Your evaluation function only have one or less output argument but you set the number of constraints to ',num2str(obj.m_g),'.\n', ...
                'Change your evaluation function by adding an output argument for constraints or set m_g variable to 0']));
        
        otherwise
            
            throw(MException('SBDOT:Problem:eval_failed', ...
                ['Evaluation failed at x = [',num2str(x_eval),']\n', ...
                ME.message, '\n', ...
                ME.stack(1).file,'\n', ME.stack(1).name,'\n', num2str(ME.stack(1).line)]));
            
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


