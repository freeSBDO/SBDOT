function [degrees, usedIdx] = Generate_degrees( obj, dj )
    % GENERATE_DEGREES the vandermonde matrix of degrees for regression
    % fitting
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       dj is the regression maximum possible order 
    %
    %   Output:
    %       degrees vandermonde matrix of degrees
    %
    % Syntax :
    % [degrees, useIdx] = obj.Generate_degrees( dj );    
    
    % preprocessing
    if ~iscell( dj )
        dim = obj.prob.m_x + length(obj.prob.m_t);
        
        % special case: pure GP (zero trend)
        if isempty( dj )
            degrees = zeros(0, dim);
            usedIdx = [];
            return;
        end
        
        dj(1,:) = []; % remove constant (automatically included later on.)
        template = dj;
        
        obj.regression_max_order = repmat( size( dj, 1 ), dim, 1 );
        dj = cell(dim,1);
        for i=1:dim
            dj{i} = zeros( obj.regression_max_order(i,:), dim );
            dj{i}( :, i ) = template;
        end
    else
        dim = length(dj);
    end
    
    % Some sort of Kronecker product, generating every possible row combination
    
    % initialize degree matrix
    O = max( obj.regression_max_order );
    I = obj.reg_max_level_interactions;
    nrTerms = factorial(dim) ./ (factorial(I) .* factorial(dim-I));
    if dim == I %>< @note hack for 1D >linear trends.
        nrTerms = 0;
    end
    nrTerms = nrTerms .* O^I + dim.*O + 1;
    
    degrees = zeros(nrTerms, size(dj{1}, 2));
    freeIdx = 2; % next free spot in degrees. Constant is already included.
    
    count = size(dj{1}, 1 );
    degrees(freeIdx:freeIdx+count-1,:) = dj{1};
    freeIdx = freeIdx + count;
    
    usedIdx = cell(dim-1,1);
    
    % 'kronecker' loop
    for i=2:dim

        % degrees 1:
        useIdx = sum(degrees(1:freeIdx-1,:) > 0, 2) < obj.reg_max_level_interactions;
        degrees1 = degrees(useIdx,:);

        % degrees 2:
        degrees2 = dj{i};

        % generate idx'ces
        idx1 = 1:size(degrees1, 1);
        idx1 = idx1( ones(size(degrees2, 1),1), : );
        idx1 = idx1.';
        idx1 = idx1(:);

        idx2 = 1:size(degrees2, 1);
        idx2 = idx2( ones(size(degrees1, 1), 1), : );
        idx2 = idx2(:);

        count = size(idx1, 1 );
        degrees(freeIdx:freeIdx+count-1,:) = degrees1(idx1,:) + degrees2(idx2,:);
        freeIdx = freeIdx + count;
        
        usedIdx{i-1} = useIdx;
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


