function [] = Update_training_data( obj )
% UPDATE_TRAINING_DATA
%   Process input and output data before training
%
% Syntax :
% []=obj.update_training_data();

switch class( obj.prob )
    
    case 'Problem'
        
        obj.x_train = Scale_data( obj.prob.x, obj.prob.lb, obj.prob.ub);
        obj.f_train = [ obj.prob.y( :, obj.y_ind ),...
            obj.prob.g(:,obj.g_ind) ];
        % If a shift is asked :
        if ~isempty( obj.shift_output )
            obj.f_train = obj.f_train .* obj.shift_output(:,1)...
                + obj.shift_output(:,2);
        end
        
    case 'Problem_multifi'
        
        obj.x_train{1,1} = Scale_data( obj.prob.prob_LF.x,...
            obj.prob.lb, obj.prob.ub );
        obj.x_train{2,1} = Scale_data( obj.prob.prob_HF.x,...
            obj.prob.lb, obj.prob.ub );
        
        obj.f_train{1,1} = [ obj.prob.prob_LF.y( :, obj.y_ind ),...
            obj.prob.prob_LF.g(:,obj.g_ind) ];
        obj.f_train{2,1} = [ obj.prob.prob_HF.y( :, obj.y_ind ),...
            obj.prob.prob_HF.g(:,obj.g_ind) ];
        
        % If a shift is asked :
        if ~isempty( obj.shift_output )
            obj.f_train{1} = obj.f_train{1} .* obj.shift_output(:,1)...
                + obj.shift_output(:,2);
            obj.f_train{2} = obj.f_train{2} .* obj.shift_output(:,1)...
                + obj.shift_output(:,2);
        end
        
    case 'Q_problem'
        
        for i = 1:prod(obj.prob.m_t)
            obj.x_train{i} = [Scale_data( obj.prob.x{i}(:,1:obj.prob.m_x),...
                obj.prob.lb, obj.prob.ub), obj.prob.x{i}(:,(obj.prob.m_x+1):end)];
            
            if obj.prob.m_g == 0
                obj.f_train{i} = obj.prob.y{i}(:,obj.y_ind);
            elseif obj.prob.m_y == 0
                obj.f_train{i} = obj.prob.g{i}(:,obj.g_ind);
            else
                obj.f_train{i} = [obj.prob.y{i}(:,obj.y_ind), obj.prob.g{i}(:,obj.g_ind)];
            end
            
            % If a shift is asked :
            if ~isempty( obj.shift_output )
                obj.f_train{i} = obj.f_train{i} .* obj.shift_output(1)...
                    + obj.shift_output(2);
            end
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


