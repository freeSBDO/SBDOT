function [] = Clean( obj , type )
% CLEAN 
%   Delete some parameter variables for re-estimation
%   - type is a cell of string depending on variables to clean
%   'all', 'corr_HF', 'corr_LF', 'rho'
%
%   Syntax examples :
%       obj.Clean({'all'});
%       obj.Clean({'corr'});
if strcmp(type{1},'all')
    type = {'corr_HF','corr_LF','rho'};
end


for i=1:length(type)
    
    switch type{i}
        
        case 'corr_HF'
            
            obj.hyp_corr{2} = [];
            obj.lb_hyp_corr{2} = [];
            obj.ub_hyp_corr{2} = [];
            obj.hyp_corr0{2} = [];
            
        case 'corr_LF'
            
            obj.hyp_corr{1} = [];
            obj.lb_hyp_corr{1} = [];
            obj.ub_hyp_corr{1} = [];
            obj.hyp_corr0{1} = [];
                        
        case 'rho'
            
            obj.rho = [];
            obj.lb_rho = [];
            obj.ub_rho = [];
            
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


