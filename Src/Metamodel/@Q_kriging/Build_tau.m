function Tau = Build_tau( ~, HS_Coord, m, type, D_chol )
    % BUILD_TAU transforms tau elements from hypershperic coordinates to
    % cartesian
    %
    %   Inputs:
    %       HS_Coord is a sum(m.*(m-1)/2) vector of hypershperical coordinates
    %       m is the m_t property of object Q_problem
    %       type is the tau_type property of object Q_kriging
    %       D_chol is a sum(m) vector of heteroskedasticity values (empty if tau_type not 'heteroskedasticity)
    %
    %   Output:
    %       Tau is a sum((m+1).*m/2) vector of tau coefficients
    %
    % Syntax :
    % Tau = obj.Build_tau( HS_Coord, m, type, D_chol );

    if strcmp(type,'isotropic')
        
        Tau = HS_Coord*ones(sum(1:(m-1)),1);
        Tau = vect2tril(m,Tau,-1) + eye(m);
        I = true(size(Tau));
        Tau = Tau(tril(I));
        
    else
        % For qualitative variable with just 2 levels, computation change
        if (m==2)
            
            if strcmp(type,'heteroskedastic')
                
                Tau = [D_chol(1);D_chol(1)*cos(HS_Coord);D_chol(1)*cos(HS_Coord)^2+D_chol(2)*sin(HS_Coord)^2];
                
            else
                
                Tau = [1;cos(HS_Coord);1];
                
            end
            
        else
            
            rgu = arrayfun(@(x) sum(1:x),2:m);
            rgl = [2, rgu(1:(size(rgu,2)-1))+1];
            l = arrayfun(@(x) [hypersph2cart([1;HS_Coord(rgl(x):rgu(x))]); zeros(m-(x+2),1)], 1:(m-2), 'UniformOutput', false);
            L = [[1, zeros(1,m-1)]; [cos(HS_Coord(1)), sin(HS_Coord(1)), zeros(1,m-2)]; cell2mat(l)'];
            
            if strcmp(type,'heteroskedastic')
              
%               Tau = L*diag(D_chol)*L';
              D_mat = D_chol'*D_chol;
              Tau = D_mat.*(L*L');
              
                  
            else
                
                Tau = L*L';
                
            end
            
            I = true(size(Tau));
            Tau = Tau(tril(I));
            
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


