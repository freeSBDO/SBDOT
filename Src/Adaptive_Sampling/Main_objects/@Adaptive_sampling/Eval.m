function [] = Eval( obj )
    % EVAL Evaluate the problem at obj.x_new and update the metamodel
    %
    % Syntax :
    %   obj.eval_function()

    try
        
        % Trim number of x_new before evaluation depending on fcalls available
        if ~isempty(obj.fcall_max)
            
            fcall_left = obj.fcall_max - obj.fcall_num;
            
            if size( obj.x_new, 1 ) > fcall_left
                
                obj.x_new( fcall_left+1 : end, : ) = [];
                
            end
        end

        % Evaluation
        if isa( obj.prob , 'Q_problem')
            
            if size( obj.x_new, 1 ) > 1
                
                q_val = cell2mat(arrayfun(@(k) obj.prob.t{k}(ind2subVect(obj.prob.m_t,obj.x_new(:,obj.prob.m_x+k))), 1:length(obj.prob.m_t), 'UniformOutput', false));
                
                num_x = zeros(1,prod(obj.prob.m_t));
                
                for i = 1:prod(obj.prob.m_t)
                    
                    if length(obj.prob.m_t) > 1
                        num_x(i) = sum(sub2indVect(obj.prob.m_t,obj.x_new(:,obj.prob.m_x+1:end)) == i);
                    else
                        num_x(i) = sum(obj.x_new(:,obj.prob.m_x+1) == i);
                    end
                    
                end
                
                if length(obj.prob.m_t) > 1
                    [~,ord] = sort(sub2indVect(obj.x_new(:,obj.prob.m_x+1:end)));
                else
                    [~,ord] = sort(obj.x_new(:,obj.prob.m_x+1));
                end
                
                x_add = [obj.x_new(ord,1:obj.prob.m_x), q_val(ord)];
                
            else

                q_val = arrayfun(@(k) obj.prob.t{k}(ind2subVect(obj.prob.m_t,obj.x_new(obj.prob.m_x+k))), 1:length(obj.prob.m_t));
                num_x = zeros(1,prod(obj.prob.m_t));
                num_x(obj.x_new(obj.prob.m_x+1)) = 1;
                x_add = [obj.x_new(:,1:obj.prob.m_x), q_val];
                
            end
            
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( num_x, x_add );
            
        elseif isa( obj.prob , 'Problem_multifi')
            
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( obj.x_new, obj.eval_type );
            
        else
            
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( obj.x_new );
            
        end
        
        obj.x_new = x_eval;
        y_new = y_eval( :, obj.y_ind );
        g_new = g_eval( :, obj.g_ind );

        % Update objective training dataset, kriging and history
        obj.hist.x = [ obj.hist.x ; obj.x_new ];
        
        if obj.m_y >= 1
            
            for i = 1 : obj.m_y
                
                obj.meta_y(i,:).Clean({'all'});
                obj.meta_y(i,:).Train();
                
            end
            
            obj.hist.y = [ obj.hist.y ; y_new ];
            
        end    

        % Update constraint...
        if obj.m_g >= 1
            
            for i = 1 : obj.m_g
                
                obj.meta_g(i,:).Clean({'all'});
                obj.meta_g(i,:).Train();
                
            end
            
            obj.hist.g = [ obj.hist.g ; g_new ];
            
        end

        obj.fcall_num = obj.fcall_num + size(x_eval,1);
        
    catch ME
        
        obj.failed = true;
        warning('off','backtrace')
        warning('Optimization stops prematurely during evaluation of the problem function !')
        warning(ME.message);
        fprintf(['Optimization failed at iteration ',num2str(obj.iter_num),' !\n\n']);
        
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


