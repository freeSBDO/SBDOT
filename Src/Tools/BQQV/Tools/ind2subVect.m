function out = ind2subVect (siz,ndx)
    % IND2SUBVECT extend ind2sub native matlab function to accept parallel computing
    % 
    %   Inputs:
    %       siz is a vector corresponding to the size of the matrix of interest
    %       ndx is a vector which contains the scalar indices
    %
    %   Output:
    %       out is a matrix of size: ndx by siz, whom rows contain the corresponding subscripts
    %
    % Syntax:
    %   tau = ind2subVect(m_t, ind);

    [out{1:length(siz)}] = ind2sub(siz,ndx);
    out = cell2mat(cellfun(@transpose,out,'UniformOutput',false));
    
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


