function B = vect2full(sz, Vect, k)
    % VECT2FULL transform a vector into its corresponding full symmetric matrix
    % 
    %   Inputs:
    %       sz corresponds to the size of the full matrix
    %       Vect is the vector of interest
    %       k is (like in tril function) defining the position of the first non-null diagonal
    %
    %   Output:
    %       B is the corresponding full matrix
    %
    % Syntax:
    %   B = vect2full( sz, Vect, k );
    
    A = tril(ones(sz), k);
    A(~~A)=Vect;
    
    B = A + A';
    B(1:sz+1:end) = diag(A);
    
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


