function [ error_value ] = Error_crit( obj , x )
%ERROR_CRIT MSE or IMSE computation

switch obj.crit_type
    
    case 'MSE'
        
        % Prediction error from metamodel at test point
        if obj.m_y >= 1
            [~,MSE_pred]=obj.meta_y.Predict(x);
        end
        
        if obj.m_g >= 1
            [~,MSE_pred]=obj.meta_g.Predict(x);
        end
        
        error_value = -MSE_pred;
        
    case 'IMSE'   
        
        if any ( ismembertol( obj.prob.x, x, obj.prob.tol_eval, 'Byrows', true) )
            
            error_value = NaN;
            
        else
            
            Add_data( obj.prob, x, ones(1,obj.prob.m_y), ones(1,obj.prob.m_g) )
            
            for i=1:obj.m_y
                obj.meta_y(i,:).Train();
            end
            
            for i=1:obj.m_g
                obj.meta_g(i,:).Train();
            end
            
            switch obj.prob.m_x
                case 1
                    
                    if obj.m_y >= 1
                       
                       % Example with trapz
                       % x_intgr = linspace(obj.prob.lb(1),obj.prob.ub(1),200);
                       % y_intgr = obj.Meta_int1(x_intgr);
                       % error_value = trapz(y_intgr);
                        
                        error_value = integral(@(x)obj.Meta_int1(x),...
                            obj.prob.lb(1), obj.prob.ub(1),...
                            'AbsTol',1e-5,'RelTol',1e-7);
                       
                       % Included in oodace
                       % error_value = obj.meta_y.k_oodace.imse;
                        
                    end
                    if obj.m_g >= 1
                        error_value = integral(@(x)obj.Meta_int1(x),...
                            obj.prob.lb, obj.prob.ub,...
                            'AbsTol',1e-5,'RelTol',1e-7);
                    end
                    
                case 2
                    
                    if obj.m_y >= 1
                        error_value = integral2(@(x,y)obj.Meta_int2(x,y),...
                            obj.prob.lb(1), obj.prob.ub(1),...
                            obj.prob.lb(2), obj.prob.ub(2),...
                            'AbsTol',1e-5,'RelTol',1e-7);
                    end
                    if obj.m_g >= 1
                        error_value = integral2(@(x,y)obj.Meta_int2(x,y),...
                            obj.prob.lb(1), obj.prob.ub(1),...
                            obj.prob.lb(2), obj.prob.ub(2),...
                            'AbsTol',1e-5,'RelTol',1e-7);
                    end
                    
                    
                case 3
                    
                    if obj.m_y >= 1
                        error_value = -integral3(@(x,y,z)obj.Meta_int2(x,y,z),...
                            obj.prob.lb(1), obj.prob.ub(1),...
                            obj.prob.lb(2), obj.prob.ub(2),...
                            obj.prob.lb(3), obj.prob.ub(3),...
                            'AbsTol',1e-5,'RelTol',1e-7);
                    end
                    if obj.m_g >= 1
                        error_value = -integral3(@(x,y,z)obj.Meta_int2(x,y,z),...
                            obj.prob.lb(1), obj.prob.ub(1),...
                            obj.prob.lb(2), obj.prob.ub(2),...
                            obj.prob.lb(3), obj.prob.ub(3),...
                            'AbsTol',1e-5,'RelTol',1e-7);
                    end
                    
                otherwise
                    error('SBDOT:Error_prediction:IMSE',...
                        'IMSE not supported for m_x > 3')
            end
            
            obj.prob.x(end,:)=[];
            
            if obj.prob.m_y >=1
                obj.prob.y(end,:)=[];
            else
                obj.prob.y=[];             
            end
            
            if obj.prob.m_g >=1
                obj.prob.g(end,:)=[];
            else
                obj.prob.g=[];
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


