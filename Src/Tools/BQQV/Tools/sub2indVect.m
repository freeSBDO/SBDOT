function Ind = sub2indVect( siz, Sub )
    % SUB2INDVECT extend sub2ind native matlab function to accept parallel computing
    % 
    %   Inputs:
    %       siz is a vector corresponding to the size of the matrix of interest
    %       sub is a vector which contains row subscripts
    %
    %   Output:
    %       Ind is a vector of scalar index
    %
    % Syntax:
    %   Ind = sub2indVect ( siz, Sub );
    
    Sub = num2cell(Sub);
    Ind = arrayfun(@(i) sub2ind(siz, Sub{i,:}), 1:size(Sub, 1));
    
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


