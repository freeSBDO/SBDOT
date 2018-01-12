function [ y_eval, g_eval, x_eval ] = Eval( obj, x_eval, which_pb )
    % EVAL Evaluates the problem function at x_eval
    %   *x_eval is a n_eval by m_x matrix
    %
    % Syntax :
    % []=obj.Eval(x_eval, which_pb);

    switch which_pb
        
        case 'HF'
            
            [ y_eval, g_eval, x_eval ] = obj.prob_HF.Eval( x_eval );
            
        case 'LF'
            
            [ y_eval, g_eval, x_eval ] = obj.prob_LF.Eval( x_eval );
            
        case 'ALL'
            
            obj.prob_LF.Eval( x_eval );
            [ y_eval, g_eval, x_eval ] = obj.prob_HF.Eval( x_eval );
            
            
        otherwise
            
            error( 'SBDOT:Eval_multifi:which_pb',...
                ['You specified a wrong problem to evaluate, ',...
                'choose between ''HF'', ''LF'' or ''ALL''.'] )
            
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


